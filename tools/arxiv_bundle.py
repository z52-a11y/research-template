"""arXiv 提出用の zip を作る。

使い方（リポジトリ直下で）:
    uv run python tools/arxiv_bundle.py              # arxiv プロファイルで描画してから zip を作る
    uv run python tools/arxiv_bundle.py --no-render  # 描画済みの manuscript/paper.tex から zip を作る

出力:
    _output/arxiv/arxiv-submission.zip
    （中身: paper.tex と、本文が読み込む図ファイル。arXiv はこの zip をそのまま受け付ける）

arXiv の提出画面では、TeX processor に xelatex を選ぶこと。
"""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_TEX = ROOT / "manuscript" / "paper.tex"
DEFAULT_ZIP = ROOT / "_output" / "arxiv" / "arxiv-submission.zip"
PROFILE_MARKER = "% quarto-profile: arxiv"
GRAPHIC_EXTS = (".pdf", ".png", ".jpg", ".jpeg")

INCLUDEGRAPHICS = re.compile(r"(\\includegraphics\s*(?:\[[^\]]*\])?\s*\{)([^}]+)(\})")
FONT_COMMANDS = re.compile(
    r"\\set(?:main|sans|mono|math|CJKmain|CJKsans|CJKmono)font\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}"
)
BIB_COMMANDS = re.compile(r"\\(?:bibliography|addbibresource)\s*\{([^}]+)\}")
INPUT_COMMANDS = re.compile(r"\\(?:input|include)\s*\{([^}]+)\}")


def render() -> None:
    quarto = shutil.which("quarto")
    if quarto is None:
        sys.exit("quarto コマンドが見つかりません。Quarto をインストールしてください。")
    command = [quarto, "render", "--profile", "arxiv"]
    print("実行:", " ".join(command))
    subprocess.run(command, cwd=ROOT, check=True)


def find_graphic(tex_dir: Path, ref: str) -> Path | None:
    """\\includegraphics の参照先を探す（拡張子なしの指定にも対応）。"""
    candidate = (tex_dir / ref).resolve()
    if candidate.suffix.lower() in GRAPHIC_EXTS and candidate.is_file():
        return candidate
    for ext in GRAPHIC_EXTS:
        with_ext = candidate.with_name(candidate.name + ext)
        if with_ext.is_file():
            return with_ext
    return None


def archive_name(tex_dir: Path, path: Path) -> str:
    """zip 内のパスを決める。原稿フォルダの外（../ など）にあるものは figures/ にまとめる。"""
    try:
        rel = PurePosixPath(path.relative_to(tex_dir).as_posix())
    except ValueError:
        rel = PurePosixPath("figures") / path.name
    if any(part.startswith(".") for part in rel.parts):
        rel = PurePosixPath("figures") / path.name
    return str(rel)


def main() -> int:
    parser = argparse.ArgumentParser(description="arXiv 提出用の zip を作る")
    parser.add_argument("--no-render", action="store_true", help="quarto render を実行しない")
    parser.add_argument("--tex", type=Path, default=DEFAULT_TEX, help="元になる .tex ファイル")
    parser.add_argument("--out", type=Path, default=DEFAULT_ZIP, help="作る zip ファイル")
    args = parser.parse_args()

    if not args.no_render:
        render()

    tex_path: Path = args.tex.resolve()
    if not tex_path.is_file():
        sys.exit(f"{tex_path} がありません。先に quarto render --profile arxiv を実行してください。")

    tex = tex_path.read_text(encoding="utf-8")
    if PROFILE_MARKER not in tex:
        sys.exit(
            f"{tex_path.name} は arxiv プロファイルで作られていません"
            "（uplatex プロファイルの .tex かもしれません）。--no-render を外して実行してください。"
        )

    tex_dir = tex_path.parent
    files: dict[str, Path] = {}
    warnings: list[str] = []

    def replace(match: re.Match[str]) -> str:
        ref = match.group(2).strip()
        found = find_graphic(tex_dir, ref)
        if found is None:
            warnings.append(f"図が見つかりません: {ref}")
            return match.group(0)
        name = archive_name(tex_dir, found)
        files[name] = found
        return f"{match.group(1)}{name}{match.group(3)}"

    bundled_tex = INCLUDEGRAPHICS.sub(replace, tex)

    for font in FONT_COMMANDS.findall(bundled_tex):
        if not font.lower().endswith((".otf", ".ttf")):
            warnings.append(
                f"フォント '{font}' が名前で指定されています。arXiv ではファイル名（例: xxx.otf）で指定してください。"
            )

    for bib in BIB_COMMANDS.findall(bundled_tex):
        bbl = tex_path.with_suffix(".bbl")
        if bbl.is_file():
            files[bbl.name] = bbl
        else:
            warnings.append(f"文献ファイル（{bib}）を使っていますが {bbl.name} がありません。")

    for included in INPUT_COMMANDS.findall(bundled_tex):
        warnings.append(f"\\input/\\include があります（{included}）。必要なら手動で zip に追加してください。")

    out: Path = args.out.resolve()
    out.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        zf.writestr(tex_path.name, bundled_tex)
        for name, path in sorted(files.items()):
            zf.write(path, name)

    print(f"\n作成しました: {out}")
    print(f"  {tex_path.name}")
    for name in sorted(files):
        print(f"  {name}")
    if warnings:
        print("\n確認が必要な点:")
        for message in warnings:
            print(f"  - {message}")
    print("\narXiv の提出画面で TeX processor に xelatex を選んでください。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

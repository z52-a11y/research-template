# research-template

Quarto で論文を書き、同じ原稿から次の4種類を出力するためのテンプレートです。

| 出力 | プロファイル | コマンド |
| --- | --- | --- |
| ブログ＋論文のHTML版（GitHub Pages） | website（既定） | `quarto preview` / `quarto render` |
| 日本語PDF（配布・OSF Preprints） | lualatex | `quarto render --profile lualatex` |
| 日本語PDF（(u)pLaTeX 指定の和文誌） | uplatex | `quarto render --profile uplatex` |
| arXiv 提出用 zip（XeLaTeX） | arxiv | `uv run python tools/arxiv_bundle.py` |

## 必要なもの

Quarto、TeX Live（フル）、uv（Python）、Git。Mathematica は任意です。
導入手順は別紙の手順書を参照してください。

## はじめ方（Windows）

1. GitHub でこのリポジトリの **Use this template** → **Create a new repository** を押す。
2. 手元に複製して初期設定する。

   ```powershell
   cd C:\dev
   gh repo clone <ユーザー名>/<新しいリポジトリ名>
   cd <新しいリポジトリ名>
   powershell -ExecutionPolicy Bypass -File tools\setup.ps1
   ```

3. `quarto preview` でサイトを確認し、`quarto render --profile lualatex` で PDF を作る。
4. 最初の push の前に、GitHub の Settings → Pages → Source を「GitHub Actions」にする。

## フォルダ構成

```
_quarto.yml            共通設定（プロファイル共通）
_quarto-<名前>.yml     プロファイルごとの設定（website / lualatex / uplatex / arxiv）
_partials/uplatex/     upLaTeX 用に差し替える LaTeX ひな形
manuscript/            原稿 paper.qmd、文献 references.bib、図 figures/、データ data/、latexmkrc
posts/                 ブログ記事
notebooks/             試行錯誤用ノートブック（Python / Wolfram Language）
tools/                 setup.ps1（初期設定）、arxiv_bundle.py（arXiv 用 zip）
docs/                  AI エージェント向けの詳細ルール
AGENTS.md / CLAUDE.md  AI エージェント共通の基本ルール
CITATION.cff           引用情報（GitHub と Zenodo が読む）
```

## 計算結果の凍結（freeze）

`execute: freeze: auto` により、計算結果は `_freeze/` に保存されます。
原稿を変えたら手元で `quarto render` してから、`_freeze/` も含めてコミットしてください。
Mathematica の結果は図やデータとして `manuscript/figures/` などに書き出して取り込みます。

## DOI（Zenodo）

Zenodo に GitHub アカウントでログインし、このリポジトリを有効にしてから GitHub で Release を作ると、
Zenodo が版ごとに DOI を付けます。リリース前に `CITATION.cff` の `version` と `date-released` を更新してください。

## arXiv と OSF Preprints

- arXiv は LuaLaTeX に非対応です。`uv run python tools/arxiv_bundle.py` で作った zip を提出し、TeX processor に xelatex を選びます。
- OSF Preprints には lualatex プロファイルの PDF をアップロードします。

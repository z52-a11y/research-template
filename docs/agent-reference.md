# エージェント用リファレンス

AGENTS.md から必要なときだけ参照する詳細ルール。人間が読んでもよい。

## プロファイル

| プロファイル | コマンド | 出力 | 用途 |
| --- | --- | --- | --- |
| website（既定） | `quarto render` / `quarto preview` | `_site/` | ブログと論文HTML。GitHub Pages で公開 |
| lualatex | `quarto render --profile lualatex` | `_output/lualatex/` | 日本語PDF。配布・OSF Preprints |
| uplatex | `quarto render --profile uplatex` | `_output/uplatex/`, `manuscript/paper.tex` | (u)pLaTeX 指定の和文誌 |
| arxiv | `uv run python tools/arxiv_bundle.py` | `_output/arxiv/arxiv-submission.zip` | arXiv 提出（XeLaTeX） |

- 共通設定は `_quarto.yml`、プロファイルごとの設定は `_quarto-<名前>.yml`。
- `project.render` と `format` は共通側に書かない（全プロファイルに混ざるため）。
- upLaTeX 用の差し替えひな形は `_partials/uplatex/`、latexmk の設定は `manuscript/latexmkrc`。

## フォルダ

- `manuscript/` 原稿（`paper.qmd`）、文献（`references.bib`）、図（`figures/`）、データ（`data/`）
- `posts/` ブログ記事（`posts/YYYY-MM-DD-name/index.qmd`）
- `notebooks/` 試行錯誤用のノートブック（Python、Wolfram Language）
- `tools/` 補助スクリプト（`setup.ps1`、`arxiv_bundle.py`）

## 計算と凍結（freeze）

- `execute: freeze: auto` により、計算結果は `_freeze/` に保存される。原稿を変えたら手元で render し、`_freeze/` もコミットする。
- GitHub Actions は Python を用意するが、Mathematica は使えない。Mathematica の結果は必ずファイルに書き出して取り込む。
- Quarto の1文書で使えるカーネルは1つ。原稿の中のコードは Python に統一する。

## arXiv

- arXiv は LuaLaTeX と upLaTeX に非対応。arxiv プロファイル（XeLaTeX）を使う。
- フォントはファイル名で指定する（例: `HaranoAjiMincho-Regular.otf`）。
- TeX から作った PDF だけの提出は原則受け付けられない。zip（.tex と図）を提出する。
- 提出画面で TeX processor に xelatex を選ぶ。

## 公開と DOI

- サイト: main に push すると `.github/workflows/publish.yml` が website プロファイルを描画して公開する。
- DOI: GitHub と Zenodo を連携し、GitHub で Release を作ると Zenodo が版ごとに DOI を付ける。メタデータは `CITATION.cff`。
- リリース前に `CITATION.cff` の `version` と `date-released` を更新する。

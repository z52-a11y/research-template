# AGENTS.md（Codex・Cursor・Claude Code 共通のルール）

- 目的: このリポジトリは論文1本と公開サイトを管理する。原稿は `manuscript/paper.qmd`。
- 言語: 本文・コメント・コミットメッセージは日本語で書く。
- 確認: 原稿を変えたら `quarto render --profile lualatex` が通ることを確かめる。
- 計算: Python は原稿の中か `notebooks/` で行う。Mathematica は `notebooks/*.wls` に書いて `wolframscript -file` で実行し、結果を図やデータに書き出して `manuscript/figures/` などから読み込む。
- コマンド: Jupyter などは `uv run python -m <モジュール>` の形で実行する。`.venv\Scripts` の .exe は Windows に止められることがある。
- 図: 新しい図は Python（matplotlib）で作る。図の画像を手で直さず、生成元（Python、ノートブック、`.wls`、`manuscript/figures/*.gp`）を直す。gnuplot の図はリポジトリ直下で `gnuplot <ファイル>` を実行して作り直す。
- 引用: 文献は `manuscript/references.bib` に追加して `[@key]` で引用する。実在を確認できない文献を作らない。
- 生成物: `_site/`・`_output/`・`*.tex` は手で編集しない。`_freeze/` は render で更新してコミットする。
- 秘密情報: APIキーやパスワードをファイルに書かない。
- 進め方: 大きな変更の前に、方針を短く提案して確認を取る。
- 詳細: プロファイル、公開、arXiv・Zenodo の手順は必要なときだけ `docs/agent-reference.md` を読む。

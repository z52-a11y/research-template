# AGENTS.md（Codex・Cursor・Claude Code 共通のルール）

- 目的: このリポジトリは論文1本と公開サイトを管理する。原稿は `manuscript/paper.qmd`。
- 言語: 本文・コメント・コミットメッセージは日本語で書く。
- 確認: 原稿を変えたら `quarto render --profile lualatex` が通ることを確かめる。
- 計算: Python は原稿の中か `notebooks/` で行う。Mathematica の結果は図やデータに書き出し、`manuscript/figures/` などから読み込む。
- 図: 図の画像を手で直さない。生成元のコードやノートブックを直す。
- 引用: 文献は `manuscript/references.bib` に追加して `[@key]` で引用する。実在を確認できない文献を作らない。
- 生成物: `_site/`・`_output/`・`*.tex` は手で編集しない。`_freeze/` は render で更新してコミットする。
- 秘密情報: APIキーやパスワードをファイルに書かない。
- 進め方: 大きな変更の前に、方針を短く提案して確認を取る。
- 詳細: プロファイル、公開、arXiv・Zenodo の手順は必要なときだけ `docs/agent-reference.md` を読む。

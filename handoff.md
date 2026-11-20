# Handoff: Dotfiles 改善・整理タスク

このファイルは、dotfiles リポジトリの改善作業を次回セッションへ引き継ぐためのメモです。
全タスクが完了したらこのファイルは削除してください。

## 前提・進め方のルール

* **方針**: 依存が少なくシンプルな構成を好む
* **進め方**: `grill-me` 形式で **1問ずつ** 確認しながら進める
* **説明の粒度**: 専門用語（shebang、`set -euo pipefail` など）を前提にせず、「何が問題で、どう変わると何が嬉しいか」を毎回丁寧に説明する
* **待機ルール**: ユーザーがエスケープ（スキップ）した場合は、勝手に次の質問へ進まず、ユーザーからのメッセージを待つ
* **動作確認**: `.zshrc` 等の設定を変更した場合は、既存スクリプトが今まで通り動くか確認するための **動作確認範囲** を提示する
* **コミット**: 承認・反映した変更は、論理単位ごとに小さくコミットする（他の未コミット変更を巻き込まないよう注意）

---

## 完了済みの項目

* `c71a7f3` `AGENTS.md` にセットアップスクリプトの冪等性ルール・ローカルパス混入防止ルールを追記
* `256b0ea` `.gitignore` に `.claude/.cc-writes` を追加、不要な `strike-trio` を削除
* `0674049` `setup2-rc.sh` に `gemini/statusline-command.sh` のリンクを追加、同スクリプトの `python3` 依存を `awk` に置換
* `0b43e24` `codex/config.toml` からマシン固有の `[projects."..."]` パスを削除
* `8020b90` `Brewfile` から未使用の `tap "olets/tap"` を削除（`zinit` は維持する方針で確定）
* `95ce6ab` `.gitconfig` の pager を `delta` → `diff-highlight` に切り替え、`[diff]` 設定を強化（`Brewfile` から `git-delta` 削除）
* `32ac802` `Brewfile` から `git-filter-repo`、`imagemagick` を削除
* `6209c17` コード検索を `ack` → `ripgrep` (`rg`) に置き換え（`Brewfile` + `.zshrc` の `fzf-rg-search`、動作確認済み）
* `Brewfile` 棚卸し完了（現在の CLI・cask はすべて現役であることを確認済み）

---

## 残タスク

### 1. セットアップスクリプトの整理（ここで中断中）
* **1-1. shebang 統一とエラーハンドリング**
  * `setup1-brew.sh`（`#!/bin/bash`）、`setup2-rc.sh`（古い `#!/usr/local/bin/zsh`）、`setup3-macdefaults.sh`（shebang なし）を `#!/usr/bin/env bash` ＋ `set -euo pipefail` に統一するか確認（`brew doctor` / `brew bundle cleanup` は `|| true` でガード、`README.md` の `sh` も `bash` に揃える）
* **1-2. `setup3-macdefaults.sh` の整理**
  * 19行目と45行目で重複している `killall Dock` の削除
  * 再実行のたびに Spotlight インデックスを全再構築してしまう `sudo mdutil -E /` のコメントアウト
  * 現行 macOS では効かない古いバッテリー設定（`com.apple.menuextra.battery ShowPercent`）の削除

### 2. `.zshrc` / `abbreviations` の修正・高速化
* `~/.zshrc_private` と `~/.vite-plus/env` の読み込みにファイル存在チェック（`[[ -f ... ]]`）を追加
* `abbreviations` 20行目の `gwa`（ダブルクォートでファイル読み込み時に `$(pwd)` や `$(git ...)` が展開されてしまう問題）の修正
* `fzf_cd`（`^s`）の改善：
  * キャンセル時の空実行・スペースを含むパスでの破損を防止
  * `fd . ~` の探索範囲を `~/Workspaces` 等に絞るか、`cdr` / `zoxide` を使うか検討

### 3. `.gitconfig` の追加改善（依存ゼロ）
* 以下の設定を追加するか検討：
  * `rerere.enabled = true`（一度解決したコンフリクトを記憶して自動解決）
  * `fetch.prune = true`（リモートで削除されたブランチ参照を自動掃除）
  * `commit.verbose = true`（`git commit` / `git duet-commit` 等で常に diff を表示）
  * `core.excludesfile = ~/.gitignore_global`（`.DS_Store` 等を全リポジトリで一括無視）

### 4. Karabiner-Elements のシンボリックリンク自動化
* `tools/karabiner/*.json` を `setup2-rc.sh` から `~/.config/karabiner/assets/complex_modifications/` へシンボリックリンクし、手動インポートを省くか検討（変更する場合は `README.md` も更新）

### 5. Vim 構成の見直し（後回しにしていた項目）
* `.vimrc` / `dein.toml` の扱いを確認：
  * `dein.vim`（開発終了）・`vimproc.vim`・`coc.nvim`（Node.js 依存）・`lightline.vim`・`indentLine`・`vim-toml` を外して純粋な `.vimrc` のみにするか、一部だけ残すか決定
  * `.vimrc` 内の未導入プラグイン `EasyAlign` マッピング（157行目）や、`netrw_banner` の値とコメントの不整合（199行目）の整理
  * `dein.toml` を削除する場合は `setup2-rc.sh` と `README.md` も更新

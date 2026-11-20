# Dotfiles
macOS向けの個人の開発環境設定です。
zsh, vim, gitなどの設定と、各種ツールを自動でインストールするスクリプトが含まれています。

## スクリーンショット
**Zsh (Starship)**

![ 2020-05-09 14 43 12](https://user-images.githubusercontent.com/783878/81465235-83ae0b00-9203-11ea-9a2d-102abd0a8083.png)

## 導入手順
以下のスクリプトを順番に実行してください。

```bash
git clone --recurse-submodules git@github.com:ir77/dotfiles.git
sh setup1-brew.sh        # Homebrewのインストール・更新と、Brewfileにあるツールのインストール
sh setup2-rc.sh          # 設定ファイルのシンボリックリンクを作成
sh setup3-macdefaults.sh # macOSのシステム設定（Dock、Finderなど）
```

`setup2-rc.sh` の実行後、Gitのユーザー情報を `~/.gitconfig.local` に設定してください（スクリプトが案内を表示します）。

### 更新

```bash
git pull
git submodule update --remote
```

## ファイル構成

### セットアップスクリプト

| ファイル | 内容 |
| --- | --- |
| `setup1-brew.sh` | Homebrewをインストール・更新し、`brew bundle` で `Brewfile` のツールを入れる。最後に `brew bundle dump` で `Brewfile` を**インストール済みの状態から再生成する** |
| `setup2-rc.sh` | リポジトリ内の設定ファイルをホームディレクトリへシンボリックリンクする |
| `setup3-macdefaults.sh` | `defaults write` でmacOSの設定を変更する |

### 設定ファイル

| ファイル / ディレクトリ | リンク先 | 内容 |
| --- | --- | --- |
| `Brewfile` | - | HomebrewでインストールするCLIツール・GUIアプリの一覧 |
| `.zshrc` | `~/.zshrc` | Zshのメイン設定。マシン固有の設定やトークンは `~/.zshrc_private`（Git管理外）に書く |
| `abbreviations` | `~/.config/zsh/abbreviations` | [zsh-abbr](https://github.com/olets/zsh-abbr) の略語定義 |
| `starship.toml` | `~/.config/starship.toml` | [Starship](https://starship.rs/) プロンプトの設定 |
| `.vimrc`, `dein.toml` | `~/.vimrc`, `~/.vim/rc/dein.toml` | Vimの設定とプラグイン一覧 |
| `.gitconfig` | `~/.gitconfig` | Gitの設定。ユーザー情報は `~/.gitconfig.local`（Git管理外）に書く |
| `claude/` | `~/.claude/` | Claude Codeの設定とステータスライン |
| `codex/` | `~/.codex/` | Codex CLIの設定 |
| `gemini/` | `~/.gemini/` | Gemini CLIの設定とステータスライン |
| `antigravity/` | `~/.gemini/antigravity-cli/` | Antigravity CLIのステータスライン |
| `.claude/skills/`, `.agents/skills/`, `skills-lock.json` | `~/.claude/skills` | AIエージェント用のスキル |
| `iterm/` | - | iTerm2の設定。iTerm2の「Load preferences from a custom folder」でこのディレクトリを指定する |
| `tools/karabiner/` | - | Karabiner-Elementsの Complex Modifications（手動でインポートする） |
| `tools/tab-counter/` | - | Chrome拡張機能（Gitサブモジュール） |

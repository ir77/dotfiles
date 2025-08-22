# Dotfiles

macOS向けの個人の開発環境設定（dotfiles）です。
zsh, vim, gitなどの設定と、各種ツールを自動でインストールするスクリプトが含まれています。

## 特徴

-   **Zsh**: [Starship](https://starship.rs/)によるモダンで情報リッチなプロンプト。
-   **Vim**: [Dein.vim](https://github.com/Shougo/dein.vim)によるプラグイン管理。入力補完やステータスラインのカスタマイズが含まれます。
-   **自動セットアップ**: Homebrewを使い、`Brewfile`に記載された多くのCLIツールやGUIアプリケーションを自動でインストールします。
-   **macOS設定**: DockやFinder、トラックパッドなどのmacOSのシステム設定も自動化します。

## スクリーンショット

**Zsh (Starship)**
![ 2020-05-09 14 43 12](https://user-images.githubusercontent.com/783878/81465235-83ae0b00-9203-11ea-9a2d-102abd0a8083.png)

## 導入手順

1.  **リポジトリのクローン**:
    ```bash
    git clone https://github.com/[your_username]/[this_repo].git
    cd [this_repo]
    ```

2.  **セットアップスクリプトの実行**:
    以下のスクリプトを順番に実行してください。

    ```bash
    sh setup1-brew.sh      # HomebrewとBrewfileにあるツールをインストール
    sh setup2-git.sh       # Gitの基本設定
    sh setup3-macdefaults.sh # macOSのシステム設定
    sh setup4-rc.sh        # 設定ファイル（.zshrc, .vimrcなど）のシンボリックリンクを作成
    ```

3.  **Gitの個人情報設定**:
    セットアップ後、Gitのユーザー情報を設定してください。
    ```bash
    git config --global user.name "あなたの名前"
    git config --global user.email "あなたのメールアドレス"
    ```
4. **ターミナルの再起動**:
   すべての設定を反映させるために、iTerm2などのターミナルアプリケーションを再起動してください。


## カスタマイズ

設定はいくつかのファイルで管理されています。必要に応じてこれらを編集してください。

-   **インストールするツール**: `Brewfile` に追記・削除してください。
-   **Zshの設定**: `~/.zshrc` (このリポジトリの `.zshrc` がリンクされます)
-   **Vimの設定**: `~/.vimrc` と `~/.vim/rc/dein.toml`
-   **シェルのプロンプト**: `~/.config/starship.toml`

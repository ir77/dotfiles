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
sh setup1-brew.sh        # HomebrewとBrewfileにあるツールをインストールと更新
sh setup2-git.sh         # Gitの基本設定
sh setup3-macdefaults.sh # macOSのシステム設定
sh setup4-rc.sh          # 設定ファイル（.zshrc, .vimrcなど）のシンボリックリンクを作成
```

### 更新

```bash
git pull
git submodule update --remote
```


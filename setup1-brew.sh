
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）
# - .sshの確認

xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew update
brew doctor

# brew 

## using .zshrc
brew install starship # prompt https://starship.rs/ja-JP/
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install olets/tap/zsh-abbr
brew install ack
brew install fzf
brew install fd
brew install bat
brew install thefuck
brew install trash

## frequently used commands
brew install jq
brew install tig

## for vim commands
brew install vim
brew install lua
brew install nodebrew

## This command may be unnecessary and could be deleted
brew install git

# brew cask
## tools
brew install --cask google-japanese-ime # 設定後に再起動の必要あり
brew install --cask karabiner-elements
brew install --cask rectangle

## font
brew install --cask font-roboto-mono-for-powerline

## applications
brew install --cask iterm2
brew install --cask google-chrome
brew install --cask xcodes
brew install --cask visual-studio-code
brew install --cask intellij-idea
brew install --cask android-studio

# Setup Node
mkdir -p ~/.nodebrew/src
nodebrew install-binary stable
nodebrew ls | xargs nodebrew use

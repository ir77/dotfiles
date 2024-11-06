
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）
# - .sshの確認

xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew update
brew doctor

# brew 
brew install starship # prompt https://starship.rs/ja-JP/
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install olets/tap/zsh-abbr
brew install vim
brew install lua
brew install git
brew install tig
brew install ack
brew install fzf
brew install fd
brew install bat
brew install jq
brew install thefuck
brew install trash

# brew cask
brew install --cask google-chrome
brew install --cask google-japanese-ime # 設定後に再起動の必要あり
brew install --cask karabiner-elements
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask intellij-idea
brew install --cask android-studio
brew install --cask xcodes
brew install --cask rectangle
brew install --cask font-roboto-mono-for-powerline

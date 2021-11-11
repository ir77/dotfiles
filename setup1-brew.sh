
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）
# - .sshの確認

xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew update
brew doctor

brew install zsh
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install peco
brew install thefuck
brew install git
brew install nkf
brew install tig
brew install lua
brew install vim
brew install trash
brew install ffmpeg
brew install gifsicle
brew install ack
brew install fd
brew install dust
brew install broot
brew install jq
brew install tldr
brew install anyenv
brew install stack
brew install carthage
brew install mysql
brew install nodebrew
brew install rustup-init
brew install deno
brew install starship


brew install --cask google-chrome
brew install --cask google-japanese-ime # 設定後に再起動の必要あり
brew install --cask caffeine
brew install --cask karabiner-elements
brew install --cask shiftit
brew install --cask kindle
brew install --cask iterm2
brew install --cask slack
brew install --cask deepl
brew install --cask visual-studio-code
brew install --cask intellij-idea
brew install --cask jetbrains-toolbox
brew install --cask android-studio
brew install --cask flutter

# brew search powerline 他のが気になったらこれで探す
# brew install homebrew/cask-fonts/font-anonymice-powerline
# brew install homebrew/cask-fonts/font-consolas-for-powerline
# brew install homebrew/cask-fonts/font-fira-mono-for-powerline
# brew install homebrew/cask-fonts/font-inconsolata-dz-for-powerline
# brew install homebrew/cask-fonts/font-liberation-mono-for-powerline
brew install svn
brew install homebrew/cask-fonts/font-roboto-mono-for-powerline

anyenv init

# Xcode Setup
sudo gem install cocoapods

# Haskell Setup
stack setup

# rust Setup
rustup-init

# Setup Node
mkdir -p ~/.nodebrew/src
nodebrew install-binary stable
nodebrew ls | xargs nodebrew use

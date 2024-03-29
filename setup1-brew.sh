
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）
# - .sshの確認

xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew update
brew doctor

brew install zsh-completions
brew install zsh-syntax-highlighting
brew install fzf
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
brew install bat
brew install jq
brew install tldr
brew install rbenv ruby-build
brew install stack
brew install carthage
brew install mysql
brew install nodebrew
brew install rustup-init
brew install deno
brew install swiftformat
brew install starship
brew install olets/tap/zsh-abbr

brew install --cask google-chrome
brew install --cask google-japanese-ime # 設定後に再起動の必要あり
brew install --cask caffeine
brew install --cask karabiner-elements
brew install --cask kindle
brew install --cask iterm2
brew install --cask slack
brew install --cask deepl
brew install --cask visual-studio-code
brew install --cask intellij-idea
brew install --cask android-studio
brew install --cask flutter
brew install --cask xcodes
brew install --cask rectangle
brew install --cask copilot-for-xcode

brew install svn # for font install
brew install --cask homebrew/cask-fonts/font-roboto-mono-for-powerline

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

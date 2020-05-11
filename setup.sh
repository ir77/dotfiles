
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）
# - .sshの確認

xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor

brew install zsh
brew install peco
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install thefuck
brew install starship
brew install git
brew install nkf
brew install tig
brew install lua
brew install vim
brew install trash
brew install ffmpeg
brew install gifsicle
brew install reattach-to-user-namespace
brew install ctags
brew install ack
brew install stack
brew install carthage
brew install fd
brew install mysql
brew install nodebrew
brew install jq
brew install rustup-init
brew install anyenv

brew cask install google-chrome
brew cask install caffeine
brew cask install google-japanese-ime # 設定後に再起動の必要あり
brew cask install karabiner-elements
brew cask install xquartz
brew cask install appcleaner
brew cask install dash    
brew cask install iterm2
brew cask install shiftit
brew cask install sketch
brew cask install dropbox
brew cask install kindle
brew cask install visual-studio-code
brew cask install intellij-idea
brew cask install android-studio
brew cask install slack
brew cask install deepl

mas install 961632517 #Be Focused Pro (1.7.9)
mas install 967805235 #Paste (2.6.2)

# brew search powerline 他のが気になったらこれで探す
# brew install homebrew/cask-fonts/font-anonymice-powerline
# brew install homebrew/cask-fonts/font-consolas-for-powerline
# brew install homebrew/cask-fonts/font-fira-mono-for-powerline
# brew install homebrew/cask-fonts/font-inconsolata-dz-for-powerline
# brew install homebrew/cask-fonts/font-liberation-mono-for-powerline
brew install homebrew/cask-fonts/font-roboto-mono-for-powerline

anyenv init

# Java Setup
brew tap homebrew/cask-versions
brew cask install java11

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
npm install -g yarn


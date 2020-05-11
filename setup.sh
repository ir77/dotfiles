
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

brew tap homebrew/cask-versions
brew cask install java11

# brew search powerline 他のが気になったらこれで探す
# brew install homebrew/cask-fonts/font-anonymice-powerline
# brew install homebrew/cask-fonts/font-consolas-for-powerline
# brew install homebrew/cask-fonts/font-fira-mono-for-powerline
# brew install homebrew/cask-fonts/font-inconsolata-dz-for-powerline
# brew install homebrew/cask-fonts/font-liberation-mono-for-powerline
brew install homebrew/cask-fonts/font-roboto-mono-for-powerline

sudo gem install cocoapods

anyenv init

# Xcodeにビルド時間を表示する
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

# スクリーンショットを英語に
defaults write com.apple.screencapture name ""

# Dock
defaults write com.apple.dock persistent-apps -array #Dock に標準で入っている全てのアプリを消す、Finder とごみ箱は消えない
defaults write com.apple.dock autohide -bool true
killall Dock

# keyboard
defaults write -g com.apple.keyboard.fnState -bool true

# finder
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder QuitMenuItem -bool true

# trackpad 
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Spotlight
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled"=1;"name"="APPLICATIONS";}' \
    '{"enabled"=1;"name"="MENU_CONVERSION";}' \
    '{"enabled"=1;"name"="MENU_EXPRESSION";}' \
    '{"enabled"=1;"name"="MENU_DEFINITION";}' \
    '{"enabled"=1;"name"="SYSTEM_PREFS";}' \
    '{"enabled"=1;"name"="BOOKMARKS";}' \
    '{"enabled"=1;"name"="MENU_OTHER";}' \
    '{"enabled"=0;"name"="MENU_SPOTLIGHT_SUGGESTIONS";}' \
    '{"enabled"=0;"name"="DOCUMENTS";}' \
    '{"enabled"=0;"name"="DIRECTORIES";}' \
    '{"enabled"=0;"name"="PRESENTATIONS";}' \
    '{"enabled"=0;"name"="SPREADSHEETS";}' \
    '{"enabled"=0;"name"="PDF";}' \
    '{"enabled"=0;"name"="MESSAGES";}' \
    '{"enabled"=0;"name"="CONTACT";}' \
    '{"enabled"=0;"name"="EVENT_TODO";}' \
    '{"enabled"=0;"name"="IMAGES";}' \
    '{"enabled"=0;"name"="MUSIC";}' \
    '{"enabled"=0;"name"="MOVIES";}' \
    '{"enabled"=0;"name"="FONTS";}' \
    '{"enabled"=0;"name"="SOURCE";}' \

## index再生成
killall mds 
sudo mdutil -i on /
sudo mdutil -E /

# バッテリーのパーセントを表示する
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Kill affected applications
for app in Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1; done

# Haskell Setup
stack setup

# rust Setup
rustup-init

# Setup Node
mkdir -p ~/.nodebrew/src
nodebrew install-binary stable
nodebrew ls | xargs nodebrew use
npm install -g yarn

echo 'git settings'
git config --global push.default matching
git config --global push.default simple # git pushでcurrentブランチだけアップデートする
git config --global core.editor vim
git config --global core.quotepath false # git statusで日本語文字の文字化けを防ぐ

echo 'git config --global user.name "user"'
echo 'git config --global user.email "email"'

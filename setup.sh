
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）
# .ssh, Photos, iTunes

## afeter
# Xcode, Line
# MSOffice, Adobe, Locamatic

# AA by http://ascii.mastervb.net font xttyb.flf
cat << EOS
                             #### ####                         ##       
####              ##           ##   ##     ##  #               ##       
 ##  # ##   #### #####  ###    ##   ##     ##  #  ###  ###   ####  ###  
 ##  ## ## ##     ##      ##   ##   ##      ###  ##   ## ## ## ## ## ## 
 ##  ## ## ####   ##    ####   ##   ##       #   ##   ## ## ## ## ## ## 
 ##  ## ##  ####  ##   ## ##   ##   ##      ###  ##   ## ## ## ## ##### 
 ##  ## ##    ##  ##   ## ##   ##   ##     #  ## ##   ## ## ## ## ##    
#### ## ## ####    ###  ## #   ##   ##     #  ##  ###  ###   ## #  #### 
EOS

xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor

brew install zsh
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
brew install peco
brew install ack
brew install ghq
brew install stack
brew install thefuck
brew install carthage
brew install fd
brew install mysql
# brew install tmux  
# brew install cloudfoundry/tap/cf-cli

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
brew cask install paste
brew cask install kindle
brew cask install visual-studio-code
brew cask install intellij-idea
brew cask install android-studio
brew cask install slack
brew cask install mobster
# brew cask install caskroom/homebrew-versions/java6
# brew cask install virtualbox 
# brew cask install vagrant
# brew cask install Cyberduck

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

# git clone https://github.com/riywo/anyenv ~/.anyenv
# anyenv install rbenv

# Xcodeにビルド時間を表示する
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

# スクリーンショットを英語に
defaults write com.apple.screencapture name ""

# Haskell Setup
stack setup

echo 'git settings'
git config --global push.default matching
git config --global push.default simple # git pushでcurrentブランチだけアップデートする
git config --global core.editor vim

echo 'git config --global user.name "user"'
echo 'git config --global user.email "email"'


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
brew tap caskroom/cask

brew install zsh
brew install git
brew install nkf
brew install tig
brew install lua
brew install vim --with-lua
brew install trash
brew install ffmpeg
brew install gifsicle
brew install tmux  
brew install reattach-to-user-namespace
brew install ctags
brew install peco
brew install ack
brew install ghq

brew cask install google-chrome
# brew cask install dropbox
brew cask install caffeine
brew cask install google-japanese-ime
# brew cask install atom
brew cask install karabiner
brew cask install xquartz
brew cask install appcleaner
# brew cask install caskroom/homebrew-versions/java6
# brew cask install intellij-idea
# brew cask install virtualbox 
# brew cask install vagrant
brew cask install dash    
brew cask install iterm2
# brew cask install rescuetime
# brew cask install Cyberduck

brew tap sanemat/font
brew install ricty
brew reinstall --powerline --vim-powerline ricty
cp -f /usr/local/Cellar/ricty/3.2.4/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

sudo gem install cocoapods
# sudo gem install tldrb

git clone https://github.com/tomislav/osx-terminal.app-colors-solarized
echo 'set terminal colors to solarized'

# defaults delete NSGlobalDomain KeyRepeat ＃Defaultに戻す
defaults write NSGlobalDomain KeyRepeat -int 1
# defaults delete NSGlobalDomain InitialKeyRepeat # Defaultに戻す
defaults write NSGlobalDomain InitialKeyRepeat -int 1

# Xcodeにビルド時間を表示する
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

# スクリーンショットを英語に
defaults write com.apple.screencapture name ""

echo 'git settings'
git config --global push.default matching
git config --global alias.glog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
git config --global alias.cm "commit -m"
git config --global alias.st "status --branch --short"
git config --global alias.co "checkout"
git config --global alias.fp "fetch --prune"

echo 'git config --global user.name "user"'
echo 'git config --global user.email "email"'

# TODO
## before
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）
# .ssh, Photos, iTunes

## afeter
# Xcode, Line
# MSOffice, Adobe, Locamatic

xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor
brew install caskroom/cask/brew-cask

# Packages for development
brew install zsh
brew install git
brew install nkf
brew install tig
brew install lua
brew install vim --with-lua
brew install trash
brew install ffmpeg
brew install gifsicle
brew install node
brew install mysql
brew install tmux  
brew install pup
#brew install homebrew/dupes/bc
#brew install libmpdclient
#brew install https://raw.github.com/Homebrew/homebrew-dupes/master/grep.rb
brew install reattach-to-user-namespace
# brew install coreutils

# .dmg from brew-cask
brew cask install google-chrome
brew cask install dropbox
brew cask install caffeine
brew cask install google-japanese-ime
brew cask install skype
brew cask install atom
brew cask install karabiner
brew cask install xquartz
brew cask install appcleaner
brew cask install caskroom/homebrew-versions/java6
brew cask install intellij-idea
brew cask install virtualbox 
brew cask install vagrant
brew cask install dash    
brew cask install the-unarchiver
brew cask install vlc
brew cask install alfred

brew tap peco/peco
brew install peco

brew tap sanemat/font
brew install ricty
brew reinstall --powerline --vim-powerline ricty
cp -f /usr/local/Cellar/ricty/3.2.4/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

sudo easy_install pip
sudo pip install beautifulsoup4

sudo gem install cocoapods
sudo gem install tldrb

git clone https://github.com/tomislav/osx-terminal.app-colors-solarized
echo 'set terminal colors to solarized'

# スクリーンショットを英語に
defaults write com.apple.screencapture name ""

echo 'other settings'
echo 'git config --global user.name "user"'
echo 'git config --global user.email "email"'

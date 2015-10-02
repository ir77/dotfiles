# TODO
## before
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）

## afeter
# Xcode, Line
# MSOffice, Adobe, Locamatic
# .ssh, photos, iTunes

# sudo xcodebuild -license
# xcode-select --install
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
# brew install coreutils

# .dmg from brew-cask
brew-cask install google-chrome
brew-cask install dropbox
brew-cask install iterm2
brew-cask install caffeine
brew-cask install google-japanese-ime
brew-cask install skype
brew-cask install atom
brew-cask install karabiner
brew-cask install xquartz

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

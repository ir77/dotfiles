# TODO
## before
# - iTunes認証解除
# - iCloudサインアウト（Macを探すの解除）

## afeter
# App Store
# Xcode, Line

# Other
# MSOffice, Adobe
# .ssh, photos, iTunes

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor
brew install caskroom/cask/brew-cask

brew tap sanemat/font
brew install ricty
cp -f /usr/local/Cellar/ricty/3.2.3/share/fonts/Ricty*.ttf ~/Library/Fonts/
brew reinstall --powerline --vim-powerline ricty
cp -f /usr/local/Cellar/ricty/3.2.4/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

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
brew-cask install xquartz
brew-cask install caffeine
brew-cask install karabiner
brew-cask install google-japanese-ime
brew-cask install skype

ln -snf ~/Dropbox/Backup/SymbolicLink/dotfiles/.zshrc ~/
ln -snf ~/Dropbox/Backup/SymbolicLink/dotfiles/.zshrc.private ~/
ln -snf ~/Dropbox/Backup/SymbolicLink/dotfiles/.vimrc ~/

brew tap peco/peco
brew install peco

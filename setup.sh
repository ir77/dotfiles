ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
brew install caskroom/cask/brew-cask
defaults write com.apple.dock no-bouncing -bool true

brew tap sanemat/font
brew install ricty
cp -f /usr/local/Cellar/ricty/3.2.3/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
git clone https://github.com/ir77/dotfiles.git ~/Desktop/

ln -snf ~/Desktop/dotfiles/.zshrc ~/                                                               
ln -snf ~/Desktop/dotfiles/.vimrc ~/

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

brew tap peco/peco
brew install peco

brew tap caskroom/versions
brew cask search java
brew cask install java7

sudo gem install tw

curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh

# do
# sudo mv /usr/bin/vim /usr/bin/old_vim
# sudo ln /usr/local/Cellar/vim/7.4.hoge/bin/vim /usr/bin/

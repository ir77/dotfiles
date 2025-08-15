#!/usr/local/bin/zsh

# Setup Zsh
ln -snf "$(cd $(dirname $0) && pwd)/.zshrc" ~/
mkdir -p ~/.config/zsh 
ln -snf "$(cd $(dirname $0) && pwd)/abbreviations" ~/.config/zsh/abbreviations

# Setup Vim
mkdir -p ~/.vim/rc
ln -snf "$(cd $(dirname $0) && pwd)/dein.toml" ~/.vim/rc
ln -snf "$(cd $(dirname $0) && pwd)/.vimrc" ~/

# Setup Other
ln -snf "$(cd $(dirname $0) && pwd)/starship.toml" ~/.config


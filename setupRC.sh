#!/usr/local/bin/zsh

# Setup Zsh
echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh
ln -snf "$(cd $(dirname $0) && pwd)/.zshrc" ~/

mkdir -p ~/.vim/rc
ln -snf "$(cd $(dirname $0) && pwd)/dein.toml" ~/.vim/rc
ln -snf "$(cd $(dirname $0) && pwd)/dein_lazy.toml" ~/.vim/rc
ln -snf "$(cd $(dirname $0) && pwd)/.vimrc" ~/
ln -snf "$(cd $(dirname $0) && pwd)/coc-settings.json" ~/.vim

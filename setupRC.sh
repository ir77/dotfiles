mkdir -p ~/.vim/rc
ln -snf "$(cd $(dirname $0) && pwd)/dein.toml" ~/.vim/rc
ln -snf "$(cd $(dirname $0) && pwd)/dein_lazy.toml" ~/.vim/rc

ln -snf "$(cd $(dirname $0) && pwd)/.zshrc" ~/
ln -snf "$(cd $(dirname $0) && pwd)/.vimrc" ~/
ln -snf "$(cd $(dirname $0) && pwd)/.tmux.conf" ~/


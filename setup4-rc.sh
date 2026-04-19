#!/usr/local/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Setup Zsh
ln -snf "$DOTFILES_DIR/.zshrc" ~/
mkdir -p ~/.config/zsh 
ln -snf "$DOTFILES_DIR/abbreviations" ~/.config/zsh/abbreviations

# Setup Vim
mkdir -p ~/.vim/rc
ln -snf "$DOTFILES_DIR/dein.toml" ~/.vim/rc
ln -snf "$DOTFILES_DIR/.vimrc" ~/

# Setup Other
ln -snf "$DOTFILES_DIR/starship.toml" ~/.config

if [ ! -L ~/.gitconfig ]; then
  echo ""
  echo "========================================================="
  echo " Git settings are now managed via .gitconfig."
  echo " Please set your user.name and user.email manually:"
  echo '   git config --global user.name "Your Name"'
  echo '   git config --global user.email "your.email@example.com"'
  echo "========================================================="
  echo ""
fi
ln -snf "$DOTFILES_DIR/.gitconfig" ~/

# Setup Claude Code
mkdir -p ~/.claude
ln -snf "$DOTFILES_DIR/claude/claude-settings.json" ~/.claude/settings.json
ln -snf "$DOTFILES_DIR/claude/statusline-command.sh" ~/.claude/statusline-command.sh

# Setup Gemini CLI
mkdir -p ~/.gemini
ln -snf "$DOTFILES_DIR/gemini/settings.json" ~/.gemini/settings.json

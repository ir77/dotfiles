#!/usr/local/bin/zsh

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Setup Zsh
ln -snf "$DOTFILES_DIR/.zshrc" ~/
mkdir -p ~/.config/zsh 
ln -snf "$DOTFILES_DIR/abbreviations" ~/.config/zsh/abbreviations
ln -snf "$DOTFILES_DIR/starship.toml" ~/.config

# Setup Vim
mkdir -p ~/.vim/rc
ln -snf "$DOTFILES_DIR/dein.toml" ~/.vim/rc
ln -snf "$DOTFILES_DIR/.vimrc" ~/

# Setup Git
ln -snf "$DOTFILES_DIR/.gitconfig" ~/

if ! git config --global user.name > /dev/null 2>&1 || ! git config --global user.email > /dev/null 2>&1; then
  echo ""
  echo "========================================================="
  echo " Git settings are now managed via .gitconfig."
  echo " Please set your user.name and user.email manually in ~/.gitconfig.local:"
  echo '   git config -f ~/.gitconfig.local user.name "Your Name"'
  echo '   git config -f ~/.gitconfig.local user.email "your.email@example.com"'
  echo "========================================================="
  echo ""
fi

# Setup AI
mkdir -p ~/.claude
ln -snf "$DOTFILES_DIR/claude/claude-settings.json" ~/.claude/settings.json
ln -snf "$DOTFILES_DIR/claude/statusline-command.sh" ~/.claude/statusline-command.sh
ln -snf "$DOTFILES_DIR/.claude/skills" ~/.claude/skills

mkdir -p ~/.gemini
ln -snf "$DOTFILES_DIR/gemini/settings.json" ~/.gemini/settings.json

mkdir -p ~/.codex
ln -snf "$DOTFILES_DIR/codex/config.toml" ~/.codex/config.toml

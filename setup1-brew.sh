#!/bin/bash

readonly RED='\033[31m'
readonly GREEN='\033[32m'
readonly YELLOW='\033[33m'
readonly NC='\033[0m' # No Color

print_message() {
  local color="$1"
  local message="$2"
  printf "${color}%s${NC}\n" "$message"
}

if ! xcode-select -p &>/dev/null; then
  print_message "$YELLOW" "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
else
  print_message "$GREEN" "Xcode Command Line Tools are already installed."
fi

if ! command -v brew &>/dev/null; then
  print_message "$YELLOW" "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  print_message "$GREEN" "Homebrew is already installed. Updating..."
fi

brew update
brew upgrade
brew doctor
brew bundle

print_message "$GREEN" "Setup completed!"

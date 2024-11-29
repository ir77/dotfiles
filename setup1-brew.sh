#!/bin/bash
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew update
brew doctor

install_if_not_installed() {
    local package_name=$1
    if ! brew list --formula | grep -q "^${package_name}\$"; then
        echo "Installing ${package_name}..."
        brew install "${package_name}"
    else
        echo "${package_name} is already installed."
    fi
}

install_cask_if_not_installed() {
    local cask_name=$1
    if ! brew list --cask | grep -q "^${cask_name}\$"; then
        echo "Installing ${cask_name}..."
        brew install --cask "${cask_name}"
    else
        echo "${cask_name} is already installed."
    fi
}

cli_tools=(
    starship
    zsh-completions
    zsh-syntax-highlighting
    olets/tap/zsh-abbr
    ack
    fzf
    fd
    bat
    thefuck
    trash
    jq
    tig
    vim
    lua
    nodebrew
)

for tool in "${cli_tools[@]}"; do
    install_if_not_installed "${tool}"
done

cask_apps=(
    google-japanese-ime
    karabiner-elements
    rectangle
    iterm2
    google-chrome
    xcodes
    visual-studio-code
    intellij-idea
    android-studio
)

for app in "${cask_apps[@]}"; do
    install_cask_if_not_installed "${app}"
done

install_cask_if_not_installed "font-roboto-mono-for-powerline"

if ! command -v nodebrew &>/dev/null; then
    echo "Nodebrew is not installed properly. Please check the installation."
else
    mkdir -p ~/.nodebrew/src
    nodebrew install-binary stable
    nodebrew ls | xargs nodebrew use
fi

echo "Setup completed!"


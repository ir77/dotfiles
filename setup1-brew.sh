#!/bin/bash
xcode-select --install

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

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
    local app_name=$2

    # /Applications フォルダにアプリケーションが存在するか確認
    if [ ! -d "/Applications/${app_name}.app" ]; then
        echo "Installing ${cask_name}..."
        brew install --cask "${cask_name}"
    else
        echo "${app_name} is already installed in /Applications."
    fi
}

install_if_not_installed "starship"
install_if_not_installed "zsh-completions"
install_if_not_installed "zsh-syntax-highlighting"
install_if_not_installed "olets/tap/zsh-abbr"
install_if_not_installed "ack"
install_if_not_installed "fzf"
install_if_not_installed "fd"
install_if_not_installed "bat"
install_if_not_installed "thefuck"
install_if_not_installed "trash"
install_if_not_installed "jq"
install_if_not_installed "tig"
install_if_not_installed "vim"
install_if_not_installed "lua"
install_if_not_installed "nodebrew"

install_cask_if_not_installed "google-japanese-ime" "Google Japanese Input"
install_cask_if_not_installed "karabiner-elements" "Karabiner-Elements"
install_cask_if_not_installed "rectangle" "Rectangle"
install_cask_if_not_installed "iterm2" "iTerm"
install_cask_if_not_installed "google-chrome" "Google Chrome"
install_cask_if_not_installed "xcodes" "Xcodes"
install_cask_if_not_installed "visual-studio-code" "Visual Studio Code"
install_cask_if_not_installed "intellij-idea" "IntelliJ IDEA"
install_cask_if_not_installed "android-studio" "Android Studio"
install_cask_if_not_installed "font-roboto-mono-for-powerline"

if ! command -v nodebrew &>/dev/null; then
    echo "Nodebrew is not installed properly. Please check the installation."
else
    mkdir -p ~/.nodebrew/src
    nodebrew install-binary stable
    nodebrew ls | xargs nodebrew use
fi

echo "Setup completed!"


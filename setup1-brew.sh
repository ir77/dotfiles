#!/bin/bash
print_message() {
    local color=$1
    local message=$2

    case $color in
        "red")    echo "\033[31m${message}\033[0m" ;;  # 赤
        "green")  echo "\033[32m${message}\033[0m" ;;  # 緑
        "yellow") echo "\033[33m${message}\033[0m" ;;  # 黄色
        *)        echo "${message}" ;;                   # デフォルト
    esac
    echo ""  # 改行を追加
}

install_cask_if_not_installed() {
    local cask_name=$1
    local app_name=$2
    local font_dir="$HOME/Library/Fonts"

    if [ -d "/Applications/${app_name}.app" ]; then
        print_message "green" "${app_name} is already installed in /Applications."
    elif brew list --cask | grep -q "^${cask_name}\$"; then
        print_message "green" "${cask_name} is already installed."
    elif ls "${font_dir}" | grep -iq "${app_name}"; then
        print_message "green" "Font ${cask_name} is already installed."
    else
        print_message "yellow" "Installing ${cask_name}..."
        brew install --cask "${cask_name}" || print_message "red" "Failed to install ${cask_name}."
    fi
}


xcode-select --install

if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    print_message "green" "Homebrew is already installed."
fi

brew update
brew doctor
brew bundle

# TODO: move to brewfile
install_cask_if_not_installed "karabiner-elements" "Karabiner-Elements"
install_cask_if_not_installed "rectangle" "Rectangle"
install_cask_if_not_installed "iterm2" "iTerm"
install_cask_if_not_installed "google-chrome" "Google Chrome"
install_cask_if_not_installed "xcodes" "Xcodes"
install_cask_if_not_installed "visual-studio-code" "Visual Studio Code"
install_cask_if_not_installed "intellij-idea" "IntelliJ IDEA"
install_cask_if_not_installed "android-studio" "Android Studio"

if ! nodebrew ls | grep -q "v"; then
    print_message "yellow" "Node.js is not installed via Nodebrew. Installing the latest stable version..."
    mkdir -p ~/.nodebrew/src
    nodebrew install-binary stable
    nodebrew ls | xargs nodebrew use
else
    print_message "green" "Node.js is already installed via Nodebrew."
fi

print_message "green" "Setup completed!"

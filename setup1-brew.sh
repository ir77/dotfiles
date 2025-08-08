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

if ! nodebrew ls | grep -q "v"; then
    print_message "yellow" "Node.js is not installed via Nodebrew. Installing the latest stable version..."
    mkdir -p ~/.nodebrew/src
    nodebrew install-binary stable
    nodebrew ls | xargs nodebrew use
else
    print_message "green" "Node.js is already installed via Nodebrew."
fi

print_message "green" "Setup completed!"

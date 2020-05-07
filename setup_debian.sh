sudo apt-get install gcc
sudo apt-get install peco
sudo apt-get install thefuck
sudo apt-get install tig
sudo apt-get install jq

sudo apt-get install dbus
sudo timedatectl set-timezone Asia/Tokyo // timezoneの変更

sudo apt-get install zsh
curl -fsSL https://starship.rs/install.sh | bash // starship
echo 'eval "$(starship init zsh)"' > ~/.zshrc
sudo chsh $USER -s $(which zsh)

// setup mosh
sudo apt-get install mosh
sudo apt-get install ufw
sudo ufw allow 60000:61000/udp

// install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

git config --global user.email fly.oh.shogun.iridium.77@gmail.com
git config --global user.name ir77


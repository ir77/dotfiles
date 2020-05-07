sudo apt-get install dbus
sudo timedatectl set-timezone Asia/Tokyo // timezoneの変更

sudo apt-get install zsh
curl -fsSL https://starship.rs/install.sh | bash // starship
echo 'eval "$(starship init zsh)"' > ~/.zshrc
sudo chsh $USER -s $(which zsh)

git config --global user.email fly.oh.shogun.iridium.77@gmail.com
git config --global user.name ir77


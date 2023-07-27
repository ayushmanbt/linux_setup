#!/bin/bash -e

wait_for_keypress(){
	echo "Press any key to continue..."
	while [ true ] ; do
		read -t 3 -n 1
		if [ $? = 0 ] ; then
			exit ;
		fi
	done
}
sudo apt update -y
sudo apt upgrade -y
sudo apt install git ssh zsh vim tmux python3-pip python-is-python3 -y

# update zshrc
cp .zshrc ~/.zshrc

# vim setup
mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged
cp .vimrc ~/.vimrc

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# installing alacritty
git clone https://github.com/alacritty/alacritty.git
pushd alacritty
	rustup override set stable 
	rustup update stable
	sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y
	cargo build --release
	sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	sudo desktop-file-install extra/linux/Alacritty.desktop
	sudo update-desktop-database	
popd

sudo systemctl enable ssh
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "ZSH installed configure it later!"

# ZSH Config
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


chsh -s $(which zsh)
sudo chsh -s $(which zsh)

# git setup
git config --global user.name "ayushmanbt"
git config --global user.email "ayushmanbilasthakur@gmail.com"
git config --global init.defaultBranch main
ssh-keygen -t ed25519 -C "ayushmanbilasthakur@gmail.com"
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
echo "Key copied to clipboard, Now go to https://github.com and add this key to your account to continue"
wait_for_keypress();


# install vscode
sudo apt-get install wget gpg -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code

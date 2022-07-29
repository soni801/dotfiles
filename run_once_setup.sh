#!/usr/bin/env bash

# Update system
sudo pacman -Syu --noconfirm

# Install needed packages
sudo pacman -S zsh git base-devel --needed --noconfirm
sudo pacman -S bat chezmoi neovim python-pywal lsd alacritty yt-dlp --needed --noconfirm

# Change the default shell to zsh for the current user
sudo chsh -s $(which zsh) $(whoami)

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended

# Install oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/Cloudstek/zsh-plugin-appup ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/appup

# Download powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install AUR packages
yay -S asdf-vm nerd-fonts-jetbrains-mono ptsh --answerdiff=None --noconfirm

# Download vim-plug
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install neovim plugins
nvim +PlugInstall +q +q

# Change shell to zsh without launching the p10k wizard, then install nodejs through asdf
zsh -c "POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true; \
	. /opt/asdf-vm/asdf.sh;
	asdf plugin add nodejs; \
	asdf install nodejs latest; \
	asdf global nodejs latest; \
	cd; \
	echo Done! Make sure to apply JetBrainsMono Nerd Font before configuring p10k."

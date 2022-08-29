#!/usr/bin/env bash

# Test for distro
is_arch=$(test -f /etc/arch-release && echo true || echo false)
is_debian=$(test -f /etc/debian_version && echo true || echo false)

# Go to home directory
cd ~

# Install base packages
if [[ "${is_arch}" == "true" ]]; then
  # Update system
  sudo pacman -Syu --noconfirm

  # Install packages
  sudo pacman -S zsh git base-devel --needed --noconfrm
  sudo pacman -S bat chezmoi neovim lsd alacritty yt-dlp --needed --noconfirm

  # Install yay
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
elif [[ "${is_debian}" == "true" ]]; then
  # Update system
  sudo apt update && sudo apt full-upgrade -y

  # Install packages
  sudo apt install zsh git wget -y
  sudo apt install cargo yt-dlp -y

  # Install bat
  sudo apt install bat -y
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat

  # Install chezmoi
  sh -c "$(curl -fsLS https://chezmoi.io/get)"

  # Install neovim
  wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
  sudo dpkg -i nvim_linux64.deb
  rm nvim_linux64.deb

  # Install lsd
  wget https://github.com/Peltoche/lsd/releases/download/0.22.0/lsd_0.22.0_amd64.deb
  sudo dpkg -i lsd_0.22.0_amd64.deb
  rm lsd_0.22.0_amd64.deb

  # Install alacritty
  sudo apt install cmake g++ pkg-config libfontconfig-dev libxcb-xfixes0-dev -y
  cargo install alacritty
  export PATH="$HOME/.cargo/bin:$PATH"
else
  echo "Unsupported distribution"
  exit 1
fi

# Change the default shell to zsh for the current user
sudo chsh -s $(which zsh) $(whoami)

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended

# Install oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/Cloudstek/zsh-plugin-appup ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/appup

# Download powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install other packages
if [[ "${is_arch}" == "true" ]]; then
  # Install AUR packages
  yay -S asdf-vm nerd-fonts-jetbrains-mono ptsh --answerdiff=None --noconfirm
elif [[ "${is_debian}" == "true" ]]; then
  # Install asdf
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

  # Install JetBrainsMono Nerd Font
  wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
  sudo mv 'JetBrains Mono Regular Nerd Font Complete Mono.ttf' /usr/local/share/fonts/
  fc-cache

  # Install ptsh
  sudo apt install gcc make -y
  git clone https://github.com/jszczerbinsky/ptSh
  cd ptSh
  make
  sudo make install
else
  log_warn "Unsupported distribution"
  exit 1
fi

# Download vim-plug
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install neovim plugins
nvim +PlugInstall +q +q

# Change shell to zsh, then install nodejs through asdf
zsh -c ". ~/.zshrc; \
	asdf plugin add nodejs; \
	asdf install nodejs latest; \
	asdf global nodejs latest; \
	cd; \
	echo Done!"

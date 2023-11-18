#!/usr/bin/env bash

# Test for distro
is_arch=$(test -f /etc/arch-release && echo true || echo false)
is_debian=$(test -f /etc/debian_version && echo true || echo false)

if [[ "${is_arch}" == "true" ]]; then
  echo "Detected distribution: Arch (or derivative)"
elif [[ "${is_debian}" == "true" ]]; then
  echo "Detected distribution: Debian (or derivative)"
else
  echo "Unsupported distribution"
  exit 1
fi

# Go to home directory
cd ~

# Install gum
if [[ "${is_arch}" == "true" ]]; then
  # Update source lists
  yes | sudo pacman -Sy

  # Install gum
  yes | sudo pacman -S gum
elif [[ "${is_debian}" == "true" ]]; then
  # Add gum to source lists
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

  # Update source lists
  sudo apt update

  # Install gum
  sudo apt install gum -y
fi

# Let the user select which components to install
echo "Choose which components to install:"
components=$(gum choose --no-limit "Required dependencies" "Configured packages" "Shell extensions" "GUI configuration")

# Install base packages
if [[ "${is_arch}" == "true" ]]; then
  # Install required dependencies
  if [[ "${components}" =~ "Required dependencies" ]]; then
    # Update system
    yes | sudo pacman -Syu

    # Install development tools
    yes | sudo pacman -S git base-devel --needed

    # Install yay
    git clone --depth=1 https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
  fi

  # Install configured packages
  if [[ "${components}" =~ "Configured packages" ]]; then
    yes | yay -S zsh bat chezmoi neovim lsd yt-dlp asdf-vm ptsh tealdeer --needed --answerdiff=None
  fi
elif [[ "${is_debian}" == "true" ]]; then
  # Install required dependencies
  if [[ "${components}" =~ "Required dependencies" ]]; then
    # Update system
    sudo apt full-upgrade -y

    # Install packages
    sudo apt install git wget -y
  fi

  # Install configured packages
  if [[ "${components}" =~ "Configured packages" ]]; then
    # Install apt packages
    sudo apt install zsh cargo yt-dlp -y

    # Install bat
    sudo apt install bat -y
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat

    # Install chezmoi
    sh -c "$(curl -fsLS https://chezmoi.io/get)"

    # Install neovim
    wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
    sudo dpkg -i nvim-linux64.deb
    rm nvim-linux64.deb

    # Install lsd
    wget https://github.com/Peltoche/lsd/releases/download/0.22.0/lsd_0.22.0_amd64.deb
    sudo dpkg -i lsd_0.22.0_amd64.deb
    rm lsd_0.22.0_amd64.deb

    # Install asdf
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

    # Install ptsh
    sudo apt install gcc make -y
    git clone --depth=1 https://github.com/jszczerbinsky/ptSh
    cd ptSh
    make
    sudo make install
  fi
fi

# Return to home directory
cd ~

# Install shell extensions
if [[ "${components}" =~ "Shell extensions" ]]; then
  # Change the default shell to zsh for the current user
  sudo chsh -s $(which zsh) $(whoami)

  # Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended

  # Install oh-my-zsh plugins
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
  git clone --depth=1 https://github.com/Cloudstek/zsh-plugin-appup ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/appup

  # Download powerlevel10k
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install GUI configuration
if [[ "${components}" =~ "GUI configuration" ]]; then
  if [[ "${is_arch}" == "true" ]]; then
    # Install packages
    yes | sudo pacman -S ttf-jetbrains-mono-nerd alacritty rofi polybar feh picom
  
    # Install xborders
    yes | yay -S python-cairo python-requests libwnck3 --needed --answerdiff=None
    mkdir -p GitHub/xborder
    git clone --depth=1 https://github.com/deter0/xborder GitHub/xborder
    chmod +x GitHub/xborder/xborders
  elif [[ "${is_debian}" == "true" ]]; then
    # Install JetBrainsMono Nerd Font
    wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
    sudo mv 'JetBrains Mono Regular Nerd Font Complete Mono.ttf' /usr/local/share/fonts/
    fc-cache

    # Install alacritty
    sudo apt install cmake g++ pkg-config libfontconfig-dev libxcb-xfixes0-dev -y
    cargo install alacritty
    export PATH="$HOME/.cargo/bin:$PATH"
  fi

  # Download wallpaper
  sudo mkdir /usr/share/backgrounds
  wget https://github.com/linuxdotexe/nordic-wallpapers/blob/master/wallpapers/misty_mountains.jpg?raw=true
  sudo mv misty_mountains.jpg /usr/share/backgrounds/
fi

if [[ "${components}" =~ "Configured packages" ]]; then
  # Download vim-plug
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  # Install neovim plugins
  nvim +PlugInstall +q +q

  # Change shell to zsh, then install nodejs through asdf
  zsh -c ". ~/.zshrc; \
    asdf plugin add nodejs; \
    asdf install nodejs latest; \
    asdf global nodejs latest; \
    cd; \
    echo Done!"
fi

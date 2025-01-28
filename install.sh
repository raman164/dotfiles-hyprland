#!/bin/bash

# List of packages to install via pacman
packages=(
    gnu-free-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    nerd-fonts
    ttf-iosevka-nerd
    make
    neovim
    foot
    dunst
    wofi
    zsh
    fish
    starship
    waybar
    swww
    sddm
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-kde
    xdg-desktop-portal-gtk
    playerctl
    grim
    yazi
    rust
    nodejs
    npm
    neofetch
    zathura
    xdg-utils
    imv
    mpv
    slurp
    hyprland
    hyprlock
    hyprpaper
    hypridle
    fzf
    tmux
    networkmanager
    qt5-imageformats
    qt5-wayland
    ffmpegthumbs
    taglib
    kompare
    ark
    bluez
    bluez-utils
    bluetui
    blueman
    jq
    tree
    brightnessctl
    pavucontrol
    nwg-look
    adwaita-icon-theme
    dolphin
    dolphin-plugins
    kdegraphics-thumbnailers
    libheif
    lzip
    bat
    eza
    exa
    firefox
    pamixer
    zsh-autosuggestions
    thunar
    wpctl
    xdg-user-dirs
    tumbler
    python3
    polkit-kde-agent
    fuzzel
)

# Install packages using pacman
echo "Installing packages via pacman..."
for pkg in "${packages[@]}"; do
    echo "Attempting to install: $pkg"
    sudo pacman -S --needed --noconfirm "$pkg"
    if [ $? -ne 0 ]; then
        echo "Package '$pkg' not found or failed to install. Skipping..."
    fi
done

# Install yay (AUR helper) if not already installed
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "yay is already installed. Skipping..."
fi

# List of AUR packages to install via yay
yay_packages=(
    waybar-module-pacman-updates-git
    ueberzugpp
    xarchiver
    gvfs
    checkupdates-with-aur
    waypaper
    zsh-256color
)

# Install AUR packages using yay
echo "Installing AUR packages via yay..."
for pkg in "${yay_packages[@]}"; do
    echo "Attempting to install: $pkg"
    yay -S --needed --noconfirm "$pkg"
    if [ $? -ne 0 ]; then
        echo "Package '$pkg' not found or failed to install. Skipping..."
    fi
done

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed. Skipping..."
fi

# Install zsh-syntax-highlighting
echo "Installing zsh-syntax-highlighting..."
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting is already installed. Skipping..."
fi

# Install zsh-autosuggestions
echo "Installing zsh-autosuggestions..."
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions is already installed. Skipping..."
fi

# Install zsh-vi-mode
echo "Installing zsh-vi-mode..."
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-vi-mode ]; then
    git clone https://github.com/jeffreytse/zsh-vi-mode.git ~/.oh-my-zsh/custom/plugins/zsh-vi-mode
else
    echo "zsh-vi-mode is already installed. Skipping..."
fi

# Install zsh-256color
echo "Installing zsh-256color..."
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/chrissicool/zsh-256color.git ~/.oh-my-zsh/custom/plugins/zsh-256color
else
    echo "zsh-256color is already installed. Skipping..."
fi

# Set up dotfiles
echo "Setting up dotfiles..."
if [ ! -d ~/dotfiles-hyprland ]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/your-username/dotfiles-hyprland.git ~/dotfiles-hyprland
fi

# Copy dotfiles to ~/.config and overwrite existing files
echo "Copying dotfiles to ~/.config..."
sudo rm -rf ~/.config
mkdir -p ~/.config
cp -rf ~/dotfiles-hyprland/* ~/.config
mv -f ~/.config/.zshrc ~/.config/weather.sh ~/.

# Enable sddm service
echo "Enabling sddm service..."
sudo systemctl enable sddm

# Final message
echo "Package & rice installation completed!"
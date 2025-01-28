

sudo pacman -S base-devel python3 python-pip make \
    python-virtualenv neovim foot \
    dunst wofi zsh fish starship \
    xdg-desktop-portal-hyprland playerctl grim yazi \
    luarocks rust nodejs npm \
    neofetch zathura xdg-utils bluetui imv mpv \
    hyprland hyprlock hyprpaper hypridle noto-fonts-emoji noto-fonts-extra \
    fzf tmux networkmanager \
    bluez bluez-utils bluetui blueman \
    tree ttf-iosevka-nerd brightnessctl \
    go python-pipx \
    adwaita-icon-theme \
	lzip bat eza firefox sddm pamixer zsh-autosuggestions waybar thunar wpctl \
    xdg-user-dirs tumbler --needed \
        

# Clone yay from AUR and install it
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# Install additional packages via yay
yay -S waybar-module-pacman-updates-git ueberzugpp xarchiver gvfs checkupdates-with-aur \
       waypaper

# Clone dotfiles repository and set up .zshrc
rm -rf ~/.config
cd
cd dotfiles-hyprland
cp -rf * ~/.config
cd ~/.config
mv -f .zshrc weather.sh ~/.
cd


# Final message
echo "Package & rice installation completed!"


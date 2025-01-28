

sudo pacman -S gnu-free-fonts noto-fonts noto-fonts-cjk nerd-fonts make \
    neovim foot dunst wofi zsh fish starship waybar swww sddm\
    xdg-desktop-portal-hyprland xdg-desktop-portal-kde playerctl grim yazi \
    rust nodejs npm neofetch zathura xdg-utils imv mpv grim slurp\
    hyprland hyprlock hyprpaper hypridle noto-fonts-emoji noto-fonts-extra \
    fzf tmux networkmanager qt5-imageformats ffmpegthumbs taglib kompare ark\
    bluez bluez-utils bluetui blueman xdg-desktop-portal-gtk qt5-wayland jq\
    tree ttf-iosevka-nerd brightnessctl pavucontrol nwg-look\
    adwaita-icon-theme dolphin dolphin-plugins kdegraphics-thumbnailers libheif\
	lzip bat eza exa firefox sddm pamixer zsh-autosuggestions waybar thunar wpctl \
    xdg-user-dirs tumbler python3 polkit-kde-agent fuzzel--needed \
        

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
cd .config
mv -f .zshrc weather.sh ~/.
cd

sudo systemctl enable sddm

# Final message
echo "Package & rice installation completed!"


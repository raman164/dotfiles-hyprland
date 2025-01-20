# Install packages via Pacman
sudo pacman -S sway wlroots git base-devel python python-pip make \
    cargo python-virtualenv pipewire wf-recorder swaybg neovim vim sudo foot \
    dunst libnotify wofi zsh fish starship obs-studio xdg-desktop-portal-wlr \
    xdg-desktop-portal wlsunset playerctl grim slurp wl-clipboard yazi \
    trash-cli metasploit nmap gnu-netcat luarocks rust nodejs npm pnpm yarn \
    python-i3ipc neofetch zathura xdg-utils bluetui imv mpv zoxide pyenv hurl \
    nemo btop hyprland hyprlock hyprpaper hypridle noto-fonts-emoji noto-fonts-extra os-prober grub \
    wlsunset wev ripgrep fzf cowsay tmux networkmanager aws-cli azure-cli \
    proxychains-ng v2ray github-cli bluez bluez-utils bluetui blueman openvpn cloudflared \
    docker docker-compose wireplumber less tree ttf-iosevka-nerd brightnessctl fd \
    tldr locate go python-pipx glow ltrace cutter radare2 rz-ghidra r2ghidra \
    libvirt qemu-full qemu-img virt-install virt-manager virt-viewer man \
		edk2-ovmf dnsmasq swtpm guestfs-tools libosinfo tuned go adwaita-icon-theme \
		lzip

# Clone paru-bin from AUR and install it
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..
rm -rf paru-bin

# Install additional packages via paru
paru -S yambar caido-cli burpsuite zen-browser-bin xcp virtualfish waydroid \
	python-pyclip subfinder httpx

# Clone dotfiles repository and set up .zshrc
rm -rf ~/.config
git clone -b hyprland https://github.com/raman164/dotfiles-hyprland.git ~/.config

# Add current user to necessary groups
sudo usermod -aG kvm,video,libvirt,docker,network,input $(whoami)

# Enable and start user services
systemctl --user enable pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr

# Enable system-wide services
sudo systemctl enable bluetooth.service docker.service NetworkManager.service
sudo systemctl start bluetooth.service docker.service NetworkManager.service

# Enable virtualization services
for drv in qemu interface network nodedev nwfilter secret storage; do
    sudo systemctl enable virt${drv}d.service;
    sudo systemctl enable virt${drv}d{,-ro,-admin}.socket;
done
sudo systemctl enable libvirtd.service

# Set shell to Fish
chsh -s $(which fish)

# Final message
echo "Package & rice installation completed!"


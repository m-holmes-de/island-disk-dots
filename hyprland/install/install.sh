#!/bin/bash
# Installation script for Hyprland Island Disk setup
# Installs all required packages for the Hyprland configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
    print_error "This script is designed for Arch Linux"
    exit 1
fi

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    print_warning "yay not found. Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    print_success "yay installed"
fi

print_info "Starting Hyprland Island Disk installation..."
echo ""

# Core Hyprland packages
CORE_PACKAGES=(
    "hyprland"              # Wayland compositor
    "hyprlock"              # Screen locker
    "hypridle"              # Idle daemon
    "hyprpicker"            # Color picker
    "xdg-desktop-portal-hyprland"  # Desktop portal
    "uwsm"                  # Universal Wayland Session Manager
)

# UI and utilities
UI_PACKAGES=(
    "waybar"                # Status bar
    "rofi-wayland"          # Application launcher
    "swww"                  # Wallpaper daemon
    "dunst"                 # Notification daemon
    "brightnessctl"         # Brightness control
    "playerctl"             # Media player control
)

# Terminal and shell
TERMINAL_PACKAGES=(
    "ghostty"               # Terminal emulator (AUR)
    "zsh"                   # Shell
)

# Applications
APP_PACKAGES=(
    "chromium"              # Web browser
    "nautilus"              # File manager
    "impala"                # WiFi manager (AUR)
)

# System utilities
SYSTEM_PACKAGES=(
    "polkit-gnome"          # Authentication agent
    "gnome-keyring"         # Keyring
    "pipewire"              # Audio server
    "pipewire-pulse"        # PulseAudio compatibility
    "wireplumber"           # Session manager
    "jq"                    # JSON processor
    "ffmpeg"                # Multimedia framework (for thumbnails)
)

# Fonts
FONT_PACKAGES=(
    "ttf-jetbrains-mono-nerd"  # JetBrains Mono Nerd Font
    "noto-fonts"            # Noto fonts
    "noto-fonts-emoji"      # Emoji support
)

# Function to install packages
install_packages() {
    local package_list=("$@")
    local pacman_packages=()
    local aur_packages=()

    print_info "Checking packages: ${package_list[*]}"

    # Separate official and AUR packages
    for pkg in "${package_list[@]}"; do
        if pacman -Si "$pkg" &>/dev/null; then
            pacman_packages+=("$pkg")
        else
            aur_packages+=("$pkg")
        fi
    done

    # Install official packages
    if [ ${#pacman_packages[@]} -gt 0 ]; then
        print_info "Installing official packages: ${pacman_packages[*]}"
        sudo pacman -S --needed --noconfirm "${pacman_packages[@]}"
    fi

    # Install AUR packages
    if [ ${#aur_packages[@]} -gt 0 ]; then
        print_info "Installing AUR packages: ${aur_packages[*]}"
        yay -S --needed --noconfirm "${aur_packages[@]}"
    fi
}

# Install all package groups
print_info "Installing core Hyprland packages..."
install_packages "${CORE_PACKAGES[@]}"
print_success "Core packages installed"
echo ""

print_info "Installing UI and utilities..."
install_packages "${UI_PACKAGES[@]}"
print_success "UI packages installed"
echo ""

print_info "Installing terminal and shell..."
install_packages "${TERMINAL_PACKAGES[@]}"
print_success "Terminal packages installed"
echo ""

print_info "Installing applications..."
install_packages "${APP_PACKAGES[@]}"
print_success "Applications installed"
echo ""

print_info "Installing system utilities..."
install_packages "${SYSTEM_PACKAGES[@]}"
print_success "System utilities installed"
echo ""

print_info "Installing fonts..."
install_packages "${FONT_PACKAGES[@]}"
print_success "Fonts installed"
echo ""

# Enable required services
print_info "Enabling pipewire services..."
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service
print_success "Services enabled"
echo ""

# Create necessary directories
print_info "Creating necessary directories..."
mkdir -p ~/wallpaper
mkdir -p ~/.cache/wallpaper-thumbs
print_success "Directories created"
echo ""

print_success "============================================"
print_success "Installation complete!"
print_success "============================================"
echo ""
print_info "Next steps:"
echo "  1. Use stow to symlink your dotfiles"
echo "  2. Log out of your current session"
echo "  3. Select 'Hyprland' from your display manager"
echo "  4. Log in and enjoy your new setup!"
echo ""
print_info "Key bindings:"
echo "  SUPER + Space       - Application launcher"
echo "  SUPER + Return      - Terminal"
echo "  SUPER + W           - Wallpaper selector"
echo "  SUPER + N           - Toggle waybar"
echo "  SUPER + Escape      - Power menu"
echo "  SUPER + Q           - Close window"
echo ""
print_warning "Don't forget to add some wallpapers to ~/wallpaper/"

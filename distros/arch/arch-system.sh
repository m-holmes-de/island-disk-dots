#!/usr/bin/env bash

# Arch Linux Post-Installation Script
# Improved version with error handling, logging, and best practices

set -euo pipefail  # Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # Secure Internal Field Separator

# Color definitions
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NONE='\033[0m'

# Script configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_FILE="/tmp/arch-install-$(date +%Y%m%d-%H%M%S).log"
readonly BACKUP_DIR="/etc/arch-install-backups/$(date +%Y%m%d-%H%M%S)"

# Logging functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $*${NONE}" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*${NONE}" | tee -a "$LOG_FILE" >&2
}

log_warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $*${NONE}" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*${NONE}" | tee -a "$LOG_FILE"
}

# Error handling
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "Script failed with exit code $exit_code"
        log_error "Check log file: $LOG_FILE"
    fi
    exit $exit_code
}

trap cleanup EXIT

# Utility functions
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

confirm_action() {
    local message="$1"
    local default="${2:-n}"
    local response

    echo -e "${YELLOW}$message (y/N): ${NONE}"
    read -r response
    response=${response:-$default}

    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        log_error "Required command '$cmd' not found"
        return 1
    fi
}

# Package management functions
install_pacman_packages() {
    local packages=("$@")
    log "Installing pacman packages: ${packages[*]}"

    if ! sudo pacman -S --needed --noconfirm "${packages[@]}"; then
        log_error "Failed to install some pacman packages"
        return 1
    fi
}

install_yay_packages() {
    local packages=("$@")
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi

    log "Installing AUR packages: ${packages[*]}"

    if ! yay -S --needed --noconfirm --removemake --answerdiff None "${packages[@]}"; then
        log_error "Failed to install some AUR packages"
        return 1
    fi
}

install_flatpaks() {
    local packages=("$@")
    if [[ ${#packages[@]} -eq 0 ]]; then
        return 0
    fi

    log "Installing Flatpak packages: ${packages[*]}"

    # Ensure flathub repo is added
    if ! flatpak remote-list | grep -q flathub; then
        log "Adding Flathub repository"
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    if ! flatpak install -y flathub "${packages[@]}"; then
        log_error "Failed to install some Flatpak packages"
        return 1
    fi
}

# System file management
create_backup_dir() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log "Creating backup directory: $BACKUP_DIR"
        sudo mkdir -p "$BACKUP_DIR"
    fi
}

copy_sys_files() {
    local source="$1"
    local target="$2"
    local backup_name="${target//\//_}"  # Replace / with _ for backup filename

    # Validate source file exists
    if [[ ! -f "$source" ]]; then
        log_error "Source file not found: $source"
        return 1
    fi

    # Create target directory if it doesn't exist
    local target_dir
    target_dir="$(dirname "$target")"
    if [[ ! -d "$target_dir" ]]; then
        log "Creating directory: $target_dir"
        sudo mkdir -p "$target_dir"
    fi

    # Backup existing file
    if [[ -f "$target" ]]; then
        log "Backing up existing file: $target"
        sudo cp "$target" "$BACKUP_DIR/$backup_name.bak"
        log "Updating existing file: $target"
    else
        log "Creating new file: $target"
    fi

    # Copy the file
    if ! sudo cp "$source" "$target"; then
        log_error "Failed to copy $source to $target"
        return 1
    fi

    log "Successfully copied $source to $target"
}

# Service management
enable_and_start_service() {
    local service="$1"
    local user_service="${2:-false}"

    log "Enabling and starting service: $service"

    if [[ "$user_service" == "true" ]]; then
        if ! systemctl --user enable --now "$service"; then
            log_warn "Failed to enable user service: $service"
            return 1
        fi
    else
        if ! sudo systemctl enable --now "$service"; then
            log_warn "Failed to enable system service: $service"
            return 1
        fi
    fi

    # Verify service is active
    sleep 2
    if [[ "$user_service" == "true" ]]; then
        if systemctl --user is-active --quiet "$service"; then
            log "User service $service is active"
        else
            log_warn "User service $service failed to start properly"
        fi
    else
        if sudo systemctl is-active --quiet "$service"; then
            log "System service $service is active"
        else
            log_warn "System service $service failed to start properly"
        fi
    fi
}

# Main installation function
main() {
    log "Starting Arch Linux post-installation script"
    log "Log file: $LOG_FILE"

    # Pre-flight checks
    check_root
    check_command "sudo"

    # Create backup directory
    create_backup_dir

    # Display banner
    if command -v figlet &> /dev/null; then
        echo -e "${GREEN}"
        figlet "INSTALL ARCH BITCH"
        echo -e "${NONE}"
    else
        echo -e "${GREEN}=== ARCH LINUX POST-INSTALLATION ===${NONE}"
    fi

    sleep 2

    # Check if user wants to continue
    if ! confirm_action "Continue with installation?"; then
        log "Installation cancelled by user"
        exit 0
    fi

    # Install yay if not present
    if ! command -v yay &> /dev/null; then
        log "Installing yay AUR helper"
        if [[ -f "./arch-scripts/yay.sh" ]]; then
            source "./arch-scripts/yay.sh"
        else
            log_warn "yay.sh script not found, please install yay manually"
        fi
    fi

    # Package arrays
    local base_packages=(
        "jq"
        "socat"
        "intel-ucode"
        "vulkan-intel"
        "man-db"
        "unzip"
        "ufw"
        "zsh"
        "eza"
        "yazi"
        "zoxide"
        "lazygit"
        "stow"
        "tmux"
        "zellij"
        "starship"
        "sof-firmware"
        "wireplumber"
        "pipewire"
        "pipewire-alsa"
        "pipewire-audio"
        "pipewire-jack"
        "pipewire-pulse"
        "pavucontrol"
        "openssh"
        "nodejs"
        "npm"
        "neovim"
        "fzf"
        "ripgrep"
        "fastfetch"
        "bat"
        "base-devel"
        "figlet"
        "flatpak"
        "libnotify"
        "ttf-jetbrains-mono"
        # "ttf-dejavu"
        # "ttf-roboto"
        "ghostty"
        "terminus-font"
        # "tlp"
        # "noto-fonts"
        "nvidia"
        # "nvidia-open-dkms"
        "gnome-keyring"
        "libsecret"
        # "upower"
    )

    local yay_packages=(
        # "tlpui"
    )

    local hypr_packages=(
        "hyprland"
        "hyprlock"
        "hypridle"
        "hyprpaper"
        "xdg-desktop-portal"
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk" # for file chooser
        "cliphist" # clipboard manager
        "grim" # screenshots
        "slurp" # screenshots
        "gvfs"
	"mpv"
	"blueberry" # bluetooth tui
        "bluez" # bluetooth
        "polkit-gnome" # polkit
        # "font-manager"
        "playerctl" # volume etc
        "thunar" # file manager
        # "firefox" # browser
        "waybar" # bar
        "nwg-look" # set gtk themes
        "libadwaita" # needed for gtk
        "brightnessctl"
        "swaync" # notification center
        # "libgtop" # required for resource monitoring modules
	"btop"
	"swayosd"
	"uwsm" # https://wiki.hypr.land/Useful-Utilities/Systemd-start/
	"libnewt" # https://wiki.hypr.land/Useful-Utilities/Systemd-start/
	"impala" # TUI for managing wifi
	"iwd" # Required for impala
    )

    local yay_hypr_packages=(
        # "hyprshot"
        # "aylurs-gtk-shell"
        # "kanata" # keyboard modifier
    )

    local flatpak_packages=(
        "app.zen_browser.zen"
        "md.obsidian.Obsidian"
        "com.github.tchx84.Flatseal"
        "com.spotify.Client"
        "it.mijorus.gearlever"
    )

    # System file configurations
    local -A sys_files=(
        ["./sys-files/etc/issue"]="/etc/issue"
        ["./sys-files/etc/vconsole.conf"]="/etc/vconsole.conf"
        # ["./sys-files/etc/locale.gen"]="/etc/locale.gen"
        # ["./sys-files/etc/locale.conf"]="/etc/locale.conf"
        # ["./sys-files/etc/systemd/timesyncd.conf"]="/etc/systemd/timesyncd.conf"
        # ["./sys-files/etc/systemd/system/kanata.service"]="/etc/systemd/system/kanata.service"
        # ["./sys-files/etc/systemd/system/external_monitor.service"]="/etc/systemd/system/external_monitor.service"
        # ["./sys-files/etc/udev/rules.d/99-monitor-hotplug.rules"]="/etc/udev/rules.d/99-monitor-hotplug.rules"
        ["./sys-files/usr/share/applications/com.mitchellh.ghostty.desktop"]="/usr/share/applications/com.mitchellh.ghostty.desktop"
        # ["./sys-files/.local/share/applications/dev.zed.Zed.desktop"]="$HOME/.local/share/applications/dev.zed.Zed.desktop"
        ["./sys-files/etc/modprobe.d/nvidia.conf"]="/etc/modprobe.d/nvidia.conf"
        ["./sys-files/etc/modprobe.d/nvidia-disable.conf"]="/etc/modprobe.d/nvidia.conf"
        ["./sys-files/etc/modprobe.d/blacklist-nouveau.conf"]="/etc/modprobe.d/blacklist-nouveau.conf"
        # ["./sys-files/etc/mkinitcpio.conf"]="/etc/mkinitcpio.conf"
    )

    # Install packages
    log "=== Installing Base Packages ==="
    install_pacman_packages "${base_packages[@]}"

    if command -v yay &> /dev/null && [[ ${#yay_packages[@]} -gt 0 ]]; then
        log "=== Installing AUR Packages ==="
        install_yay_packages "${yay_packages[@]}"
    fi

    # Commented package arrays available for ad-hoc installation:
    install_pacman_packages "${hypr_packages[@]}"  # Uncomment for Hyprland
    install_yay_packages "${yay_hypr_packages[@]}"  # Uncomment for Hyprland AUR packages

    log "=== Installing Flatpak Packages ==="
    install_flatpaks "${flatpak_packages[@]}"

    # Copy system files
    log "=== Copying System Files ==="
    for source in "${!sys_files[@]}"; do
        target="${sys_files[$source]}"
        copy_sys_files "$source" "$target"
    done

    # Configure services
    log "=== Configuring Services ==="
    # enable_and_start_service "upower.service"
    # enable_and_start_service "tlp.service"
    enable_and_start_service "ufw.service"
    enable_and_start_service "gnome-keyring-daemon.service" "true" # true means a user service is envoked
    enable_and_start_service "swayosd-libinput-backend.service" 
    enable_and_start_service "systemd-resolved" # DNS for iwd
    enable_and_start_service "iwd" # needed for impala 


    # Configure firewall
    log "=== Configuring Firewall ==="
    sudo ufw --force default deny incoming
    sudo ufw --force default allow outgoing
    sudo ufw --force default deny routed
    sudo ufw enable

    # Rebuild initramfs
    log "=== Rebuilding Initramfs ==="
    if ! sudo mkinitcpio -P; then
        log_error "Failed to rebuild initramfs"
        exit 1
    fi

    log "=== Installation Complete ==="
    log "Backup directory: $BACKUP_DIR"
    log "Log file: $LOG_FILE"
    log "Please reboot your system to ensure all changes take effect"

    if confirm_action "Would you like to reboot now?"; then
        log "Rebooting system..."
        sudo systemctl reboot
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

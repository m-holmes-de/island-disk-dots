# 005-setup: Enable services, create directories, deploy configs

# Enable audio services
print_info "Enabling pipewire services..."
systemctl --user enable --now pipewire.service
systemctl --user enable --now pipewire-pulse.service
systemctl --user enable --now wireplumber.service

# Create required directories
print_info "Creating directories..."
mkdir -p ~/wallpaper
mkdir -p ~/.cache/wallpaper-thumbs

# Deploy configs via stow
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
print_info "Deploying hyprisland configs via stow..."
cd "$REPO_DIR"
stow -t "$HOME" hyprisland
cd "$SCRIPT_DIR"

# Post-install summary
echo ""
print_success "============================================"
print_success "Hyprisland installation complete!"
print_success "============================================"
echo ""
print_info "Next steps:"
echo "  1. Add wallpapers to ~/wallpaper/"
echo "  2. Log out and select 'Hyprland' from your display manager"
echo ""
print_info "Key bindings:"
echo "  SUPER + Space       Application launcher"
echo "  SUPER + Return      Terminal (Ghostty)"
echo "  SUPER + W           Wallpaper selector"
echo "  SUPER + N           Toggle waybar"
echo "  SUPER + Escape      Power menu"
echo "  SUPER + Q           Close window"
echo "  SUPER + h/j/k/l     Vim-style focus"
echo ""

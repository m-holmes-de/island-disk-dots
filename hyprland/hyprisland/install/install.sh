#!/bin/bash
# Hyprisland install runner
# Executes numbered migration scripts, tracking state so re-runs skip completed steps.
#
# Usage:
#   ./install.sh          Run pending migrations
#   ./install.sh --force  Re-run all migrations
#   ./install.sh --list   Show migration status

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="${HOME}/.local/state/hyprisland"
FORCE=false
LIST=false

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
DIM='\033[2m'
NC='\033[0m'

print_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[DONE]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[SKIP]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# ── Package installer (inherited by sourced scripts) ────────────────────────
install_packages() {
    local package_list=("$@")
    local pacman_packages=()
    local aur_packages=()

    for pkg in "${package_list[@]}"; do
        if pacman -Si "$pkg" &>/dev/null; then
            pacman_packages+=("$pkg")
        else
            aur_packages+=("$pkg")
        fi
    done

    if [ ${#pacman_packages[@]} -gt 0 ]; then
        print_info "Installing official packages: ${pacman_packages[*]}"
        sudo pacman -S --needed --noconfirm "${pacman_packages[@]}"
    fi

    if [ ${#aur_packages[@]} -gt 0 ]; then
        print_info "Installing AUR packages: ${aur_packages[*]}"
        yay -S --needed --noconfirm "${aur_packages[@]}"
    fi
}

# ── Parse args ──────────────────────────────────────────────────────────────
for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
        --list)  LIST=true ;;
        *)       print_error "Unknown argument: $arg"; exit 1 ;;
    esac
done

# ── Pre-flight checks (skip for --list) ────────────────────────────────────
if [ "$LIST" = false ]; then
    if [ ! -f /etc/arch-release ]; then
        print_error "This script is designed for Arch Linux"
        exit 1
    fi

    if ! command -v yay &>/dev/null; then
        print_warning "yay not found. Installing yay..."
        sudo pacman -S --needed --noconfirm git base-devel
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
        print_success "yay installed"
    fi
fi

# ── State management ───────────────────────────────────────────────────────
mkdir -p "$STATE_DIR"

is_completed() {
    local name="$1"
    [ -f "${STATE_DIR}/${name}" ]
}

mark_completed() {
    local name="$1"
    date -Iseconds > "${STATE_DIR}/${name}"
}

# ── Discover migrations ────────────────────────────────────────────────────
mapfile -t MIGRATIONS < <(find "$SCRIPT_DIR" -maxdepth 1 -name '[0-9][0-9][0-9]-*.sh' | sort)

if [ ${#MIGRATIONS[@]} -eq 0 ]; then
    print_error "No migration scripts found in $SCRIPT_DIR"
    exit 1
fi

# ── List mode ──────────────────────────────────────────────────────────────
if [ "$LIST" = true ]; then
    echo ""
    echo -e "${BLUE}Hyprisland migrations:${NC}"
    echo ""
    for migration in "${MIGRATIONS[@]}"; do
        name="$(basename "$migration" .sh)"
        if is_completed "$name"; then
            completed_at="$(cat "${STATE_DIR}/${name}")"
            echo -e "  ${GREEN}[done]${NC} ${name}  ${DIM}(${completed_at})${NC}"
        else
            echo -e "  ${YELLOW}[pending]${NC} ${name}"
        fi
    done
    echo ""
    exit 0
fi

# ── Run migrations ─────────────────────────────────────────────────────────
echo ""
print_info "Starting hyprisland installation..."
echo ""

pending=0
completed=0

for migration in "${MIGRATIONS[@]}"; do
    name="$(basename "$migration" .sh)"

    if [ "$FORCE" = false ] && is_completed "$name"; then
        print_warning "${name} (already completed)"
        ((completed++))
        continue
    fi

    print_info "Running ${name}..."
    # shellcheck source=/dev/null
    source "$migration"
    mark_completed "$name"
    print_success "${name}"
    echo ""
    ((pending++))
done

echo ""
if [ "$pending" -eq 0 ]; then
    print_success "All ${completed} migrations already completed. Use --force to re-run."
else
    print_success "Ran ${pending} migration(s), ${completed} already completed."
fi
echo ""

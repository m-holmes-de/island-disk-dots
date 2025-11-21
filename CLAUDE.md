# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a comprehensive dotfiles repository containing configuration files for macOS and Linux systems. It uses GNU Stow for symlink-based dotfile management, allowing selective deployment of configurations per OS. The repository emphasizes modern development tooling, terminal utilities, and Wayland/Hyprland desktop environment setup.

## Project Structure

The repository is organized by deployment target using Stow:

- **`shared/`** - Shared configurations for all systems
  - `.config/` - Application configs (zsh, tmux, etc.)
  - `.local/bin/` - Custom utility scripts
  - `.zshrc` / `.zsh_aliases` - Shell configuration

- **`linux/`** - Linux-specific configurations
  - `.config/xremap/` - Key remapping for X11/Wayland

- **`macos/`** - macOS-specific configurations
  - `.config/` - Homebrew and macOS-specific app configs

- **`hyprland/`** - Hyprland/Wayland desktop environment
  - `omarchy/` - Omarchy theme variant with Hyprland, Waybar, Rofi configs
  - `hyprisland/` - Alternative Hyprland configuration theme
  - `install/` - Installation scripts for Hyprland stack

- **`nvim-distros/`** - Multiple Neovim configurations
  - `nvim-lazy/` - LazyVim-based Neovim setup
  - `nvim-ex/` - Alternative Neovim configuration
  - `nver/` - Another Neovim variant

- **`distros/`** - OS-specific installation/setup scripts
  - `arch/` - Arch Linux post-installation automation
  - `fedora/` - Fedora installation guide
  - `nixos/` - NixOS configuration management

## Deployment with Stow

GNU Stow creates symlinks from dotfiles to the home directory. To deploy configurations:

```bash
# From repository root
cd /home/holmes/island-disk-dots/

# Deploy shared configs + OS-specific (example: Linux)
stow shared
stow linux

# Or for macOS
stow shared
stow macos

# Deploy Neovim configs
cd nvim-distros
stow -t $HOME nvim-lazy
```

To remove symlinks, use `stow -D <package>`.

## Key Architecture Decisions

### Multi-Neovim Setup

The `nvim-distros/` directory enables running multiple independent Neovim configurations via the `NVIM_APPNAME` environment variable. Shell aliases facilitate quick switching:
- `alias nvim=...` - Main Neovim (nvim-lazy)
- `alias nvex=...` - Alternative config (nvex)
- `alias nver=...` - Another variant (nver)

This allows testing different plugin setups without interfering with the main config.

### Hyprland Environment

The `hyprland/` directory contains complete Wayland desktop environment setups using UWSM (Universal Wayland Session Manager):
- Window manager: Hyprland (Wayland compositor)
- Status bar: Waybar (JSONC config + CSS styling)
- Launcher: Rofi
- Session manager: UWSM for proper app launching

Key architectural detail: Applications launched through Hyprland should use UWSM for proper session/environment handling (e.g., `uwsm app -- <command>`).

### Shell Setup

The `.zshrc` uses Zinit for plugin management with:
- Syntax highlighting and autosuggestions
- FZF tab completion for fuzzy directory navigation
- Zoxide for smart directory jumping (`cd` replaces with zoxide)
- Starship for prompt rendering

The shell includes vim mode (vi keybinds) with custom cursor shape switching.

### Installation Automation

Distro-specific scripts in `distros/` handle system setup:
- **arch-system.sh**: Pacman packages, AUR helpers, system configuration
- **fedora_install.md**: DNF packages and setup for Fedora
- **nixos/**: NixOS flakes and configuration management

These scripts follow best practices: error handling, logging, color output, and idempotency where possible.

## Important Configuration Files

### Shell
- `shared/.zshrc` - Primary shell configuration with Zinit, FZF, Starship
- `shared/.zsh_aliases` - Command aliases (vim→nvim, ls→eza, etc.)

### Hyprland (omarchy theme)
- `hyprland/omarchy/.config/hypr/hyprland.conf` - Main Hyprland config
- `hyprland/omarchy/.config/waybar/config.jsonc` - Status bar config
- `hyprland/omarchy/.config/waybar/style.css` - Waybar styling
- `hyprland/omarchy/.config/rofi/config.rasi` - Application launcher

### Utilities
- `shared/.local/bin/tmux-sessionizer` - Tmux session management
- `linux/.config/xremap/xremap.sh` - Key remapping automation

## Development Workflows

### Working with Hyprland Configs

The Hyprland setup uses a consistent Rose Pine color theme across all components. When modifying Hyprland/Waybar/Rofi configs:
1. Update colors consistently across all three (hyprland.conf, style.css, config.rasi)
2. Hyprland uses keybindings format: `bind = $mainMod, KEY, action, params`
3. Waybar uses JSONC format for configuration and CSS for styling
4. Test changes by reloading (SUPER+Shift+R in Hyprland or restarting the service)

Refer to `hyprland/hyprisland/CLAUDE.md` for comprehensive Hyprland-specific guidance.

### Working with Neovim Configs

Each Neovim config is independent and can be modified separately:
- LazyVim setup uses lazy.nvim plugin manager
- Configs use XDG directories (`~/.config/nvim`)
- Startup customizations via `nvim-distros/nvim-lazy/.config/nvim/init.lua`

Refer to `nvim-distros/nvim-lazy/.config/nvim/README.md` for LazyVim-specific details.

### Adding New System Packages

- **Arch Linux**: Add packages to `distros/arch/arch-system.sh` and keep `pacman.conf` in sync
- **Fedora**: Update `distros/fedora/fedora_install.md`
- **NixOS**: Modify flake files in `distros/nixos/`

### Common Stow Patterns

```bash
# Deploy just one package
stow nvim-lazy

# View what would be deployed without creating symlinks
stow --simulate shared

# Remove all symlinks for a package
stow -D shared

# Restow (remove then reapply) to fix broken links
stow -R shared
```

## Git Workflow

Current branch: `main`

Recent commits show configuration updates. For PRs:
1. Keep commits focused on single components (e.g., "Update Waybar theme colors")
2. Avoid mixing Hyprland, Neovim, and distro-specific changes in one commit
3. Test stow deployment before committing: `stow --simulate` to verify symlinks

## Security & Sensitive Data

- The `.zshrc` contains a pattern for sourcing API keys from `.api/avante_anthropic_api`
- Never commit actual API key files (they're gitignored)
- Keep `.local/bin/` scripts safe from injection (they use `bash -c` with user input)

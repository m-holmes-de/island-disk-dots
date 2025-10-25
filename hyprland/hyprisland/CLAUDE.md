# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains a Hyprland desktop environment configuration for Wayland on Linux (Arch). It's a complete dotfiles setup centered around the **Rose Pine** color theme, providing a cohesive visual experience across all components.

## Architecture

### Core Components

1. **Window Manager**: Hyprland (Wayland compositor)
   - Main config: `.config/hypr/hyprland.conf`
   - Lock screen: `.config/hypr/hyprlock.conf`
   - Idle management: `.config/hypr/hypridle.conf`

2. **Status Bar**: Waybar
   - Config: `.config/waybar/config.jsonc`
   - Styling: `.config/waybar/style.css`

3. **Application Launcher**: Rofi
   - Config: `.config/rofi/config.rasi`

4. **Session Manager**: UWSM (Universal Wayland Session Manager)
   - Default settings: `.config/uwsm/default` (defines TERMINAL and EDITOR)
   - Environment variables: `.config/uwsm/env`

5. **Utility Scripts**: `.local/bin/`
   - `rofi-power-menu` - Power management menu
   - `toggle-waybar` - Show/hide waybar
   - `island-disk-launch-wifi` - WiFi manager launcher (uses impala terminal UI)

### Design System

**Rose Pine Color Palette** is used consistently throughout:
- Base: `#191724` (dark background)
- Surface: `#1f1d2e` (UI elements)
- Text: `#e0def4` (main text)
- Pine: `#31748f` (accent, borders, active elements)
- Foam: `#9ccfd8` (secondary accent)
- Rose: `#ebbcba` (tertiary accent)
- Gold: `#f6c177` (highlights)
- Love: `#eb6f92` (urgent, errors)
- Iris: `#c4a7e7` (gradients)
- Muted: `#6e6a86` (inactive/dimmed)

## Key Configuration Details

### Hyprland Setup

- **Monitor**: 3456x2160@60Hz with 2x scaling
- **Keyboard Layout**: German (DE) with caps lock mapped to super
- **Layout**: Dwindle layout with pseudotiling
- **Modifier Key**: SUPER (Windows key)
- **Terminal**: Ghostty (launched via uwsm)
- **Browser**: Chromium with dark mode flags
- **File Manager**: Nautilus

### Important Keybindings

- `SUPER + Space` - Application launcher (rofi)
- `SUPER + Return` - Terminal
- `SUPER + Q` - Close window
- `SUPER + Escape` - Power menu
- `SUPER + N` - Toggle waybar
- `SUPER + h/j/k/l` - Vim-style focus navigation
- `SUPER + 1-9` - Switch workspaces
- `SUPER + S` - Toggle scratchpad workspace

### Waybar Modules

Left: Workspaces
Center: Clock
Right: CPU/Memory group, PulseAudio, Network (clickable to launch wifi manager), Battery, System tray

Network module clicks trigger the `island-disk-launch-wifi` script.

### Idle/Lock Behavior

- 2.5 minutes: Dim screen and keyboard backlight
- 5 minutes: Lock screen (hyprlock)
- 5.5 minutes: Turn off display
- 10 minutes: Suspend system

## Modifying the Configuration

### Changing Colors

When modifying colors, maintain consistency across:
1. Hyprland borders and shadows (hyprland.conf)
2. Waybar CSS variables (style.css)
3. Rofi theme variables (config.rasi)
4. Hyprlock colors (hyprlock.conf)

### Adding Keybindings

Add keybindings in `.config/hypr/hyprland.conf` in the KEYBINDINGS section. Use the format:
- `bind = $mainMod, KEY, action, params`
- `bindd = $mainMod, KEY, Description, action, params` (with description)
- `bindel =` for repeating binds (volume/brightness)
- `bindl =` for locked screen binds (media keys)

### Modifying Waybar

The waybar config uses JSONC format (JSON with comments). When adding modules:
1. Add module name to modules array (left/center/right)
2. Configure module in the root object
3. Add styling in `style.css` with Rose Pine colors

### Adding Window Rules

Window rules in hyprland.conf use either:
- `windowrule = RULE, CRITERIA` (old format)
- `windowrulev2 = RULE, CRITERIA` (new format, recommended)

Floating windows can use the `tag:floating-window` approach for consistent sizing.

## Session Management

This setup uses UWSM for proper session management. Applications should be launched via:
- `uwsm app -- <command>` for GUI applications
- Terminal already configured in hyprland.conf as `$terminal = uwsm app -- $TERMINAL`

The default terminal (Ghostty) and editor (nvim) are set in `.config/uwsm/default`.

## Git Workflow

Current branch: `main`
This repository tracks Hyprland-specific dotfiles separately from other system configurations.

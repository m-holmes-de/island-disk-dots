# SET UP SOME APPS IN SOFTWARE UI

## Apps to Download

- extension-manager
- spotify
- discord

## Extension Manager Apps

- user-themes
- Blur my Shell
- Just Perfection
- Tiling Assistant
- AppIndicator and KStatusNotifierItem Support

## Shortcuts and Workflow

You will have to set up a lot of stuff manually
However, I have started to set many shortcuts at least through this script: $HOME/dropped-bit-dots/.config/scripts/gnome-shortcuts.sh

## Nvidia Drivers

`sudo dnf install akmod-nvidia`

## For getting basic terminal stuff up and running

- Install starship prompt
- Install Nerd Fonts
- Install tpm for tmux
- Install rust
- Install Yazi (forgoten how to do this, so check website for dependencies)

Then run something like this:

```

sudo dnf install neovim npm python eza bat zoxide stow alacritty unzip tmux ripgrep fastfetch btop
```

### xremap

You probably really want this as it drives me crazy not having it

```
cargo install xremap --features gnome
```

### lazygit

```
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit
```

# ARCHIVE: SETTING UP HYPRLAND

USE THIS INSTEAD: https://copr.fedorainfracloud.org/coprs/solopasha/hyprland
hyprland=(
"hyprland"
"waybar"
"brightnessctl"
"network-manager-applet"
"swayidle"
"lz4" # swww dependency
"blueman"
"pamixer"
"mako"
)

# Build from source stuff for hyprland

## SWWW - https://github.com/LGFae/swww

git clone https://github.com/LGFae/swww.git $HOME/Builds/swww

# gtklock

# Ready the wiki on the gitpage to know how to make sure it works with auth and fingerprint

dnf install gcc meson pkgconf scdoc pam-devel wayland-devel gtk3-devel gtk-layer-shell-devel
git clone https://github.com/jovanlanik/gtklock

# Dev

# You need to install docker using instructions: https://developer.fedoraproject.org/tools/docker/docker-installation.html

dev=(
"dnf-plugins-core"
"docker-ce"
"docker-ce-cli"
"containerd.io"
"docker-compose"
)

# This helps to make sure mysqlclient via pip install works

python_dev_django=(
"python-devel"
"mysql-devel"
)

#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

# Get the username (the user who called sudo, or ask if run directly as root)
if [ -n "$SUDO_USER" ]; then
  USERNAME="$SUDO_USER"
else
  read -p "Enter username for autologin: " USERNAME
fi

# Verify user exists
if ! id "$USERNAME" &>/dev/null; then
  echo "Error: User $USERNAME does not exist"
  exit 1
fi

echo "Setting up autologin for user: $USERNAME"

# Create the directory if it doesn't exist
mkdir -p /etc/systemd/system/getty@tty1.service.d

# Copy the autologin.conf to the correct location
# Assuming autologin.conf is in the same directory as this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$SCRIPT_DIR/autologin.conf" ]; then
  echo "Error: autologin.conf not found in $SCRIPT_DIR"
  exit 1
fi

# Replace USERNAME placeholder in config file and copy
sed "s/USERNAME/$USERNAME/g" "$SCRIPT_DIR/autologin.conf" >/etc/systemd/system/getty@tty1.service.d/autologin.conf

echo "Configuration file copied to /etc/systemd/system/getty@tty1.service.d/autologin.conf"

# Enable the service
systemctl enable getty@tty1.service

echo "✓ Autologin setup complete for user $USERNAME on tty1"
echo "Reboot to activate autologin"

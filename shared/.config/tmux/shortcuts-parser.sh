#!/bin/bash

echo "=== TMUX BINDINGS ==="
grep -E "^bind(-key)?\s" ~/.config/tmux/tmux.conf | \
  sed 's/bind-key/bind/' | \
  awk '{print $2, $3, $4, $5}'

echo ""
echo "=== ZSH KEYBINDINGS ==="
grep "^bindkey" ~/.zshrc | \
  sed "s/bindkey //" | \
  sed "s/'//g"

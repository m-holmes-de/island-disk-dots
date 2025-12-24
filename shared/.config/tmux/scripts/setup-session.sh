#!/bin/bash
# Auto-setup tmux session windows

# Get the session name
SESSION=$(tmux display-message -p '#S')

# Only run if this is a fresh session with just 1 window
WINDOW_COUNT=$(tmux list-windows -t "$SESSION" | wc -l)
if [ "$WINDOW_COUNT" -gt 1 ]; then
    exit 0
fi

# Rename first window to 'code'
tmux rename-window -t "$SESSION:1" 'code'

# Create additional windows
tmux new-window -t "$SESSION:2" -n 'server'
tmux new-window -t "$SESSION:3" -n 'term'
tmux new-window -t "$SESSION:4" -n 'yazi' 'yazi'
tmux new-window -t "$SESSION:5" -n 'git'

# Go back to first window
tmux select-window -t "$SESSION:1"

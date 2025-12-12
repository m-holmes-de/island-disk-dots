#!/bin/bash
# CPU usage for tmux status bar (works on macOS and Linux)

if [[ "$(uname)" == "Darwin" ]]; then
    # macOS: use top in logging mode
    top -l 1 -n 0 | awk '/CPU usage/ {printf "%.0f%%", $3}'
else
    # Linux: use /proc/stat
    read -r cpu user nice system idle rest < /proc/stat
    total=$((user + nice + system + idle))
    idle_pct=$((idle * 100 / total))
    printf "%d%%" $((100 - idle_pct))
fi

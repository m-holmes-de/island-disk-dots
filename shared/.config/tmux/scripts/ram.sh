#!/bin/bash
# RAM usage for tmux status bar (works on macOS and Linux)

if [[ "$(uname)" == "Darwin" ]]; then
    # macOS: use vm_stat
    pages_free=$(vm_stat | awk '/Pages free/ {gsub(/\./, "", $3); print $3}')
    pages_inactive=$(vm_stat | awk '/Pages inactive/ {gsub(/\./, "", $3); print $3}')
    pages_speculative=$(vm_stat | awk '/Pages speculative/ {gsub(/\./, "", $3); print $3}')
    total_mem=$(sysctl -n hw.memsize)
    page_size=$(sysctl -n hw.pagesize)

    free_mem=$(( (pages_free + pages_inactive + pages_speculative) * page_size ))
    used_mem=$(( total_mem - free_mem ))
    used_pct=$(( used_mem * 100 / total_mem ))
    printf "%d%%" "$used_pct"
else
    # Linux: use /proc/meminfo
    free -m | awk '/Mem:/ {printf "%.0f%%", ($3/$2)*100}'
fi

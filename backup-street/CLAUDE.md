# Backup Street

## Overview

Backup Street is an interactive TUI-based rsync backup tool for backing up the home folder to external drives. It lives in the `island-disk-dots` dotfiles repo as a standalone tool.

## Goals

- **Simple, interactive home folder backup** — no config files to maintain, just run it and pick what to back up
- **Pre-reinstall safety net** — primary motivation was backing up before encrypting the boot drive with LUKS
- **Idempotent** — safe to run multiple times; rsync handles deduplication naturally
- **Portable** — minimal dependencies (bash, rsync, fzf), works on any Arch/Linux system
- **Opinionated defaults** — ships with sensible exclusions (.cache, node_modules, build artifacts) so backups are lean

## Architecture

Single bash script (`backup-street`) with 4 interactive steps:

1. **Destination selection** — scans `/run/media/$USER/`, `/mnt/`, `/media/` for mounted external drives. Falls back to manual path input if none found.
2. **Folder selection** — lists all top-level items in `$HOME`, multi-select via `gum` (preferred) or `fzf` (fallback).
3. **Exclude configuration** — presents default exclusion patterns, allows adding custom comma-separated patterns.
4. **Execution** — optional dry-run preview, then rsync with progress output. Logs to `~/.local/state/backup-street/last-backup.log`.

### Backup output structure

```
<destination>/backup-street/<hostname>-<YYYY-MM-DD>/
├── Projects/
├── Documents/
├── .ssh/
├── .config/
└── ...
```

### TUI backend

- **gum** (charmbracelet) — prettier bordered UI, checkbox multi-select. Optional.
- **fzf** — fallback for folder selection with preview pane showing directory contents.
- Both produce the same result; gum just looks nicer.

## Dependencies

- `rsync` — core backup engine
- `fzf` — interactive selection (required if gum not installed)
- `gum` — optional, prettier TUI (AUR: `gum`)

## Key Design Decisions

- **No incremental/snapshot system** — intentionally simple. This is rsync-to-external, not a backup framework. For ongoing backups, the user should consider borgbackup or btrfs snapshots.
- **No scheduling** — run manually when needed. This is a pre-reinstall / ad-hoc tool.
- **No compression** — rsync copies files as-is. External drives have plenty of space and this keeps restores trivial (just copy files back).
- **Date-stamped folders** — each run creates a new dated folder rather than overwriting. User manages cleanup.
- **No restore command** — restoring is just copying files back from the backup folder. No tooling needed.

## Future Considerations

- Add `--restore` mode that reverses the process (pick a backup, pick folders, rsync back)
- Add rsync `--link-dest` to previous backup for space-efficient incremental backups
- Add backup profiles (save folder selections for repeated use)
- Consider adding to `scripts/` stow package so it lands in `~/.local/bin/` automatically
- Integrate with systemd timer for optional scheduled backups

## File Layout

```
backup-street/
├── CLAUDE.md       # this file
└── backup-street   # main executable script
```

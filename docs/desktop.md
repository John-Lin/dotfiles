# Desktop And Platform-Specific Config

## Aerospace And Borders

macOS window-management config lives in:

- `aerospace/.config/aerospace/aerospace.toml`
- `borders/.config/borders/bordersrc`

Install with:

```bash
make sync-aerospace
```

These configs are macOS-specific and include `osascript`-based workflows.

## Omarchy / Hyprland

Linux desktop-related config lives in `omarchy/`.

Key areas:
- `omarchy/MIGRATION-4.0.md` - how to configure a machine; start here
- `omarchy/omarchy3/` - the old Omarchy 3 `.conf` files, kept for reference
- `omarchy/pre-install.sh` - setup script
- `omarchy/fix-brcmfmac/` - Broadcom Wi-Fi workaround

Notes:
- There is no `make` target for Omarchy, and there never was. Configure a
  machine by following `omarchy/MIGRATION-4.0.md`, which covers the Hyprland
  Lua config, idle behaviour, and terminal settings.
- Omarchy 4.0 replaced the Hyprland `.conf` tree with Lua, so nothing in
  `omarchy/omarchy3/` is installable. Delete that directory once 4.x has
  proven stable.
- Wi-Fi fix: see `omarchy/fix-brcmfmac/README.md`

## Portability Notes

This repo supports both macOS and Linux, but several areas are intentionally machine- or OS-specific:

- `zsh/` assumes a macOS/Homebrew-oriented environment in several places
- `aerospace/` and `borders/` only make sense on macOS
- `omarchy/` is Linux-specific and includes Arch-oriented assumptions
- terminal configs differ between macOS and Linux

# Omarchy 3 -> 4.0 config migration

Notes from migrating an in-place upgrade (Omarchy 4.0.0-1, 2026-08-16).
Follow this on the next machine that gets upgraded.

## What actually changed

Omarchy 4.0 replaced the Hyprland `.conf` config tree with a Lua one.
`~/.config/hypr/hyprland.lua` is the new entry point; it loads Omarchy's
defaults via `default/hypr/bootstrap.lua`, then `require`s the user modules
`hypr.monitors`, `hypr.input`, `hypr.bindings`, `hypr.looknfeel`,
`hypr.autostart`.

The old `~/.config/hypr/hyprland.conf` is no longer read by anything, so every
file it used to `source` is dead weight as well.

### Why the old `.conf` files are still sitting there

This is the part that makes the breakage silent. In
`/usr/share/omarchy/bin/omarchy-upgrade-to-quattro`:

- `always_copy_config_files` unconditionally installs the new quattro entry
  points (`hypr/hyprland.lua`, `input.lua`, `bindings.lua`, `monitors.lua`,
  `looknfeel.lua`, `autostart.lua`, `.luarc.json`), backing up any same-named
  file first.
- Files are only deleted if their sha256 matches an entry in the upgrader's
  `retire` hash table. **That table contains no `hypr/*.conf` entries at all**,
  so the old Hyprland `.conf` files are never removed.
- **There is no `.conf` -> `.lua` converter.** The upgrader does not read the
  old settings; it just drops in a fresh, fully commented-out template.

Net effect: the upgrade completes cleanly, `hyprctl configerrors` is empty, and
every personal Hyprland customization silently stops applying. Nothing warns
you. You find out when a keybinding or a remapped key stops working.

Verify what is actually live rather than trusting the files on disk:

```bash
hyprctl getoption input:kb_options   # not what input.conf says
hyprctl devices                      # per-keyboard rules/layout/options
hyprctl configerrors                 # empty is expected even when settings are lost
```

## File-by-file mapping

| Omarchy 3 | Omarchy 4.0 | Status |
|---|---|---|
| `hypr/hyprland.conf` | `hypr/hyprland.lua` | Orphaned; new entry point is packaged |
| `hypr/input.conf` | `hypr/input.lua` | **Migrated** (see below) |
| `hypr/bindings.conf` | `hypr/bindings.lua` | **Migrated** (see below) |
| `hypr/monitors.conf` | `hypr/monitors.lua` | Migrated by hand (scale 1.25) |
| `hypr/looknfeel.conf` | `hypr/looknfeel.lua` | Nothing to migrate (was all comments) |
| `hypr/autostart.conf` | `hypr/autostart.lua` | Nothing to migrate |
| `hypr/envs.conf` | `hl.env(...)` in any Lua module | Nothing to migrate |
| `hypr/hypridle.conf` | `omarchy/shell.json` -> `idle` | **Obsolete**, `hypridle` package removed |
| `hypr/hyprlock.conf` | Quickshell lock (`omarchy-shell lock`) | **Obsolete**, `hyprlock` package removed |
| `hypr/hyprsunset.conf` | unchanged (still `.conf`) | Keep |
| `hypr/xdph.conf` | unchanged (still `.conf`) | Keep |

`~/.local/share/omarchy` is now a symlink to `/usr/share/omarchy`. Any config
that hardcodes the old path still resolves, but should be rewritten to the
plain command name on `PATH`.

## Syntax translation

Config values move from bare blocks to `hl.config({ ... })` tables:

```lua
-- Omarchy 3: input { repeat_rate = 40 }
hl.config({ input = { repeat_rate = 40 } })
```

Keybindings move from `bindd = MODS, KEY, Description, exec, cmd` to
`o.bind("MODS + KEY", "Description", "cmd")`. Unbinding a default must happen
*before* rebinding the same key:

```lua
hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")
```

Window rules move from `windowrule = ...` to `o.window(match, { ... })`:

```lua
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
```

Monitors move from `monitor = ,preferred,auto,1` to `hl.monitor({ ... })`, and
`env = GDK_SCALE,1` to `hl.env("GDK_SCALE", "1")`.

Hyprland window-rule syntax changes often -- check
<https://wiki.hypr.land/Configuring/Basics/Window-Rules/> before writing rules
instead of copying old ones.

## Migration procedure

1. Confirm the version and that the Lua entry point is in place:
   `omarchy version && head -5 ~/.config/hypr/hyprland.lua`
2. Keep the old `.conf` files as the source of truth for what you had. Do not
   delete them until every setting is ported.
3. Port one file at a time into its `.lua` counterpart.
4. After each file: `hyprctl reload && hyprctl configerrors`, then verify the
   setting actually took effect with `hyprctl getoption <name>`. An empty
   `configerrors` does **not** mean your setting applied.
5. Once everything is verified, delete the orphaned `.conf` files and the
   `*.bak*` clutter in `~/.config/hypr/`.

## Porting principle: only carry over the real deltas

Do **not** transcribe the old `.conf` wholesale. Omarchy 4 changed several of
its own defaults, and some of them now match what used to be a personal
override. Compare against the real defaults first -- `.lua` files under
`$OMARCHY_PATH/default/hypr/` hold the actual values, not the fully
commented-out user templates in `$OMARCHY_PATH/config/hypr/`.

Porting `input.conf` verbatim produced three settings that were already the
4.0 default (`repeat_rate = 40`, `clickfinger_behavior = true`, and both
terminal `scroll_touchpad` window rules -- Omarchy ships those two lines
itself). Every redundant line makes future diffs harder to read, which defeats
the point of keeping the config small.

Useful behaviour confirmed while doing this: nested tables **merge** rather
than replace. Setting only `touchpad = { natural_scroll = true }` leaves
`clickfinger_behavior` and `scroll_factor` on their defaults. Top-level string
options do *not* merge -- `kb_options` replaces the whole string.

## Migrated: `input.lua`

The Ctrl/Caps Lock remap was the first casualty. Old `input.conf` had three
`kb_options` lines (`compose:caps`, `ctrl:swapcaps`, `ctrl:nocaps`); Hyprland
takes the last assignment, so only `ctrl:nocaps` was ever effective. On this
machine we deliberately switched to a true swap.

Final config -- only two personal overrides:

```lua
hl.config({
  input = {
    -- Swap Ctrl and Caps Lock.
    kb_options = "ctrl:swapcaps",

    -- Use natural (inverse) scrolling.
    touchpad = { natural_scroll = true },
  },
})
```

Decisions behind that, comparing the old `input.conf` to the 4.0 defaults:

| Setting | Omarchy 3 | Omarchy 4 default | Kept? |
|---|---|---|---|
| `kb_options` | `ctrl:nocaps` | `compose:caps,shift:both_capslock_cancel` | Yes, as `ctrl:swapcaps` |
| `touchpad.natural_scroll` | `true` | `false` (changed in 4.0) | Yes |
| `repeat_rate` | 40 | 40 | No -- identical |
| `repeat_delay` | 600 | 250 | No -- took the 4.0 default |
| `touchpad.clickfinger_behavior` | `true` | `true` | No -- identical |
| `touchpad.scroll_factor` | 0.3 | 0.4 | No -- took the 4.0 default |
| terminal `scroll_touchpad` rules | present | identical, already shipped | No -- redundant |

Setting `kb_options` replaces Omarchy's default
`compose:caps,shift:both_capslock_cancel` outright -- it does not append, so
the compose key is given up. Both of those defaults also remap Caps Lock, so
they conflict with `ctrl:*` anyway. This was equally true in Omarchy 3.

Verify: `hyprctl getoption input:kb_options` must print `ctrl:swapcaps`.

## Migrated: `bindings.lua`

Most of the old `bindings.conf` turned out to be redundant: Omarchy 4.0 ships
`SUPER + RETURN`, `SUPER SHIFT + RETURN/F/B/M/N/A/Y/X/SLASH`,
`SUPER SHIFT ALT + B/M`, and `SUPER ALT + RETURN` (tmux) as defaults with the
same meanings. Diff against `omarchy menu keybindings --print` before porting
anything -- only the genuine deltas need to be in `bindings.lua`:

```lua
-- Swap out preinstalled apps for the ones actually in use.
hl.unbind("SUPER + SHIFT + G")
o.bind("SUPER + SHIFT + G", "Telegram", { launch = "telegram-desktop" })

hl.unbind("SUPER + SHIFT + O")
o.bind("SUPER + SHIFT + O", "Logseq", { launch = "logseq" })

-- macOS-style screenshot keys, alongside Omarchy's own PRINT bindings.
o.bind("SUPER + SHIFT + CTRL + 2", "Screenshot region", "omarchy-capture-screenshot region")
o.bind("SUPER + SHIFT + CTRL + 3", "Screenshot screen", "omarchy-capture-screenshot fullscreen")
o.bind("SUPER + SHIFT + CTRL + 4", "Screenshot window", "omarchy-capture-screenshot windows")
```

Old bindings deliberately **not** carried over:

| Old binding | Why dropped |
|---|---|
| `SUPER SHIFT + E` -> Proton Mail | No longer used; 4.0's hey.com default is fine |
| `SUPER SHIFT + T` -> btop | 4.0 moved Activity to `SUPER CTRL + T`; adopted the new key |
| `unbind PRINT` | 4.0's native `PRINT` screenshot is worth keeping alongside 2/3/4 |
| lid-switch `bindl` hooks | Already commented out; 4.0 ships `SUPER CTRL + Delete` (toggle laptop display) and `SUPER CTRL ALT + Delete` (mirroring) natively |

Gotchas hit while porting:

- `omarchy-cmd-screenshot` is **gone**, replaced by `omarchy-capture-screenshot`.
  Its modes were renamed too: `output` -> `fullscreen`, `window` -> `windows`.
  Drop the old `~/.local/share/omarchy/bin/` path prefix and call it by name.
- Prefer the descriptor tables (`{ omarchy = }`, `{ launch = }`, `{ tui = }`,
  `{ webapp = }`) over raw command strings -- see
  `/usr/share/omarchy/default/hypr/bindings/applications.lua` for the idioms.
  `{ launch = }` already wraps the command with `uwsm-app`.
- `SUPER SHIFT ALT + E` ("New email") is a separate hey.com default and does not
  follow any `SUPER SHIFT + E` override. Rebind it separately if it matters.
- `omarchy-launch-browser`, `omarchy-launch-webapp`, `omarchy-launch-editor`,
  `omarchy-launch-or-focus`, `omarchy-launch-or-focus-webapp`,
  `omarchy-cmd-terminal-cwd` and `uwsm-app` all still exist in 4.0.
- Run `omarchy commands` to confirm a command still exists before porting a
  binding that calls it.

## Beyond Hyprland: the rest of the sweep

The `.conf` -> `.lua` change gets the attention, but 4.0 moved other things too.
Work through these as well.

### Idle timings moved to `shell.json`

`hypridle` and `hyprlock` are gone as packages. Idle behaviour is now the
Quickshell shell's, configured at the top level of `~/.config/omarchy/shell.json`:

```json
"idle": { "screensaver": 150, "lock": 300 }
```

Only those two keys exist -- both in seconds since idle began. There is **no
display-off timeout to port**; `omarchy system lock` turns the display off as
part of locking. The old three-listener `hypridle.conf` (screensaver 600, lock
720, dpms off 780) has no direct equivalent, and on this machine we simply took
the 4.0 defaults instead of restoring the old timings.

Two other `hypridle`/`hyprlock` settings need no action at all:

- `lock_cmd` locking 1Password: `omarchy-system-lock` does this natively now.
- `auth { fingerprint:enabled = true }`: check with `omarchy hw fingerprint`
  before porting. On this machine it exits 1 (no reader), so the setting was
  already dead. Where a reader does exist, use
  `omarchy setup security fingerprint` rather than a config file.

### Terminal configs drift silently

The upgrade leaves customized terminal configs alone, so any option Omarchy
*added* to its defaults is simply missing from yours. Diff them:

```bash
diff -u /usr/share/omarchy/config/ghostty/config ~/.config/ghostty/config
diff -u /usr/share/omarchy/config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
```

Three ghostty defaults were missing here and got added back: `window-theme =
ghostty`, `gtk-toolbar-style = flat`, and `ssh-env` in
`shell-integration-features` (SSH session terminfo -- note all shell-integration
options must be passed together as one comma-separated value). Two personal
keybinds (`f11=toggle_fullscreen`, `shift+enter=text:\x1b\r`) were dropped in
favour of the 4.0 defaults, and `mouse-scroll-multiplier` / `async-backend` had
quietly become defaults themselves.

Watch the load order when reverting a keybind to its default: ghostty applies
the last definition it reads, and `config-file` includes are read at the point
they appear. Removing an override from `config` does not restore the Omarchy
default if a later include rebinds the same key -- `custom.conf` still sets
`shift+enter=text:\n` here, so that is what actually takes effect.

### Leftover `uwsm/env` line

The upgrader rewrites legacy Omarchy-managed lines from `~/.config/uwsm/env`
into no-op markers in `~/.config/uwsm/env.d/99-omarchy-upgrade-env`. It matches
those lines **literally**, so near-misses survive. A `export
PATH=$OMARCHY_PATH/bin/:$PATH` (note the trailing slash after `bin`) slipped
through here. 4.0 puts the Omarchy commands on `PATH` via the package, so any
surviving line of this kind is redundant -- read that file after upgrading and
clear what the upgrader missed.

### Confirmed as needing nothing

`envs.conf`, `xdph.conf`, `hyprsunset.conf`, `looknfeel.conf` and
`autostart.conf` were all stock. Input-method settings live in
`/etc/environment`, outside `~/.config`, so the upgrade never touched them.

## Tracking personal changes vs. Omarchy defaults

Omarchy keeps the pristine defaults on disk at `$OMARCHY_PATH/config/`
(`/usr/share/omarchy/config/`), owned by pacman and updated by `omarchy update`.
So the personal delta is just a diff -- no extra tooling required:

```bash
diff -u /usr/share/omarchy/config/hypr/input.lua ~/.config/hypr/input.lua
```

Restore a single file to the shipped default (backs up the current version and
prints the diff before replacing):

```bash
omarchy refresh config hypr/input.lua
```

Two limitations worth knowing:

- The baseline moves with each `omarchy update`, so a diff only ever shows the
  delta *right now*. It cannot tell you whether a line changed because you
  edited it or because Omarchy changed its default. Use git history for that.
- It only covers files Omarchy actually ships in `config/`. Retired files such
  as `hypridle.conf` have no baseline to compare against at all.

## Repo scope

The old configs live in `omarchy/omarchy3/` and are **reference material only**
-- the record of what the Omarchy 3 setup was, kept so it can be compared
against. Nothing installs them.

The four files there (`input.conf`, `bindings.conf`, `hypridle.conf`,
`hyprlock.conf`) are deliberately kept even though the migration is done, so
there is something to compare against if a 4.x release turns out to have
regressed something. **Delete `omarchy/omarchy3/` once 4.x has proven stable in
daily use.**

`monitors.conf.benq` and `monitors.conf.dell` were dropped -- those external
displays are no longer in use, so there was nothing worth translating.

There is no `make` target for any of this, and there never was: `omarchy/` was
always copied by hand. Configuring a machine means following this document, not
running `make`. The one adjacent target, `sync-ghostty-linux`, installs
`ghostty-linux/.config/ghostty/custom.conf` and is unrelated to Omarchy.

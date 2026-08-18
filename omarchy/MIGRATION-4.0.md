# Omarchy 3 -> 4.0 config migration

Notes from migrating an in-place upgrade (Omarchy 4.0.0-1, first done 2026-08-16,
repeated on a second machine 2026-08-17). Follow this on the next machine that
gets upgraded.

The mechanics of 4.0 apply everywhere; the numbers and per-setting decisions do
not. Concrete values in here — backup sizes, `.bak` file counts, monitor scales,
idle timings, which keybindings were worth keeping — are what one machine had,
recorded so there is something to compare against. Re-derive them per machine
instead of transcribing them. The second machine differed on nearly all of
them and still followed every procedure below unchanged.

## What actually changed

Two structural changes drive everything else. Omarchy internals moved from a git
checkout into pacman packages, which is why `/etc` suddenly grows `.pacnew`
files and why stale pre-package files now sit there unowned. And the Hyprland
config tree went from `.conf` to Lua:

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
  file first. The same list also installs `omarchy/shell.json`,
  `omarchy/extensions/omarchy-menu.jsonc` and
  `omarchy/hooks/pre-refresh-pacman.d/add-custom-repo.sample` — `shell.json`
  matters because that is where the idle timings now live, so the upgrade
  overwrites them.
- The upgrader keeps one sha256 table of known default file contents, tagged
  with an action per row: `retire` (delete the file) or `refresh` (replace it
  with the 4.0 version). **The table has no `retire` rows for `hypr/*.conf` at
  all**, so the old Hyprland `.conf` files are never removed. It does carry
  `refresh` rows for `hypr/hyprsunset.conf` and `hypr/xdph.conf` — see the
  mapping table below.
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

`hyprctl getoption` is the only trustworthy reader for a live value. `hyprctl
descriptions` looks like a better one — it prints every option with an official
description, its Hyprland compile-time `default`, and a `current` — but that
`current` field does not reflect the loaded config. It reported `repeat_delay`
600 and `kb_options` empty on a machine where `getoption` returned 250 and
`ctrl:swapcaps`, and it casts floats to int (`scroll_factor` 0.4 prints as 0).
Use it for the `description` and `default` columns, which are static metadata,
and never for what is live.

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
| `hypr/hyprsunset.conf` | still `.conf`, but content refreshed | Nothing to migrate; see below |
| `hypr/xdph.conf` | still `.conf` | Keep; see below |

Neither of the two surviving `.conf` files is simply left alone. Both have
`refresh` rows in the upgrader's hash table (four for `hyprsunset.conf`, two for
`xdph.conf`), so an untouched one is replaced with the 4.0 version and the old
copy is kept as `*.omarchy-upgrade-to-quattro.*.bak`. `hyprsunset.conf` was
refreshed on both machines — the new version drops the old `.conf` autostart hint
in favour of `o.launch_on_start("hyprsunset")` in `autostart.lua`.

A customized one keeps whatever you had, because its sha256 matches no row.
That is worth knowing before reading the config sweep at the end of this
document: `xdph.conf` shows up as `DIFFERS` there purely because its two lines
are in the opposite order from the shipped file. Same settings, non-matching
hash, so the refresh skipped it. Reordering it to match would let a future
`refresh` row apply cleanly.

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
5. Leave the orphaned `.conf` files in place until 4.x has proven stable in
   daily use -- they are the only record of what the old behaviour was. The
   `*.bak*` clutter that `omarchy refresh` leaves in `~/.config/hypr/` can go
   at any time.
6. Sweep everything outside `~/.config/hypr/` before calling it done. In rough
   order of how much it can hurt: `/etc` pacnews (a broken greeter locks you
   out), unowned leftovers in `/etc/udev/rules.d/`, then the quieter drifts --
   `xdg-terminals.list`, terminal configs, `uwsm/env`. Each has its own section
   below.
7. Check the retired-package list actually ran. The upgrader removes packages in
   one batch and only falls back to per-group removal *on failure*, so a name
   missing from the main list survives silently. Compare the batch in
   `pacman.log` against `retired_packages` in the upgrader.

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

### Your terminal choice is dropped, not migrated

`~/.config/xdg-terminals.list` is what `omarchy default terminal` writes, so it
records a personal choice rather than an Omarchy default. The upgrader retires
it like any other config and writes no replacement, which silently discards that
choice. On this machine it held `com.mitchellh.ghostty.desktop`.

With it gone, the system list
`/usr/share/xdg-terminal-exec/hyprland-xdg-terminals.list` takes over and names
`foot.desktop`. Everything that opens a terminal through `xdg-terminal-exec`
follows it.

The upstream default moved **Alacritty -> Foot**, not Ghostty -> Foot: Omarchy
3's shipped `config/xdg-terminals.list` said `Alacritty.desktop`, and
[#5831](https://github.com/basecamp/omarchy/pull/5831) swapped `alacritty` for
`foot` in `install/omarchy-base.packages`. dhh's stated reason was "Foot is
lean, fast and seemingly giving up nothing on Alacritty." Ghostty was always a
local choice here, and it remains a first-class supported option in 4.0 -- just
never the default.

Nothing is damaged: Ghostty stays installed and `~/.config/ghostty/` is
untouched. Re-assert the choice with the real command rather than by restoring
the backup, since it writes the file in the format the tooling expects:

```bash
omarchy default terminal ghostty   # or: menu > Setup > Defaults > Terminal
```

Decided on this machine 2026-08-16: stay on Foot. It is the lighter default and
worth running for real before overriding it. Nothing about Ghostty was removed
to make that choice -- the package, `~/.config/ghostty/`, and this repo's
`ghostty/` and `ghostty-linux/` trees are all untouched, so switching back is
the one command above.

#### Proving which terminal you are actually in

`$TERM` cannot tell them apart, because Omarchy's `foot.ini` sets
`term=xterm-256color`. Ask the compositor and the process table instead:

```bash
omarchy default terminal                       # what new terminals will be
hyprctl activewindow -j | jq -r '.class, .pid' # what this window is
ps -o comm=,args= -p "$(hyprctl activewindow -j | jq -r .pid)"
```

### Leftover `uwsm/env` line

The upgrader rewrites legacy Omarchy-managed lines from `~/.config/uwsm/env`
into no-op markers in `~/.config/uwsm/env.d/99-omarchy-upgrade-env`. It matches
those lines **literally**, so near-misses survive. A `export
PATH=$OMARCHY_PATH/bin/:$PATH` (note the trailing slash after `bin`) slipped
through here. 4.0 puts the Omarchy commands on `PATH` via the package, so any
surviving line of this kind is redundant -- read that file after upgrading and
clear what the upgrader missed.

### Stale udev rules from the Omarchy 3 era

Two rules survived with no owner (`pacman -Qo` finds no package), and both
failed on every boot and every AC event:

```
(udev-worker): ADP1: Process '.../omarchy-powerprofiles-set' failed with exit code 1.
(udev-worker): ADP1: Process '.../omarchy-wifi-powersave off' failed with exit code 1.
```

4.0 replaced the mechanism behind each, so they are redundant as well as broken:

| Job | Omarchy 3 | Omarchy 4 |
|---|---|---|
| Power profile on AC/battery | `99-power-profile.rules` calling `omarchy-powerprofiles-set` with no arguments | `omarchy-powerprofiles-init` from `default/hypr/autostart.lua`, plus the shell's battery service |
| Wi-Fi power save | `99-wifi-powersave.rules` calling `omarchy-wifi-powersave` | `/etc/NetworkManager/conf.d/omarchy-wifi-powersave.conf` pinning `wifi.powersave = 2` |

`omarchy-wifi-powersave` does not exist in 4.0 at all, so that rule could only
ever fail. Both also hardcoded `~/.local/share/omarchy/bin/`, the path 4.0
turned into a symlink.

The power-profile rule fails for a less obvious reason, and it is not the
argument list: `omarchy-powerprofiles-set` opens with
`action="${1:-autodetect}"`, so calling it with no arguments is still valid in
4.0. What fails is the `systemd-run` wrapper in the rule itself — it exits 1 and
the unit is never created, so `journalctl -u omarchy-power-profile` has no
entries to explain anything. Do not go looking for a fixable argument bug; the
rule is redundant either way.

Removed on 2026-08-16, which left `/etc/udev/rules.d/` empty:

```bash
rm -f /etc/udev/rules.d/99-power-profile.rules \
      /etc/udev/rules.d/99-wifi-powersave.rules
udevadm control --reload
```

Verify by re-firing the events rather than waiting for a real unplug. The
trigger needs root — without it every `uevent` write is denied, and the grep
then finds nothing because no event fired, which reads exactly like success:

```bash
sudo udevadm trigger --subsystem-match=power_supply   # or via pkexec
journalctl --since '1 min ago' | grep -i 'udev-worker.*failed'
```

Then confirm the 4.0 replacements are actually doing the removed rules' jobs,
rather than assuming the mechanism swap worked:

```bash
iw dev <wlan-if> get power_save   # expect: off (from the NetworkManager pin)
powerprofilesctl get              # expect: performance while on AC
cat /sys/class/power_supply/ADP1/online
```

Their contents, in case a 4.x regression makes them worth reconstructing:

```
# 99-power-profile.rules  (one line each for Mains and USB)
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="/usr/bin/systemd-run --no-block --collect --unit=omarchy-power-profile --property=After=power-profiles-daemon.service <home>/.local/share/omarchy/bin/omarchy-powerprofiles-set"

# 99-wifi-powersave.rules  (online==0 -> on, online==1 -> off)
SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="/usr/bin/systemd-run --no-block --collect --unit=omarchy-wifi-powersave-on <home>/.local/share/omarchy/bin/omarchy-wifi-powersave on"
```

### The `walker` package survives the upgrade

`retired_packages` in `omarchy-upgrade-to-quattro` lists `omarchy-walker` and
`walker-bin`, but not plain `walker`. Plain `walker` appears only inside a
`fallback_groups` entry -- the single space-separated string
`"omarchy-walker walker elephant-all elephant ..."` -- and the script reaches
`fallback_groups` *only when the batch removal fails*. Grepping the upgrader for
`walker` is misleading here, because that same string also appears in a comment
near `retired_packages`; check which array actually contains the match. The
batch succeeded here, so `omarchy-walker` and all twelve `elephant-*` providers
were removed and `walker` itself stayed behind -- explicitly installed, required
by nothing.

Everything else about walker was cleaned up, which is what makes this a gap in
the removal list rather than a decision: `~/.config/walker` (backed up),
`~/.config/elephant`, `~/.config/autostart/walker.desktop`,
`~/.config/systemd/user/app-walker@autostart.service.d`, and
`/etc/pacman.d/hooks/walker-restart.hook` are all gone. The 4.0 tree references
the package nowhere. With `elephant` removed the binary has no providers left,
so it cannot act as a launcher even if run.

`walker`, `elephant*` and `omarchy-walker` are still published in the `omarchy`
pacman repo. That repo also serves Omarchy 3 machines on the same channels, so
their presence says nothing about 4.0 needing them.

Left installed for now, on the expectation that a 4.0.x release fixes the
removal list. No upstream issue tracked this as of 2026-08-16. If it never
lands, removal is clean -- nothing else comes with it:

```bash
pacman -Rs --print walker      # walker-2.17.0-1, and nothing else
sudo pacman -Rns walker
rm -rf ~/.config/walker.omarchy-upgrade-to-quattro.*.bak
```

### Confirmed as needing nothing

`envs.conf`, `xdph.conf`, `hyprsunset.conf`, `looknfeel.conf` and
`autostart.conf` held nothing personal, so none of them needed porting. Stock is
not the same as untouched, though: `hyprsunset.conf` being stock is exactly what
qualified it for the upgrader's `refresh` action, which replaced it.

Input-method settings live in `/etc/environment`, outside `~/.config`, so the
upgrade never touched them. One pre-existing wart shows up in the boot log
rather than the upgrade: that file is symlinked as
`/usr/lib/environment.d/99-environment.conf`, so it gets read by both `pam_env`
and systemd's `environment.d` generator. `pam_env` tolerates an `export ` prefix
and systemd does not, so any `export FOO=bar` line logs `invalid variable name`
twice per boot while still taking effect via `pam_env`. Dropping the `export `
prefix satisfies both parsers.

The upgrade also removes packages you chose yourself, which looks alarming in
`pacman.log` until you check where the functionality went. All of these were
verified fine on this machine:

| Removed | Why it is fine |
|---|---|
| `fcitx5-configtool` | The binary now ships inside `fcitx5` itself; `/usr/bin/fcitx5-configtool` still exists |
| `claude-code` | Moved from a pacman package to mise, per 4.0's npm -> mise switch. `mise list` shows it |
| `1password-beta` | Replaced by the `1password` stable package; the autostart entry's `/opt/1Password/1password` still resolves |
| `gnome-calculator`, `satty` | Replaced by Omacalc and Tensaku |

Two packages *look* like they were missed by the retired list but were not:
`opencode` and `ttf-jetbrains-mono-nerd` resolve to `opencode-bin` and
`ttf-jetbrains-mono-nerd-basic` through `provides`. The latter is exactly the
lighter font 4.0 wants. Check with `pacman -Qi <name> | grep '^Name'` before
concluding anything from a `pacman -Qq` match.

Also verified clean after the upgrade: no orphans (`pacman -Qdtq`), no failed
systemd units (system or user), empty `hyprctl configerrors`, `quickshell`
running against `/usr/share/omarchy/shell`, and `omarchy version channel` still
`stable`.

One thing to keep an eye on rather than fix: SDDM logs `gkr-pam: couldn't unlock
the login keyring` under autologin. That is inherent to having no password at
login, not something 4.0 introduced -- but 4.0 pins Chromium-based browsers to
the gnome-libsecret store, so if browser logins or `gh` auth start evaporating,
look here first.

### Space the upgrade leaves behind

```
~/.local/share/omarchy.omarchy-upgrade-to-quattro.*.bak    336 MB
~/.config/{waybar,swayosd,mako,walker,...}.*.bak           8 entries
~/.config/hypr/*.bak*                                      18 files
```

The 336 MB one is the Omarchy 3 git working tree. 4.0 gets everything from
packages, so nothing reads it. The `hypr/*.bak*` files are `omarchy refresh`
clutter and can go at any time; the four `.conf` files kept deliberately are in
`omarchy/omarchy3/`, not here.

## `/etc` is a new maintenance surface in 4.0

Omarchy 3 kept its system files outside pacman's control. 4.0 ships them from
`omarchy-settings`, so `/etc` now behaves like any other packaged config: where
the pre-package file differed from the packaged one, pacman wrote a `.pacnew`
and left the old version live. Eight appeared during this upgrade.

**Never run `pacdiff` or any batch pacnew merger on an Omarchy machine.**
`/etc/pacman.conf.pacnew` and `/etc/pacman.d/mirrorlist.pacnew` are the stock
Arch templates. Applying the mirrorlist one replaces
`https://stable-mirror.omarchy.org/` with 579 lines of commented-out Arch
mirrors and takes the machine off its Omarchy channel entirely. Go file by file:

```bash
find /etc -name '*.pacnew'
diff -u /etc/some/file /etc/some/file.pacnew
```

### The one that mattered: SDDM's greeter compositor

`/etc/sddm.conf.d/10-wayland.conf` was still pointing at the Omarchy 3 file:

```
CompositorCommand=start-hyprland -- --config /usr/share/sddm/hyprland.conf
```

`/usr/share/sddm/hyprland.conf` is a leftover that **no package owns**. 4.0
ships `/usr/share/sddm/hyprland.lua` from `omarchy-settings`, and its packaged
`10-wayland.conf` points there. The login screen kept working only because the
orphaned `.conf` was still on disk -- anything that cleaned it up would have
left the greeter with no compositor config and no way in.

Fixed by applying the pacnew. The diff was that single line, with nothing
personal to preserve:

```bash
cp -a /etc/sddm.conf.d/10-wayland.conf /etc/sddm.conf.d/10-wayland.conf.omarchy3.bak
mv /etc/sddm.conf.d/10-wayland.conf.pacnew /etc/sddm.conf.d/10-wayland.conf
```

`pacman -Qkk omarchy-settings` stops reporting the file once it matches the
package -- that confirms the edit, but only the next boot confirms the greeter.

### The rest of the pacnews

| File | Difference | Action |
|---|---|---|
| `sddm.conf.d/10-wayland.conf` | `.conf` -> `.lua` greeter config | **applied** |
| `sysctl.d/90-omarchy-file-watchers.conf` | added comments only | ignore |
| `systemd/resolved.conf.d/10-disable-multicast.conf` | identical content | delete the pacnew |
| `docker/daemon.json` | identical content | delete the pacnew |
| `conf.d/wireless-regdom` | ours sets `TW`, pacnew is the blank template | keep ours |
| `pacman.conf`, `pacman.d/mirrorlist` | stock Arch templates | **never apply** |
| `locale.gen`, tpm2-tss profiles x2 | ordinary Arch pacnews | handle as usual |

Two unowned Omarchy 3 files remain in `/etc/sddm.conf.d/` --
`99-omarchy-login.conf` (`RememberLastUser`) and `autologin.conf`. 4.0 does not
ship either, but `autologin.conf` is doing real work: SDDM logs confirm it
selects `/usr/local/share/wayland-sessions/omarchy.desktop`, which
`omarchy-settings` does ship. Leave them.

Privilege escalation note: 4.0 moved to pkexec/polkit and this machine has no
passwordless sudo, so system edits made from an agent need
`pkexec /bin/bash -c '...'`, which raises one themed polkit prompt for the whole
batch.

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
  edited it or because Omarchy changed its default -- only that it differs
  today.
- It only covers files Omarchy actually ships in `config/`. Retired files such
  as `hypridle.conf` have no baseline to compare against at all.

This is worth running across the whole tree, not just `hypr/`. Omarchy ships
41 config files; 11 of them differed from the defaults on this machine,
including `foot.ini`, `kitty.conf`, `tmux.conf` and `opencode.json`, which are
easy to forget about:

```bash
cd /usr/share/omarchy/config && \
  for f in $(find . \( -type f -o -type l \) | sed 's|^\./||'); do
    u="$HOME/.config/$f"
    [ -e "$u" ] || { echo "MISSING  $f"; continue; }
    cmp -s "$f" "$u" || echo "DIFFERS  $f"
  done
```

Read `DIFFERS` in both directions: a `-` line in the diff is a 4.0 default you
are *missing*, not just a value you overrode. That is how the absent ghostty
options above were found. Note that `shell.json` reports as differing purely
because the shell rewrites its key order, so compare that one by content.

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

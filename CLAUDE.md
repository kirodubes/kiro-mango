# kiro-mango — Claude project instructions

## Overview
Config package for the **Kiro mango edition** — the animated tiling member of the KIROTUX Wayland
line (sibling to [kiro-hyprland](../kiro-hyprland/CLAUDE.md)). Public, open-core, shipped via
`nemesis_repo`. mangowc is a dwl-lineage wlroots compositor; identity = smooth animations + blur.

## Edition spec (the WM-variable matrix)
- **Compositor:** **mangowm** (`mangowc`, github.com/DreamMaoMao/mangowc) — from **cachyos** (wired
  into Kiro's `pacman.conf`), **no build**. wlroots-0.19 + scenefx.
- **Config language:** runtime **`~/.config/mango/config.conf`** (`key=value` + `bind=MODS,key,action`).
  Reload live with `reload_config` (Super+Shift+R). NOT compile-time like dwl.
- **Desktop shell:** **waybar + mako + swaybg** from the shared `kiro-wayland-dotfiles` base. waybar
  uses `wlr/taskbar` (mango has no native waybar workspace module); ships only `config-mango.jsonc`.
- **Autostart:** unlike every other KIROTUX compositor, mango has **no in-config autostart
  mechanism** — `config.conf` has no exec directive at all. The startup script must be passed
  explicitly via `mango -s <command>` (confirmed via `mango --help`). Upstream `mangowm`'s own
  `/usr/share/wayland-sessions/mango.desktop` just does `Exec=mango` — no `-s` flag — so
  `~/.config/mango/autostart.sh` was **never actually invoked** (found live on picard 2026-07-01;
  no waybar/mako/nm-applet/variety/hypridle at all). Fixed by shipping this package's own session
  entry: `usr/bin/kiro-mango-session` (a wrapper script — `.desktop` `Exec=` is parsed as a literal
  argv, `$HOME`/`%h` are never expanded, so the wrapper is required, same pattern as
  `exec-ohmychadwm`/`kiro-dwl-session`) + `usr/share/wayland-sessions/kiro-mango.desktop`
  (`Name=Kiro Mango`, distinct from upstream's plain `Mango` entry — no file conflict).
- **Theming:** **pywal**. `set-theme.sh` rewrites waybar `colors.css`, mako, and mango's `config.conf`
  border colours (0xRRGGBBAA); mango borders apply on `reload_config` (no reliable CLI to trigger it).
- **Lock/idle:** hyprlock + hypridle (from the dotfiles base).
- **Identity:** the **animated** edition — `animations=1` + `blur=1`, dwm-style tags, multiple layouts
  (tile/scroller/grid/deck/monocle), an animated overview (Super+Tab).

## Keybindings
- SUPER grammar in mango's `bind=` syntax: CTRL+ALT launchers + SUPER+F1..F12 + `kiro-keybindings` on
  Super+Ctrl+S. Tags (`view`/`tag`/`tagsilent`), `focusdir`/`exchange_client`, `toggleoverview`.
- `keybindings.txt` mirrors `config.conf` (tag/dwm vocabulary). `kiro-keybindings`'s `WM_MAP`
  already includes `mango` (fixed 2026-07-01, along with the other five KIROTUX Wayland editions
  missing at the time).

## Patterns / gotchas
- **Colours are `0xRRGGBBAA`** in config.conf (not hex) — `set-theme.sh` converts.
- **No live IPC to reload mango** — `set-theme.sh` rewrites config.conf colours but can't trigger a
  reload; they apply on Super+Shift+R or next login. (Watch for an `mmsg`-style tool in future mango.)
- **`autostart.sh` must be executable AND must be launched via `kiro-mango-session`'s `mango -s`**
  — the file being executable is necessary but not sufficient; mango only runs it if told to.
- **Select "Kiro Mango" at the login screen, not plain "Mango"** — the latter is upstream
  `mangowm`'s own session entry and has no autostart wired up at all.
- Validated on a real mangowc boot (picard, real-metal, 2026-07-01) — this is where the missing
  autostart wiring was found. `config.conf` keys + bind syntax against the mango wiki still not
  independently re-verified.

## Build / delivery
- Public recipe `../KIROTUX-PKG-BUILD/kiro-mango/build.sh` → `~/EDU/nemesis_repo/`. After editing here:
  rebuild the package, then the ISO. See [../CLAUDE.md](../CLAUDE.md) for the delivery architecture.

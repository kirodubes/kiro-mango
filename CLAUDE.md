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
- **Autostart:** mango runs **`~/.config/mango/autostart.sh`** on start (must be executable).
- **Theming:** **pywal**. `set-theme.sh` rewrites waybar `colors.css`, mako, and mango's `config.conf`
  border colours (0xRRGGBBAA); mango borders apply on `reload_config` (no reliable CLI to trigger it).
- **Lock/idle:** hyprlock + hypridle (from the dotfiles base).
- **Identity:** the **animated** edition — `animations=1` + `blur=1`, dwm-style tags, multiple layouts
  (tile/scroller/grid/deck/monocle), an animated overview (Super+Tab).

## Keybindings
- SUPER grammar in mango's `bind=` syntax: CTRL+ALT launchers + SUPER+F1..F12 + `kiro-keybindings` on
  Super+Ctrl+S. Tags (`view`/`tag`/`tagsilent`), `focusdir`/`exchange_client`, `toggleoverview`.
- `keybindings.txt` mirrors `config.conf` (tag/dwm vocabulary). (`kiro-keybindings` /
  `/kiro-create-keybindings` need **mango** in their WM-detection table — known gap.)

## Patterns / gotchas
- **Colours are `0xRRGGBBAA`** in config.conf (not hex) — `set-theme.sh` converts.
- **No live IPC to reload mango** — `set-theme.sh` rewrites config.conf colours but can't trigger a
  reload; they apply on Super+Shift+R or next login. (Watch for an `mmsg`-style tool in future mango.)
- **`autostart.sh` must be executable** (mango runs it) — `cp -a` in `package()` preserves the bit.
- Config **not yet validated on a real mangowc boot** — confirm `config.conf` keys + bind syntax
  against the mango wiki before the first ISO test.

## Build / delivery
- Public recipe `../KIROTUX-PKG-BUILD/kiro-mango/build.sh` → `~/EDU/nemesis_repo/`. After editing here:
  rebuild the package, then the ISO. See [../CLAUDE.md](../CLAUDE.md) for the delivery architecture.

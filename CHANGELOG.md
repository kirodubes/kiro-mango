# Changelog

All notable changes to **kiro-mango** are documented here.
Format: one dated entry per day (`YYYY.MM.DD`), newest first.

## 2026.06.30

### What Changed
- **Initial config package** for the Kiro mango edition — the **animated tiling** member of the
  KIROTUX Wayland line. mangowc is a dwl-lineage wlroots compositor whose identity is smooth
  animations + blur, with a clean runtime config file.
- Built on the shared `kiro-wayland-dotfiles` base (mako, hyprlock/hypridle, waybar style/colors);
  ships only its `mango/` config + `waybar/config-mango.jsonc`.
- **pywal theming** including mango's borders — `set-theme.sh` fans the palette to waybar, mako, and
  the `config.conf` colour lines.

### Technical Details
- `etc/skel/.config/mango/config.conf` — mango's `key=value` + `bind=MODS,key,action` runtime config.
  Animations + blur on (the edition's identity), Tokyo Night, `be,us` + compose:caps. Kiro SUPER
  grammar on mango's dwm/tag model: app launchers (CTRL+ALT + SUPER+F1..F12), `view`/`tag`/`tagsilent`
  for the 9 tags, `focusdir`/`exchange_client`, `toggleoverview` (Super+Tab), `kiro-keybindings` on
  Super+Ctrl+S. Reload with Super+Shift+R.
- `autostart.sh` (executable, mango runs it) launches `env GTK_A11Y=none waybar -c config-mango.jsonc`,
  mako, swaybg, hypridle, polkit, nm-applet, set-theme.
- waybar uses `wlr/taskbar` (mango has no native waybar workspace module); the bar style.css/colors.css
  come from `kiro-wayland-dotfiles`.
- Compositor `mangowm` resolves from **cachyos** — **nothing built into `nemesis_repo`**.

### Files
- `etc/skel/.config/mango/{config.conf,autostart.sh,keybindings.txt,bg/kiro.jpg,scripts/{set-theme.sh,import-gsettings.sh}}`
- `etc/skel/.config/waybar/config-mango.jsonc`
- `README.md`, `CLAUDE.md`, `up.sh`, `setup.sh`, `.gitignore`, `kiro.jpg`

### Not yet verified
- The mango config is **not validated on a real mangowc boot** (not installed on the build box) —
  confirm `config.conf` keys (`xkb_rules_options`, `tagsilent`, `bind=`/`mousebind=` syntax) against
  the mango wiki and a real session. mango auto-runs `~/.config/mango/autostart.sh` — verify the path.
- `kiro-keybindings` / `/kiro-create-keybindings` need **mango** added to their WM-detection table.

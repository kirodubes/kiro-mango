# Changelog

All notable changes to **kiro-mango** are documented here.
Format: one dated entry per day (`YYYY.MM.DD`), newest first.

## 2026.07.03

### What Changed
- **Hid upstream mangowm's plain "Mango" session so it can't be picked by mistake.** Debugging
  picard live (real metal): black screen with cursor, keybindings working, no waybar and no
  wallpaper. Root cause was **the wrong session entry**: two mango entries appear in the greeter —
  our "Kiro Mango" (`kiro-mango-session` → `mango -s autostart.sh`) and upstream mangowm's plain
  "Mango" (`Exec=mango`, no autostart). Booting the plain one starts mango with no autostart, so
  `config.conf` loads (keybinds work) but `autostart.sh` never runs (no waybar/wallpaper). Now only
  "Kiro Mango" is selectable.

### Technical Details
- `/usr/share/wayland-sessions/mango.desktop` is owned by the `mangowm` package (a hard dependency),
  so it can't be deleted — pacman restores it on every mangowm upgrade. Instead we stamp
  `NoDisplay=true` onto it (greeters filter those out):
  - `usr/bin/kiro-mango-hide-upstream-session` — idempotent `sh` helper that appends `NoDisplay=true`
    if absent.
  - `usr/share/libalpm/hooks/kiro-mango-hide-upstream-session.hook` — PostTransaction hook triggered
    on the upstream `mango.desktop` path; re-applies after every mangowm install/upgrade so it can't
    regress.
  - `kiro-mango.install` — `post_install`/`post_upgrade` run the helper directly (the hook does not
    fire when mangowm is already installed, i.e. not part of the transaction); `post_remove` strips
    the `NoDisplay=true` line back out (our helper is gone by then, so it's done inline).
  - All paths idempotent (grep guard), so the hook + scriptlet running in the same transaction can't
    double-append.
- Corrected the stale `config.conf` header comment that claimed "mango runs it on start" — mango has
  no in-config autostart; the `kiro-mango-session` wrapper passes it via `mango -s`.

### Files Modified
- [usr/bin/kiro-mango-hide-upstream-session](usr/bin/kiro-mango-hide-upstream-session) (new)
- [usr/share/libalpm/hooks/kiro-mango-hide-upstream-session.hook](usr/share/libalpm/hooks/kiro-mango-hide-upstream-session.hook) (new)
- [etc/skel/.config/mango/config.conf](etc/skel/.config/mango/config.conf)
- [../KIROTUX-PKG-BUILD/kiro-mango/kiro-mango.install](../KIROTUX-PKG-BUILD/kiro-mango/kiro-mango.install) (new)
- [../KIROTUX-PKG-BUILD/kiro-mango/PKGBUILD](../KIROTUX-PKG-BUILD/kiro-mango/PKGBUILD)

## 2026.07.02

### What Changed
- **Moved `/etc/dconf/profile/user` + `/etc/dconf/db/local.d/00-kiro.conf` to
  `kiro-wayland-dotfiles`.** All 9 Kiro Wayland editions had shipped identical copies of these
  files, which conflicted in pacman whenever two editions were installed on the same machine.
  Settings unchanged — now owned once in the shared package (already a dependency here).

### Files Modified
- `etc/dconf/` (removed, moved to `kiro-wayland-dotfiles`)

## 2026.07.01

### What Changed
- **Added Variety wallpaper-rotator autostart + keybinds.** `variety` (configured by
  `kiro-variety-config`) now autostarts alongside the existing static `swaybg` wallpaper. Ported
  the ohmychadwm `keybindings.txt` scheme (alt+N/P/T/F/arrows/Up/Down/W): next/previous/trash/
  favorite/pause/resume/selector, plus alt+shift+N/P/T/F/U combos that also trigger this edition's
  `set-theme.sh` pywal recolor (waybar/mako/mango border colours). `variety` +
  `kiro-variety-config` added to `depends=()`.

### Technical Details
- Verified no existing bare-Alt binds collided with alt+n/p/t/f/w/arrows before adding — `super+N`
  is already used for "switch layout" but that's a different modifier chord from bare `alt+N`.
- Per this edition's known limitation (no live IPC reload), mango's own border colours from the
  recolor combos still only apply on Super+Shift+R or next login — same caveat as `set-theme.sh`
  always carried; waybar/mako still reload live via the existing SIGUSR2/makoctl signals.
- **Fixed autostart.sh never actually running.** Found live on picard: no waybar, mako, nm-applet,
  variety, or hypridle at all after login. Root cause — unlike every other KIROTUX compositor,
  mango has no in-config exec mechanism; the startup script must be passed via `mango -s
  <command>` (confirmed via `mango --help`), and upstream `mangowm`'s own `.desktop` session entry
  just does `Exec=mango` with no `-s` flag. Fixed by shipping this package's own session entry:
  `usr/bin/kiro-mango-session` (a wrapper — `.desktop` `Exec=` is parsed as a literal argv, so
  `$HOME` is never expanded, same pattern as `exec-ohmychadwm`/`kiro-dwl-session`) +
  `usr/share/wayland-sessions/kiro-mango.desktop` (`Name=Kiro Mango`, distinct from upstream's
  plain `Mango` entry to avoid a file-ownership conflict).

### Files Modified
- [etc/skel/.config/mango/config.conf](etc/skel/.config/mango/config.conf)
- [etc/skel/.config/mango/autostart.sh](etc/skel/.config/mango/autostart.sh)
- [etc/skel/.config/mango/keybindings.txt](etc/skel/.config/mango/keybindings.txt)
- [usr/bin/kiro-mango-session](usr/bin/kiro-mango-session) (new)
- [usr/share/wayland-sessions/kiro-mango.desktop](usr/share/wayland-sessions/kiro-mango.desktop) (new)
- [CLAUDE.md](CLAUDE.md)
- [../KIROTUX-PKG-BUILD/kiro-mango/PKGBUILD](../KIROTUX-PKG-BUILD/kiro-mango/PKGBUILD)

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

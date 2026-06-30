# kiro-mango

The **animated tiling edition** of Kiro — mangowc, a smooth-animated wlroots compositor in the Kiro
Wayland line (sibling to [kiro-hyprland](https://github.com/kirodubes/kiro-hyprland)).

## What it is

A configuration package: the source-of-truth config tree for Kiro's mango edition. mangowc is a
dwl-lineage **wlroots** compositor whose differentiator is **smooth animations + blur** with a clean
**runtime config file** (`~/.config/mango/config.conf`) — dwm-style tags and master/stack/scroller/
dwindle layouts, animated. It ships the same **waybar + mako + swaybg** shell as the rest of the line
(via `kiro-wayland-dotfiles`), so the look matches; only the compositor config and keybind vocabulary
differ.

## What it ships

- `~/.config/mango/config.conf` — the runtime config: animations + blur on, Tokyo Night, Kiro SUPER
  keybinds (CTRL+ALT launchers, SUPER+F1..F12), dwm-style tags.
- `~/.config/mango/autostart.sh` — the session entrypoint (mango runs it on start).
- `~/.config/mango/scripts/` — `set-theme.sh` (pywal), `import-gsettings.sh`; `keybindings.txt`; `bg/kiro.jpg`.
- `~/.config/waybar/config-mango.jsonc` — the bar config (style/colors come from `kiro-wayland-dotfiles`).

## Theming — pywal

One wallpaper drives every colour. `set-theme.sh` runs pywal at login and fans the palette out to
waybar, mako, and mango's border colours in `config.conf`. Reload mango's borders with **Super+Shift+R**.

## How to install

```sh
sudo pacman -S kiro-mango
```

`kiro-mango` depends on `mangowm` (from cachyos) + the shared `kiro-wayland-dotfiles` base + the waybar
stack. Pick **mango** at the greeter. Workspaces are **tags** (Super+1..9); press **Super+Tab** for the
animated overview, **Super+Ctrl+S** for the keybindings cheat sheet.

A pristine copy of the config is kept at `/usr/share/kiro/kiro-mango/`.

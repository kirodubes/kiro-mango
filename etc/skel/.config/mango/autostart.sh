#!/bin/sh
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
# Purpose:
#   Session autostart for the Kiro mango edition. mangowc runs this script
#   (~/.config/mango/autostart.sh) on startup — the single session entrypoint.
# Why:
#   mango has no in-config exec lines; everything is launched from here.
#####################################################################

# Authentication agent + environment for portals/screensharing.
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dbus-update-activation-environment --systemd --all
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# Create XDG user dirs on first login.
xdg-user-dirs-update &

# Mirror GTK theme/icons/cursor/font into gsettings for GTK4/libadwaita apps.
"$HOME/.config/mango/scripts/import-gsettings.sh" &

# Wallpaper + pywal theming (palette -> waybar/mako/mango borders).
swaybg -m fill -i "$HOME/.config/mango/bg/kiro.jpg" &
"$HOME/.config/mango/scripts/set-theme.sh" &

# Bar (GTK_A11Y=none avoids the ~25s at-spi login stall), notifications,
# idle-lock daemon, network applet.
env GTK_A11Y=none waybar -c "$HOME/.config/waybar/config-mango.jsonc" &
mako &
hypridle &
nm-applet --indicator &

# Live ISO only: auto-launch the installer. kiro_final strips this line on install.
sh -c '[ -d /run/archiso/bootmnt ] && calamares_polkit -d -style kvantum' &

#!/bin/sh

config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
[ ! -f "$config" ] && exit 1

gtk_theme="$(grep     'gtk-theme-name'        "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
icon_theme="$(grep    'gtk-icon-theme-name'   "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
font_name="$(grep     'gtk-font-name'         "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
cursor_theme="$(grep  'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
prefer_dark="$(grep 'gtk-application-prefer-dark-theme' "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
deco_layout="$(grep 'gtk-decoration-layout'             "$config" | sed 's/.*\s*=\s*//' | head -n 1)"

gsettings set org.gnome.desktop.interface gtk-theme     "$gtk_theme"
gsettings set org.gnome.desktop.interface icon-theme    "$icon_theme"
gsettings set org.gnome.desktop.interface font-name     "$font_name"
gsettings set org.gnome.desktop.interface cursor-theme  "$cursor_theme"
[ $prefer_dark -eq 1 ] && gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.wm.preferences button-layout "$deco_layout"

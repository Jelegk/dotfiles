#!/bin/sh

config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
if [ ! -f "$config" ]; then exit 1; fi

gnome_schema=""
gtk_theme="$(grep    'gtk-theme-name'        "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
icon_theme="$(grep   'gtk-icon-theme-name'   "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
font_name="$(grep    'gtk-font-name'         "$config" | sed 's/.*\s*=\s*//' | head -n 1)"
echo "gtk-theme    = '$gtk_theme'"
echo "icon-theme   = '$icon_theme'"
echo "cursor-theme = '$cursor_theme'"
echo "font-name    = '$font_name'"

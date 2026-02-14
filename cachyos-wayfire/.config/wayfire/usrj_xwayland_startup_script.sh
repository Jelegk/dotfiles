#!/bin/sh

# Update Xresources style.
if [ -r "${HOME}/.Xresources" ] && command -v xrdb >/dev/null 2>&1; then
  xrdb -merge "${HOME}/.Xresources"
fi

# Log that a X client opened.
DATE=$(date '+%F %T')
command -v xlsclients >/dev/null 2>&1 && XCLIENTS=$(xlsclients -a) # (requires xorg-xlsclients package)
echo "$DATE  $XCLIENTS" >> "${HOME}/.config/wayfire/xwayland_usages.log"

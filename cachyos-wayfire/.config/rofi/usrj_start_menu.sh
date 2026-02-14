#!/bin/sh

(rofi -show drun -config ~/.config/rofi/win10-searchbar-config.rasi; kill $$) & # FIXME: Doesn't kill the parent.
trap "kill -- $!" EXIT # Kill child if process dies.

selection=$(printf "\n\n\n" | rofi -dmenu -format i -config "~/.config/rofi/win10-startmenu-config.rasi")

kill -- -$$ # Kill all children. # FIXME: Doesn't kill the child.

case $selection in
  0) pcmanfm ~/Documents ;;
  1) pcmanfm ~/Pictures ;;
  2) foot ~/.local/bin/usrj_settuings ;;
  3) ~/.config/waybar/usrj_power_menu.sh ;;
esac

# TODO: don't close $$ on usrj_power_menu.sh: open akin to a "sub-menu".

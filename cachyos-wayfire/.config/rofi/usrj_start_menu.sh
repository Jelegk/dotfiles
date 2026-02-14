#!/bin/sh

trap "kill -- -$$" EXIT # Kill all children if process dies.

(rofi -show drun -config ~/.config/rofi/win10-searchbar-config.rasi; kill $$) &
child_pid=$!

selection=$(printf "\n\n\n" | rofi -dmenu -format i -config "~/.config/rofi/win10-startmenu-config.rasi")

kill -- $child_pid # FIXME: why won't it kill the child?

case $selection in
  0) pcmanfm ~/Documents ;;
  1) pcmanfm ~/Pictures ;;
  2) foot ~/.local/bin/usrj_settuings ;;
  3) ~/.config/waybar/usrj_power_menu.sh ;;
esac

# TODO: don't close $$ on usrj_power_menu.sh: open akin to a "sub-menu".

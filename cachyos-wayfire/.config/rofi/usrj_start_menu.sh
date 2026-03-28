#!/bin/sh

entries=(
  ""
  ""
  ""
  ""
)

tmp=$(mktemp)

printf "%s\n" "${entries[@]}" | rofi -dmenu -format i -config "~/.config/rofi/win10-startmenu-config.rasi" > $tmp &

trap "(kill $!; rm $tmp) 2>/dev/null" EXIT
wait

case $(cat $tmp) in
  0) setsid pcmanfm ~/Documents & ;;
  1) setsid pcmanfm ~/Pictures & ;;
  2) setsid gtk-launch settuings & ;;
  3) setsid ~/.config/rofi/usrj_power_menu.sh ;;
esac

rm $tmp

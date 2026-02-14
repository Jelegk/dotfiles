#!/bin/sh

entries=(
  "    Sleep"
  "    Hibernate"
  "    Shut down"
  "    Restart"
)

printf -v dmenu_msg "%s\n" "${entries[@]}"
selection=$(printf "$dmenu_msg" | rofi -dmenu -format i -config "~/.config/rofi/win10-powermenu-config.rasi")

case $selection in
  0) systemctl suspend ;;
  1) systemctl hibernate ;;
  2) usrj_toggle_monitor; systemctl poweroff ;;
  3) usrj_toggle_monitor; systemctl reboot ;;
esac

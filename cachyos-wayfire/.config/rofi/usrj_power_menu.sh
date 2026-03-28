 #!/bin/sh

entries=(
  "    Sleep"
  "    Hibernate"
  "    Shut down"
  "    Restart"
)

tmp=$(mktemp)

printf "%s\n" "${entries[@]}" | rofi -dmenu -format i -config "~/.config/rofi/win10-powermenu-config.rasi" > $tmp &

trap "(kill $!; rm $tmp) 2>/dev/null" EXIT
wait

case $(cat $tmp) in
  0) systemctl suspend & ;;
  1) systemctl hibernate & ;;
  2) usrj_toggle_monitor; systemctl poweroff & ;;
  3) usrj_toggle_monitor; systemctl reboot & ;;
esac

rm $tmp

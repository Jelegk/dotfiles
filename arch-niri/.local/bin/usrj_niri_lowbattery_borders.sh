NIRI_CONFIG="$XDG_CONFIG_HOME/niri/config.kdl"

# There HAS to be a cleaner way with sed/awk/perl/regex/bash substitution, but i can't bother to invest more time on this.

while :
do
  if [ $(cat /sys/class/power_supply/BAT0/capacity) -le 10 ]; then
    sed -i 's/ border { \/\/ Regular/ \/-border { \/\/ Regular/' $NIRI_CONFIG 
    sed -i 's/ \/-border { \/\/ Low Battery (gets toggled by script, dont erase)/ border { \/\/ Low Battery (gets toggled by script, dont erase)/' $NIRI_CONFIG
  else
    sed -i 's/ \/-border { \/\/ Regular/ border { \/\/ Regular/' $NIRI_CONFIG
    sed -i 's/ border { \/\/ Low Battery (gets toggled by script, dont erase)/ \/-border { \/\/ Low Battery (gets toggled by script, dont erase)/' $NIRI_CONFIG
  fi
  sleep 60
done



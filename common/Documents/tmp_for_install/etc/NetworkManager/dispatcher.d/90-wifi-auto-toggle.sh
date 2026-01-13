#!/bin/sh

# ETHERNET_INTERFACE="<Your Ethernet Interface>" # TODO

# if [ "$1" = "$ETHERNET_INTERFACE" ]; then
#   case "$2" in
#     up)
#       echo "$0: ethernet up -> wifi down"
#       nmcli radio wifi off
#       ;;
#     down)
#       echo "$0: ethernet down -> wifi up"
#       nmcli radio wifi on
#       ;;
#   esac
# elif [ "$(nmcli -g GENERAL.STATE device show $ETHERNET_INTERFACE)" = "20 (unavailable)" ]; then
#   echo "$0: ethernet unavailable -> wifi up"
#   nmcli radio wifi on
# fi

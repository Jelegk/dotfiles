export TERMINAL=urxvt
# Autostart X at login
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    exec startx
fi

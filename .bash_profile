export TERMINAL=urxvt
export MOZ_USE_XINPUT2=1
# Autostart X at login
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    exec startx
fi

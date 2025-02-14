export TERMINAL=urxvt
export MOZ_USE_XINPUT2=1
export QT_QPA_PLATFORMTHEME="gtk3"
# Autostart X at login
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    exec startx
fi

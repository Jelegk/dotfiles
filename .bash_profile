export TERMINAL=urxvt
export GTK_THEME=OneStepBack
# Autostart X at login
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    exec startx
fi

#Environment variables:
export TERMINAL=urxvt
export MOZ_USE_XINPUT2=1
export QT_QPA_PLATFORMTHEME="gtk3"
export HISTIGNORE='history:ani-cli:clear:pwd:ls*:tree*:trewq:exit'

# Autostart X at login
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    exec startx
fi

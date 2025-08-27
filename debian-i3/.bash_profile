#Environment variables:
export TERMINAL=urxvt
export MOZ_USE_XINPUT2=1
export QT_QPA_PLATFORMTHEME="gtk3"
export HISTIGNORE='history:ani-cli:clear:pwd:ls *:tree *:trewq:make *:exit'
export PATH="$PATH:.cargo/bin:/opt:/opt/furnace:/opt/JDSP4Linux/build/src:/opt/SimulIDE_0.3.12-SR8-INF1900.3/bin:/opt/snes9x:/opt/yabridge:/usr/local/go/bin:~/.local/share/file-manager/actions"
unset WINEESYNC # Kiloheart VST patch ( https://github.com/robbert-vdh/yabridge?tab=readme-ov-file#known-issues-and-fixes )

# Autostart X at login
if [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    exec startx
fi
. "$HOME/.cargo/env"

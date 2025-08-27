[[ -f ~/.bashrc ]] && . ~/.bashrc

export MOZ_USE_XINPUT2=1
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME="gtk3"
export HISTIGNORE='history:ani-cli:clear:pwd:ls *:tree *:trewq:make *:exit'
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
export PATH=$PATH:~/.local/bin
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
unset WINEESYNC # Kiloheart VST patch ( https://github.com/robbert-vdh/yabridge?tab=readme-ov-file#known-issues-and-fixes )

# Start niri after tty login
# [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] && exec niri-session



[[ -f ~/.bashrc ]] && . ~/.bashrc

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"
[ -s "$HOME/.config/user-dirs.dirs" ] && . "$HOME/.config/user-dirs.dirs" # TODO: does it export them?

XCURSOR_THEME="Tumi's 3D Crystal" # FIXME
XCURSOR_PATH=${XCURSOR_PATH}:/usr/share/icons:~/.local/share/icons

export XDG_SESSION_TYPE=wayland
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME="gtk3"
# export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export ELECTRON_OZONE_PLATFORM_HINT=auto
export OZONE_PLATFORM_HINT=wayland

export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1

export HISTIGNORE='history:ani-cli:clear:pwd:ls *:tree *:trewq:make *:exit'
export PATH=$PATH:~/.local/bin:/opt
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
unset WINEESYNC # Kiloheart VST patch ( https://github.com/robbert-vdh/yabridge?tab=readme-ov-file#known-issues-and-fixes )
export VCPKG_ROOT="$HOME/.local/share/vcpkg"

# Start niri after tty login
[ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] && exec niri-session -l

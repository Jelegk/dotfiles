# https://askubuntu.com/a/1171439

touchpad=$(xinput list | grep Touchpad | grep -o id=.. | cut -d '=' -f 2)

case "$1" in
  'normal')
    xrandr --output eDP-1 --rotate normal
    xinput set-prop "$touchpad" --type=float "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
    ;;
  'inverted')
    xrandr --output eDP-1 --rotate inverted
    xinput set-prop "$touchpad" --type=float "Coordinate Transformation Matrix" -1 0 0 0 -1 0 0 0 1
    ;;
  'left')
    xrandr --output eDP-1 --rotate left
    xinput set-prop "$touchpad" --type=float "Coordinate Transformation Matrix" 0 -1 0 1 0 0 0 0 1
    ;;
  'right')
    xrandr --output eDP-1 --rotate right
    xinput set-prop "$touchpad" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 0 0 0 1
    ;;
esac

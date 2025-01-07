checklock() {
    sleep 60
    i3lockactive=$(pgrep --exact --count i3lock)
    if [ "i3lockactive" -gt "0" ]; then
        # Suspend screen & computer
        xset dpms force suspend && systemctl suspend && checklock
    fi
}
# Turn on windows crossfade
xcompmgr -fF &
# check each minutes for inactivity, if so return to suspend mode
checklock &
# Lock screen 9note: keep bar-step value high enough to negate the pixelated "pyramid" from appearing)
i3lock -n -i ~/.config/wallpapers/copland_os_blue.png -F -e \
        --bar-indicator --greeter-text="Type to unlock" --greeter-pos="x+20:h-30" \
        --greeter-color=212121ff --greeter-font=D050000L --greeter-align=1 --greeter-size=24 \
        --bar-color=00000000 --ringver-color=096b33ff --ringwrong-color=6b0b10ff --bar-step=20 \
        --bar-pos="x+0:h" --bar-total-width=w --bar-base-width=8 --bar-max-height=12 --bar-count=20 \
        --bar-direction=1 --verif-text="" --wrong-text="" --noinput-text="" --no-modkey-text --pass-media-keys &&
#        --inside-color=00000000 --ring-color=bababaff --line-uses-inside \
#        --keyhl-color=5c5d66ff --bshl-color=571b21ff --separator-color=00000000 \
#        --insidever-color=096b33ff --insidewrong-color=6b0b10ff \
#        --ringver-color=ffffffff --ringwrong-color=ffffffff --ind-pos="x+70:h-60" \
#        --radius=20 --verif-text="" --wrong-text="" --noinput-text="" --pass-media-keys
# Turn off crossfade on homescreen
sleep 1 && pkill xcompmgr
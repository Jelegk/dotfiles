# Terminate already running bar instances
pkill '^polybar$'

polybar top 2>&1 | tee -a /tmp/polybar_top_bar.log & disown
polybar bottom 2>&1 | tee -a /tmp/polybar_bottom_bar.log & disown
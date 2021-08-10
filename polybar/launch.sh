#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -rq music &
polybar -rq tray &
polybar -rq i3 &

desktop=$(echo $DESKTOP_SESSION)
count=$(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l)


case $desktop in

    i3|/usr/share/xsessions/i3)
    if type "xrandr"; then
        for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
            MONITOR=$m polybar --reload example &
            MONITOR=$m polybar -rq music &
            MONITOR=$m polybar -rq tray &
            MONITOR=$m polybar -rq i3 &
        done
    else
        polybar --reload example &
        polybar -rq music &
        polybar -rq tray &
        polybar -rq i3 &
    fi
    # second polybar at bottom
    # if type "xrandr" > /dev/null; then
    #   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    #     MONITOR=$m polybar --reload mainbar-i3-extra -c ~/.config/polybar/config &
    #   done
    # else
    # polybar --reload mainbar-i3-extra -c ~/.config/polybar/config &
    # fi
    ;;
esac

echo "Polybar launched..."

#!/usr/bin/env sh

killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 1; done
polybar topbar -c ~/.config/polybar/config.ini &
polybar botbar -c ~/.config/polybar/config.ini &
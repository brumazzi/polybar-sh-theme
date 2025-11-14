#!/bin/sh

source ~/.config/polybar/modules/color.sh

TEMP=$(sensors | grep Tctl | grep -E -o "[0-9]{1,3}.[0-9]{1}" | head -1)
ICON=""

IFS='.'
info=($TEMP)

color=''
if [ "${info[0]}" -ge 40 ] && [ "${info[0]}" -le 80 ]; then
	color=$YELLOW
elif [ "${info[0]}" -gt 80 ]; then
	color=$RED
else
	color=$GREEN
fi

printf "$ICON: $color$TEMP°"

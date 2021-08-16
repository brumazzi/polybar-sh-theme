#!/bin/sh

BTN=0

source ~/.config/polybar/modules/color.sh

function update_weather {
	if [ "$(cat /tmp/WEATHER.tmp)" -eq "1" ]; then return 1; fi
	printf 1 > /tmp/WEATHER.tmp
	while [ "$(cat /tmp/WEATHER.tmp)" ]; do
		WEATHER_INFO="$(curl http://wttr.in/Palhoca?format=1)"
		printf "$WEATHER_INFO" > /tmp/WEATHER_INFO.tmp
		sleep 1300
	done
	
}
update_weather &

[[ "$2" ]] && BTN=$2

if [ "$BTN" -eq 1 ]; then
	(zenity --calendar) &
fi

HOUR=$(date '+%H')
SYMB=""
CLOCK_LIST_00="🕛;🕐;🕑;🕒;🕓;🕔;🕕;🕖;🕗;🕘;🕙;🕚"
CLOCK_LIST_30="🕧;🕜;🕝;🕞;🕟;🕠;🕡;🕢;🕣;🕤;🕥;🕦"
IFS=';'
CLOCKS00=($CLOCK_LIST_00)
CLOCKS30=($CLOCK_LIST_30)

let H="$HOUR % 12"
M=$(date '+%M')
if [ "$M" -le 30 ]; then
	CLOCK="${CLOCKS00[$H]}"
else
	CLOCK="${CLOCKS30[$H]}"
fi

WEAT="$(cat /tmp/WEATHER_INFO.tmp)"

CALENDAR="\U1f4c5"
TCELL[0]=$(echo $WEAT | grep -E -o '[0-9]{1,3}' | head -1)
TCELL[1]=$(echo $WEAT | grep -E -o '[0-9]{1,3}' | tail -n 1)

CELL="$([[ "${TCELL[0]}" -eq "${TCELL[1]}" ]] && echo "${TCELL[0]}" || echo "${TCELL[0]} - ${TCELL[1]}") °C"

echo -e "$CALENDAR $(date '+%a %d %b') $CLOCK $(date '+%H:%M') $WEAT"

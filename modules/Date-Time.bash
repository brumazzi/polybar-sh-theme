#!/bin/bash

source ~/.config/polybar/modules/color.sh

CLOCK_ICON="🕛🕧:🕐🕜:🕑🕝:🕒🕞:🕓🕟:🕔🕠:🕕🕡:🕖🕢:🕗🕣:🕘🕤:🕙🕥:🕚🕦"
CALENDAR_ICON=""
WEEK_DAY="$(date '+%a')"
DATE="$(date '+%d %b')"
HOUR="$(date '+%R')"

# Define current clock icon
current_hour="$(date +%k)" # get hour in 0..24
let current_hour="$current_hour%12"
current_minute="$(date +%M)"
current_minute="${current_minute#0}"
minute_ge_30="0"
[[ "$current_minute" -ge 30 ]] && minute_ge_30="1"

let icon_index="$current_hour + 1"
current_clock="$(echo $CLOCK_ICON | awk -F: "{print \$$icon_index}")"
current_clock="${current_clock:$minute_ge_30:1}"

# Set week day color blue or red
if [ "$(date +%u)" -ge 6 ]; then
	WEEK_DAY="${RED}${WEEK_DAY}${NO_F_COLOR}"
fi

# Add weather if exists
weather="$(shmm WTTR -r)"
source ~/.config/polybar/modules/Weather-Icons.bash

if [ "$(echo $weather | wc -c)" -gt 15 ]; then
	temperature="$(echo $weather | awk -F: '{print $2}')"
	humidity="$(echo $weather | awk -F: '{print $3}')"
	weather_code="$(echo $weather | awk -F: '{print $4}')"
	visibility="$(echo $weather | awk -F: '{print $5}')"

	weather="  $(weather-icon $weather_code)  ${ICON_TEMPERATURE}${temperature}°"
else
	weather=""
fi

# Print hour
printf "$CALENDAR_ICON $WEEK_DAY $DATE $current_clock $HOUR${weather}"

#!/bin/bash

source ~/.config/polybar/modules/Color.bash
source ~/.config/polybar/modules/Weather-Icons.bash

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
weather="$(shmm i3-Weather -r)"

if [ "$weather" ]; then
	temperature="$(echo $weather | awk -F: '{print $2}')"
	is_day="$(echo $weather | awk -F: '{print $3}')"
	icon="$(echo $weather | awk -F: '{print $4}')"
	weather_code="$(echo $weather | awk -F: '{print $5}')"
	wind_kph="$(echo $weather | awk -F: '{print $6}')"
	wind_dir="$(echo $weather | awk -F: '{print $7}')"
	humidity="$(echo $weather | awk -F: '{print $8}')"
	cloud="$(echo $weather | awk -F: '{print $9}')"
	uv="$(echo $weather | awk -F: '{print $10}')"

	weather="  $(weather-icon $weather_code)  ${ICON_TEMPERATURE}${temperature}°"
fi

# Print hour
printf "$CALENDAR_ICON $WEEK_DAY $DATE $current_clock $HOUR${weather}"

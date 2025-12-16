#!/bin/bash

source ~/.config/polybar/modules/Color.bash
source ~/.config/polybar/modules/Weather-Icons.bash

CLOCK_ICON=(🕛🕧 🕐🕜 🕑🕝 🕒🕞 🕓🕟 🕔🕠 🕕🕡 🕖🕢 🕗🕣 🕘🕤 🕙🕥 🕚🕦)
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

current_clock=${CLOCK_ICON[$current_hour]}
current_clock="${current_clock:$minute_ge_30:1}"

# Set week day color blue or red
if [ "$(date +%u)" -ge 6 ]; then
	WEEK_DAY="${RED}${WEEK_DAY}${NO_F_COLOR}"
fi

# Add weather if exists
IFS=':' read -a weather <<< $(shmm i3-Weather -r)

if [ "$weather" ]; then
	temperature="${weather[1]}"
	is_day="${weather[2]}"
	icon="${weather[3]}"
	weather_code="${weather[4]}"
	wind_kph="${weather[5]}"
	wind_dir="${weather[6]}"
	humidity="${weather[7]}"
	cloud="${weather[8]}"
	uv="${weather[9]}"

	weather="  $(weather-icon $weather_code)  ${ICON_TEMPERATURE}${temperature}°"
fi

# Print hour
printf "$CALENDAR_ICON $WEEK_DAY $DATE $current_clock $HOUR${weather}"

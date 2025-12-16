#!/bin/bash

# Weather params
# lastUpdate:temp_c:is_day:condition.icon:condition.code:wind_kph:wind_dir:humidity:cloud:uv

UPDATE_DELAY=30

current_time="$(date '+%Y%m%d%H%M')"

function update {
	local WEATHER_URL="http://api.weatherapi.com/v1/current.json?key=$WEATHER_API_KEY&q=$WEATHER_API_REGION&aqi=no"
	local COLLECT_VARS=" temp_c, is_day, condition.icon, condition.code, wind_kph, wind_dir, humidity, cloud, uv"
	local fields="${COLLECT_VARS// /.current.}"

	local json="$(curl -s --max-time 5 "$WEATHER_URL")"

	if [ "$json" ]; then
		mapfile -t data <<< $(jq "$fields" <<< $json)
		data="${data[@]}"

		shmm i3-Weather -w "$current_time:${data// /:}"
	fi
}

if [ "$(shmm i3-Weather -p)" ]; then
	weather_data="$(shmm i3-Weather -r)"
	[[ "$weather_data" ]] || weather_data=0

	let last_update="$current_time - ${weather_data::12}"
	if [ "$last_update" -gt 30 ]; then
		update
	fi
else
	update
fi

echo ""

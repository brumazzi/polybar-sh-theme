#!/bin/bash

# Weather params
# lastUpdate:temp_C:humidity:weatherCode:visibility

JSON_READER_PATH="$HOME/.config/polybar/modules/json-reader.py"
UPDATE_DELAY=30

function update-weather {
	json="$(https://wttr.in/Palho%C3%A7a?format=j1)"
	wttr_data="$(echo $json | python json-reader.py current_condition.0.temp_C current_condition.0.humidity current_condition.0.weatherCode current_condition.0.visibility)"

	shmm WTTR -r "${current_time}:${wttr_data}"
}

[[ ! -f "$JSON_READER_PATH" ]] && echo $JSON_READER_PATH not exists && exit 1

current_time="$(date '+%Y%m%d%H%M')"

data="$(shmm WTTR -r)"
if [ "$data" == "" ]; then
	shmm WTTR -a 128
	shmm WTTR -w "-"
else
	last_update="$(shmm WTTR -r | awk -F: '{print $1}')"
	let pass_time="$current_time - $last_update"
	if [ "$pass_time" -lt "$UPDATE_DELAY" ]; then
		echo ""
		exit 0
	fi
fi

json="$(curl -s https://wttr.in/Palho%C3%A7a?format=j1)"
[[ "$(echo $json | wc -c)" -le 5000 ]] && echo "" exit 0

wttr_data="$(echo $json | python $JSON_READER_PATH current_condition.0.temp_C current_condition.0.humidity current_condition.0.weatherCode current_condition.0.visibility)"

shmm WTTR -w "${current_time}:${wttr_data}"
echo 

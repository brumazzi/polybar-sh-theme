#!/bin/bash

source ~/.config/polybar/modules/color.sh

PID=$(ps -C timidity -o pid=)

ICON=$(echo -e "\UF001")

if [ "$PID" ]; then
	if [ "$1" -eq 1 ]; then
		kill -9 $PID
	fi
	printf "$ICON:$GREEN MIDI \n"
else
	if [ "$1" -eq 1 ]; then
		timidity -iA &
	fi
	printf "$ICON:$RED MIDI \n"
fi

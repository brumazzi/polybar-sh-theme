#!/bin/bash

source ~/.config/polybar/modules/color.sh

PID=$(ps -C timidity -o pid=)

ICON=$(echo -e "\U1F3BC")

if [ "$PID" ]; then
	if [ "$1" -eq 1 ]; then
		kill -9 $PID
	fi
	printf "$BAR_GREEN $ICON \n"
else
	if [ "$1" -eq 1 ]; then
		timidity -iA &
	fi
	printf "$BAR_RED $ICON \n"
fi

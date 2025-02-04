#!/bin/bash

source ~/.config/polybar/modules/functions.sh
source ~/.config/polybar/modules/color.sh
source ~/.config/polybar/modules/progress-bar.sh

if [ "$(shmm AC_ACTIVE -r)" != "" ]; then
	if [ "$(shmm AC_ACTIVE -r)" == "1" ]; then
		printf "$BAR_GREEN$GRAY  AutoClick:$GREEN ON "
	else
		printf "$BAR_RED$GRAY  AutoClick:$RED OFF"
	fi
else
	printf "$NO_BAR"
fi

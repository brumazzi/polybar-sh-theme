#!/bin/bash

source ~/.config/polybar/modules/functions.sh
source ~/.config/polybar/modules/color.sh

if [ "$(shmm AC_ACTIVE -r)" != "" ]; then
	if [ "$(shmm AC_ACTIVE -r)" == "1" ]; then
		printf ":$GREEN AutoClick <F8>"
	else
		printf ":$RED AutoClick <F8>"
	fi
else
	printf "$NO_BAR"
fi

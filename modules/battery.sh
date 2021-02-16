#!/bin/bash

source ~/.config/polybar/modules/color.sh

ACAD=$(cat /sys/class/power_supply/ACAD/online)
[[ -d "/sys/class/power_supply/BAT0" ]] && BAT=/sys/class/power_supply/BAT0 ||
[[ -d "/sys/class/power_supply/BAT1" ]] && BAT=/sys/class/power_supply/BAT1 || exit 1

function acad_on(){
	printf $ACAD
}

function status(){
	printf $(cat $BAT/status)
}

function full(){
	printf $(cat $BAT/charge_full)
}

function now(){
	printf $(cat $BAT/charge_now)
}

function porcent(){
	max=$(full)
	now=$(now)
	let pct="$now*100/$max"
	printf "${pct}"
}

function shut_down(){
	notify-send -u critical -t 10000 "Bateria crítica" "O computador desligará em 5 segundos!"
	sleep 5
	sudo pm-suspend
}

SYMB=
if [ "$(acad_on)" == "1" ]; then
	SYMB=$(echo -e "\U1f50c")
else
	SYMB=$(echo -e "\U1f50b")
fi

COLOR=$GREEN
PORC=$(porcent)
if [ "$PORC" -le 15 ]; then
	COLOR=$RED
	shut_down
elif [ "$PORC" -le 30 ]; then
	COLOR=$ORANGE
elif [ "$PORC" -le 60 ]; then
	COLOR=$YELLOW
fi

printf "$SYMB: $GREEN$PORC%%"

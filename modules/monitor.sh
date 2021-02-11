#!/bin/sh

OUT=$(xrandr | grep connected | grep -v disconnected | awk -F' ' '{print $1}')
ifs=' '
export DISP=($OUT)

if [ "${DISP[1]}" == "" ]; then
#	echo ${DISP[0]}
#else
	xrandr -s 1366x768
	pactl set-card-profile 0 output:analog-stereo
	echo -e "\U1f4bb: (None)"
	exit 0
fi

BTN=0
[[ "$1" ]] && BTN=$1

if [ "$BTN" -eq 1 ]; then
	MON1=$(zenity --list --column=Monitor $OUT)

	if [ "$MON1" == "HDMI1" ] || [ "$MON1" == "HDMI-1" ]; then
		xrandr --output ${DISP[0]} --mode 1366x768 --output $MON1 --mode 1366x768 --same-as ${DISP[0]}
		pactl set-card-profile 0 output:hdmi-stereo+input:analog-stereo
	else
		xrandr --output ${DISP[0]} --mode 1024x768 --output $MON1 --mode 1024x768 --same-as ${DISP[0]}
	fi
fi

#xrandr --output ${DISP[0]} --mode 1366x768 --output ${DISP[1]} --mode 1366x768 --same-as ${DISP[0]}

echo -e "\U1f4bb: ${DISP[1]}"

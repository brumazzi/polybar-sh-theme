#!/bin/bash

source ~/.config/polybar/modules/Color.bash

VRAM="$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk -F', ' '{print int(($1/$2)*10)}')"

#COLORS=("#42d6b9" "#4bd3b3" "#7dc391" "#adb370" "#dda34f" "#ff9838" "#f98b3c" "#ef7741" "#e66447" "#db4d4d")
COLORS=(428cd6 4267d6 4242d6 8042d6 a542d6 ca42d6 d642bd d64298 d64273 d64242)
BASE_COLOR="#555555"

index=0

printf ": "

while [ ${COLORS[$index]} ]; do
	color=${COLORS[$index]}
	if [ $index -lt $VRAM ]; then
		printf "%%{F#$color}▐%%{F-}"
	else
		printf "%%{F$BASE_COLOR}▐%%{F-}"
	fi
	let index="$index + 1"
done

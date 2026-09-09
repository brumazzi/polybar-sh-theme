#!/bin/bash

source ~/.config/polybar/modules/Color.bash
ICON=""

FIRST_RUN=false
if [ "$(shmm i3-CPU -e)" -eq 0 ]; then
	shmm i3-CPU -a 1024
	FIRST_RUN=true
fi
IFS='
'
CPU_USAGE_LIST=($(grep '^cpu[0-9]' /proc/stat))
IFS=' '

cpu_list=""

let index=0
while [ $index -lt "${#CPU_USAGE_LIST[@]}" ]; do
	line=${CPU_USAGE_LIST[$index]}
	items=($line)

	let cpu_capacity=0
	for cpu_index in 1 2 3 4 5 6 7 8; do
		let cpu_capacity="$cpu_capacity + ${items[$cpu_index]}"
	done
	let cpu_idle_count="${items[4]} + ${items[5]}"

	cpu_list="$cpu_list$cpu_capacity $cpu_idle_count "

	let index="$index + 1"
done

if [ "$FIRST_RUN" == "true" ]; then
	shmm i3-CPU -w "$cpu_list"
	printf "calibrando..."
	exit 0
else
	data=($(shmm i3-CPU -r))
	cur_data=($cpu_list)

	index=0
	declare -A CPU
	while [ "$index" -lt "${#data[@]}" ]; do
		let total="${cur_data[$index]} - ${data[$index]}"
		let idle="${cur_data[$((index + 1))]} - ${data[$((index + 1))]}"

		let percent="($total - $idle)*100/$total"
		CPU[${#CPU[@]}]="$percent"
		((avg += percent))

		let index="$index + 2"
	done
	((avg = avg/${#data[@]}*2))
	CPU_AVG="$avg"
	shmm i3-CPU -w "$cpu_list"
fi

COLORS=(555555 42d6b9 4bd3b3 7dc391 adb370 dda34f ff9838 f98b3c ef7741 e66447 db4d4d)
#COLORS=(428cd6 4267d6 4242d6 8042d6 a542d6 ca42d6 d642bd d64298 d64273 d64242)
BASE_COLOR="#555555"


mode=$1
cpu_index=$2

printf "${ICON}: "

BAR_ICONS[0]="\u4c"
BAR_ICONS[1]="\u4d"
BAR_ICONS[2]="\u4e"
BAR_ICONS[3]="\u4f"
BAR_ICONS[4]="\u50"
BAR_ICONS[5]="\u51"
BAR_ICONS[6]="\u52"
BAR_ICONS[7]="\u53"
BAR_ICONS[8]="\u54"
BAR_ICONS[9]="\u55"
BAR_ICONS[10]="\u56"

index=0
if [ "$mode" == "--progress-bar" ]; then
	printf "%%{T8}"
	let max="${#CPU[@]}/2"
	
	if [ "$2" == "--vertical" ]; then
		while [ "$index" -le "$max" ]; do
			let p1="$index"
			let p2="$index+$max-1"
			half1="${CPU[$p1]}"
			half2="${CPU[$p2]}"

			item_index="$(echo "$half1/20 + $half2/20" | bc)"
			printf "%%{F#${COLORS[$item_index]}}${BAR_ICONS[$item_index]}%%{F-}"

			((index++))
		done
	else

		for color in {1..10}; do
			color=${COLORS[$color]}
			let max="$CPU_AVG/10"
			if [ $index -lt "$max" ]; then
				printf "%%{F#$color}${BAR_ICONS[10]}%%{F-}"
			else
				printf "%%{F$BASE_COLOR}${BAR_ICONS[10]}%%{F-}"
			fi
			let index="$index + 1"
		done
	fi
	printf "%%{T-}"
else
[[ "$cpu_index" == "" ]] &&
	echo ${CPU_AVG} ||
	echo "${CPU[$cpu_index]}"
fi

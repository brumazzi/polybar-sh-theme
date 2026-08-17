#!/bin/bash

source ~/.config/polybar/modules/Color.bash

WORKSPACES="$(i3-msg -t get_workspaces)"
WORKSPACES_COUNT="$(echo $WORKSPACES | jq length)"

let i=0
while [ $i -lt $WORKSPACES_COUNT ]; do
	num="$(echo $WORKSPACES | jq .[$i].num)"
	name="$(echo $WORKSPACES | jq .[$i].name)"
	visible="$(echo $WORKSPACES | jq .[$i].visible)"
	focus="$(echo $WORKSPACES | jq .[$i].focused)"
	output="$(echo $WORKSPACES | jq .[$i].output)"
	urgent="$(echo $WORKSPACES | jq .[$i].urgent)"
	
	if [ "$visible" == "true" ]; then
		printf "$BG_GRAY"
	fi
	if [ "$focus" == "true" ]; then
		printf "${GREEN}${BAR_GREEN}"
	fi
	if [ "$urgent" == "true" ]; then
		printf "${RED}${BAR_RED}"
	fi

	printf "%%{A1:i3-msg workspace $num:}"

	printf "   ${name:1:-1}   "
	printf "$NO_B_COLOR"
	printf "$NO_F_COLOR"
	printf "%%{u#222}"
	#printf "$NO_BAR"
	printf "%%{A}"


	let i="$i + 1"
done

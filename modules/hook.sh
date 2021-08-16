#!/bin/bash

# this mod required SysHook python version
[[ -f /opt/SysHook/main.py ]] || exit 1

function call_back() {
	[[ -f /tmp/i3hook-play.tmp ]] && return 1
	touch /tmp/i3hook-play.tmp
	SOUND_ACTIVE="/usr/share/sounds/hook/sonar.ogg"
	SOUND_DESACTIVE="/usr/share/sounds/hook/note.ogg"

	INPUT=$(cat /var/run/hook.stat)
	INPUT=${INPUT^^} # use ,, to lower string
	while [ 1 ] ; do
		TEST=$(cat /var/run/hook.stat)
		TEST=${TEST^^}

		if [ "$TEST" != "$INPUT" ]; then
			INPUT=$TEST
			PLAY="ogg123 \$SOUND_$TEST"
			eval $PLAY &
		fi
		[[ -f /tmp/i3hook-play.tmp ]] || break
		sleep 0.5
	done
}

[[ "$1" == "play" ]] &&
	call_back &&
	exit 0

source ~/.config/polybar/modules/color.sh

[[ -f /var/run/hook.pid ]] || exit 0

STAT="$(cat /var/run/hook.comm)"

if [ "$1" == "test" ]; then
	if [ "$STAT" ]; then
		exit 0
	else
		exit 1
	fi
fi

if [ "$STAT" ]; then
	printf "${BAR_PURPLE}${LIGHT}\U1f42c Dolphin: ${PURPLE}${STAT^}"
else
	if [ "$(pgrep emerge)" ]; then
		printf "${BAR_ORANGE}${GREEN}[ PORTAGE IS RUNNING${GREEN} ]"
	else
		printf "$NO_BAR"
	fi
fi

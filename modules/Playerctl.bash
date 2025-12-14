#!/bin/bash

source ~/.config/polybar/modules/Color.bash

ICON_PREVIEW="\Uf048"
ICON_PLAY="\Uf04b"
ICON_PAUSE="\Uf04c"
ICON_STOP="\Uf04d"
ICON_NEXT="\Uf051"
ICON_MUSIC_NOTE="\Uf001"

SPACE="                    "


function get_loop {
    case "$1" in
        0) echo None;;
        1) echo Track;;
        2) echo Playlist;;
    esac
}

if [ ! "$(shmm i3-PlayerCtlLoop --pointer)" ]; then
    shmm i3-PlayerCtlLoop -a 64
    shmm i3-PlayerCtlLoop -w "0"
    playerctl loop None
fi

if [ ! "$(shmm i3-PlayerCtlRange --pointer)" ]; then
    shmm i3-PlayerCtlRange -a 8
    shmm i3-PlayerCtlRange -w "0:20"
fi

if [ "$1" ]; then
    case "$1" in
        --output) polybar-widget sound-card ;;
        --play) playerctl play ;;
        --pause) playerctl pause ;;
        --stop) playerctl stop ;;
        --next) playerctl next ;;
        --previous) playerctl previous ;;
        --loop)
            let current_loop="($(shmm i3-PlayerCtlLoop -r) + 1)%3"
            playerctl loop "$(get_loop $current_loop)"
            shmm i3-PlayerCtlLoop -w "$current_loop"
            ;;
    esac
else
    status=$(playerctl status --no-messages)
    position="$(shmm i3-PlayerCtlRange -r | awk -F: '{ print $1 }' )"
    limit="$(shmm i3-PlayerCtlRange -r | awk -F: '{ print $2 }' )"

    if [ "$status" ]; then
        music="$(playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null)"
	extra_space=""

	let i=0
	while [ $i -lt ${#music} ]; do
		if echo "${music:$i:1}" | grep -P '[\p{Hiragana}\p{Katakana}\p{Han}]' >/dev/null; then
 			extra_space=" "
		fi
		let i="$i + 1"
	done

        spaced_music="${SPACE}${music}${SPACE}"

        # printf "%%{B#dbdbdb}${DARK} %%{T6}"
        printf "%%{T6}"
        index=0
        while [ $index -le ${#SPACE} ]; do
            let text_pos="$position + $index"
            if echo "${spaced_music:$text_pos:1}" | grep -P '[\p{Hiragana}\p{Katakana}\p{Han}]' >/dev/null; then
                echo -n "${spaced_music:$text_pos:1}"
            else
                echo -n "${spaced_music:$text_pos:1}${extra_space}"
            fi
            let index="$index + 1"
        done
        printf " ${NO_B_COLOR}"

        printf "  ${YELLOW}%%{A1:bash $0 --previous:}$ICON_PREVIEW%%{A}  "
        case "$status" in
            "Playing")
            printf "%%{A1:bash $0 --pause:}$ICON_PAUSE%%{A}  ${GRAY}$ICON_PLAY${YELLOW}  %%{A1:bash $0 --stop:}$ICON_STOP%%{A}"
            let position="($position+1)%(${#music}+${SPACE}+20)"
            shmm i3-PlayerCtlRange -w "${position}:${limit}"
            ;;
            "Paused")
            printf "${GRAY}$ICON_PAUSE${YELLOW}  %%{A1:bash $0 --play:}$ICON_PLAY%%{A}  ${GRAY}$ICON_STOP${YELLOW}"
            ;;
        esac
        printf "  %%{A1:bash $0 --next:}$ICON_NEXT%%{A}${NO_F_COLOR}  "

    else
        shmm i3-PlayerCtlRange -w "0:20"
        # message="  Audio not playing  "
        # printf "%%{T6}%${#SPACE}.${#SPACE}s  ${GRAY}${ICON_PREVIEW}  ${ICON_PLAY}  ${ICON_PAUSE}  ${ICON_STOP}  ${ICON_NEXT}" "${message:0:$limit}"
    fi
fi

printf "%%{A1:bash $0 --output:}%%{T1}("
source ~/.config/polybar/modules/Audio-Card.bash
printf ")%%{A}"


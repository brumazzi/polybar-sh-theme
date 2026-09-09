#!/bin/bash

source ~/.config/polybar/modules/Color.bash

VIDEO_RECORD_ICON="\Uf03d"
SCREEN_SHOT_ICON="\Uf083"

SCREENSHOT_ICON_DELAY=20
SCREENSHOT_SOUND="$HOME/.config/polybar/sounds/printscreen.mp3"

[[ "$(shmm i3-ScreenRecord -e)" -eq 0 ]] &&
	shmm i3-ScreenRecord -a 10 &&
	shmm i3-ScreenRecord -w 0

[[ "$(shmm i3-ScreenShot -e)" -eq 0 ]] &&
	shmm i3-ScreenShot -a 3 &&
	shmm i3-ScreenShot -w 0

[[ "$(shmm i3-ScreenRecordTimer -e)" -eq 0 ]] &&
	shmm i3-ScreenRecordTimer -a 3 &&
	shmm i3-ScreenRecordTimer -w 0

pid="$(shmm i3-ScreenRecord -r)"
rec_timer="$(shmm i3-ScreenRecordTimer -r)"
sshot="$(shmm i3-ScreenShot -r)"

function screen-shot {
	[[ ! -d "$XDG_PICTURES_DIR/Capture" ]] && mkdir $XDG_PICTURES_DIR/Capture -p
	picture_output="$XDG_PICTURES_DIR/Capture/screen-capture-$(date +'%Y-%m-%d-%H-%M-%S').png"

	selected_window=""
	echo "$1"
	if [ "$1" == "--window" ]; then
		selected_window="-window_id $(xdotool getwindowfocus)"
	fi
	
	[[ -f "$SCREENSHOT_SOUND" ]] && mpg123 $SCREENSHOT_SOUND
	ffmpeg -f x11grab $selected_window -i :0.0 -vframes 1 $picture_output 2> /dev/null && 
		notify-send -u normal -t 6000 -i $picture_output -a "Som" "Screenshot" "Image saved in ${picture_output}" &
	shmm i3-ScreenShot -w $SCREENSHOT_ICON_DELAY
}

function toggle-record {
	[[ ! -d "$XDG_VIDEOS_DIR/Capture" ]] && mkdir $XDG_VIDEOS_DIR/Capture -p
	if [ "$pid" -ne 0 ]; then
		kill -2 $pid
		shmm i3-ScreenRecord -w 0
		return
	fi

	IFS=' '
	output="$(pactl list short sources | grep IDLE | awk '{print $2}')"
	if [ "${output}" != "" ]; then
		OUTPUT_CARD_PARAMS="-f pulse -i ${output}"
	fi

	xrandr_info=($(xrandr | grep \*))
	video_size="-video_size ${xrandr_info[0]}"
	frame_rate=60
	video_output="$XDG_VIDEOS_DIR/Capture/screen-capture-$(date +'%Y-%m-%d-%H-%M-%S').mp4"

	if [ "$1" == "--window" ]; then
		video_size="-window_id $(xdotool getwindowfocus)"
	fi

	ffmpeg -f x11grab $video_size -framerate $frame_rate -i $DISPLAY \
		$OUTPUT_CARD_PARAMS \
		-f pulse -i default \
		-filter_complex "[1:a][2:a]amix=inputs=2:duration=longest[a]" \
		-map 0:v -map "[a]" \
		-c:v h264_nvenc -preset p5 -b:v 6000k -maxrate 6500k -bufsize 12M \
		-pix_fmt yuv420p -g 120 \
		-c:a aac -b:a 160k -ar 48000 \
		$video_output 2> /dev/null &
	shmm i3-ScreenRecord -w $!
	shmm i3-ScreenRecordTimer -w 0
}

if [ "$1" == "--toggle-record" ]; then
	toggle-record $2
	exit 0
elif [ "$1" == "--screenshot" ]; then
	screen-shot $2
	exit 0
fi

if [ "$sshot" -gt 0 ]; then
	shmm i3-ScreenShot -w $((sshot - 1))
	printf "${YELLOW}${SCREEN_SHOT_ICON}"
	[[ "$pid" -ne 0 ]] && printf " "
fi

if [ "$pid" -eq 0 ]; then
	echo ""
else
	if [ -d /proc/$pid ]; then
		if (( $rec_timer % 16 >= 8 )); then
			printf "${RED}${VIDEO_RECORD_ICON}"
		else
			printf "${RED} "
		fi
		shmm i3-ScreenRecordTimer -w $((rec_timer + 1))
	else
		shmm i3-ScreenRecord -w 0
	fi
fi

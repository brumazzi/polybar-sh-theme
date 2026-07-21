#!/bin/bash

source ~/.config/polybar/modules/Color.bash

function win_alias {
	case $1 in
	*firefox*)
		echo -n "Mozilla Firefox"
		;;
	*)
		echo -n ${@^}
		;;
	esac
}

CLASS_NAME="$(xdotool getactivewindow getwindowclassname 2> /dev/zero)"
CLASS_NAME_LEN=${#CLASS_NAME}
CLASS_NAME=${CLASS_NAME:0:27}

if [ "$CLASS_NAME_LEN" -eq 0 ]; then
	echo ""
	exit 0
elif [ "$CLASS_NAME_LEN" -ge 27 ]; then
	CLASS_NAME="${CLASS_NAME}..."
fi

printf "%%{T6}$BG_LIGHT$DARK  "
win_alias ${CLASS_NAME/-/ }
printf "  $BG_RED$LIGHT%%{A1:i3-msg kill &:}    %%{A}"

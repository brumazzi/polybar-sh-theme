#!/bin/bash

source ~/.config/polybar/modules/color.sh

function text_split {
	PY_COMM="w=''
for i in '$1':
	w=w+i+' '
for i in range($2-len('$1')):
	w=w+'- '
print(w)"
	python -c "$PY_COMM"
}

function progress_bar {
	MAX=$1
	CUR=$2
	TEXT=$3
	COUNT=${#TEXT}

	PORC=$(echo "$CUR*$COUNT/$MAX" | bc)
	progress_end=$(printf '{$%s=$%s"%s"}1' $PORC $PORC $PROGRESS_OFF)
	echo "$TEXT" | awk -vFS="" -vOFS="" $progress_end
}


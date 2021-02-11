#!/bin/bash

# source ~/.config/polybar/modules/color.sh

HTML_FMT="%s"

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
	COLOR=$4
	COUNT="$5"

	IFS=' '
	_text=($TEXT)

	PORC=$(echo "$CUR*$COUNT/$MAX" | bc)
	printf ""

	I=0
	# while [ $I -le $COUNT ]; do
	# 	if [ "${_text[$I]}" == "-" ]; then
	# 		if [ $I -le $PORC ]; then
	# 			printf "$HTML_FMT" $COLOR $COLOR '#'
	# 		else
	# 			printf "$HTML_FMT" $PROGRESS_OFF $PROGRESS_OFF '#'
	# 		fi
	# 	else
	# 		if [ $I -le $PORC ]; then
	# 			printf "$HTML_FMT" $COLOR $PROGRESS_TEXT ${_text[$I]}
	# 		else
	# 			printf "$HTML_FMT" $PROGRESS_OFF $PROGRESS_TEXT ${_text[$I]}
	# 		fi
	# 	fi
	# 	let I=$I+1
	# done
	printf "\n"
}


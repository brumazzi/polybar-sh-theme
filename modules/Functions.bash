#!/bin/bash

function check-command {
	command="$1"
	whereis="$(whereis $command)"
	parts=($whereis)
	if [ "${#parts[@]}" -gt 1 ] && [ -x "${parts[1]}" ]; then
		return 0
	fi
	return 1
}

function set-recently {
	RECENTLY_CONFIG_PATH="$HOME/.local/share/recently-used.xbel"
	ok=1
	
	[[ -e "${1:7}" ]] || ok=0
	[[ "${2}" ]] || ok=0
	[[ "${3}" ]] || ok=0

	cur_date="$(date -u +"%Y-%m-%dT%H:%M:%S.%6NZ")"

	href="\"@href\": \"file://$1\""
	added="\"@added\": \"$cur_date\""
	modified="\"@modified\": \"$cur_date\""
	visited="\"@visited\": \"$cur_date\""
	mime_type="$(xdg-mime query filetype ${1:7})"
	group="$2"
	application_name=$3

	if [ "$ok" -eq 0 ]; then
		echo "Usage: set-recently \"<full_path>\" \"<Group>\" \"<application>\""
		return 1
	fi

	info="\"info\": {\"metadata\": {\"@owner\": \"http://freedesktop.org\", \"mime:mime-type\": {\"@type\": \"$mime_type\"}, \"bookmark:groups\": {\"bookmark:group\": \"$group\"}, \"bookmark:applications\" :{\"bookmark:application\": {\"@name\": \"$application_name\", \"@exec\": \"$(xdg-mime query default $mime_type)\", \"@modified\": \"$cur_date\", \"@count\": \"1\"}}}}"

	data="{$href, $added, $modified, $visited, $info}"

	if [ ! -f $RECENTLY_CONFIG_PATH ]; then
		echo '<?xml version="1.0" encoding="UTF-8"?>
<xbel version="1.0"
      xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks"
      xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info"
>
</xbel>' > $RECENTLY_CONFIG_PATH
		xq -x -i --xml-item-depth 0 ".xbel.bookmark = $data" $RECENTLY_CONFIG_PATH #> $RECENTLY_CONFIG_PATH
	else
		xq -x -i --xml-item-depth 0 ".xbel.bookmark += [$data]" $RECENTLY_CONFIG_PATH #> $RECENTLY_CONFIG_PATH
	fi
}


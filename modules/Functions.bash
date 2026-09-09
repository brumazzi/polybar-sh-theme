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

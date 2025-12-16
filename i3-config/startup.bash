#!/bin/bash
#

# $1 = command to run
# $2 = delay in seconds
function run-delay {
	sleep $2
	[[ "$(pgrep $1)" == "" ]] &&
		$1
}

start_timidity () {
	sleep 5
	[[ "$(ps -C timidity -o pid=)" ]] || timidity -iA
}

run-delay "sudo rc-service ntp-client start" 5 &

for file in $HOME/.config/autostart/*.desktop; do
	if [ -x $file ]; then
		ExecCommand="$(cat $file | grep Exec | grep -v TryExec | awk -F= '{print $2}')"
		
		ExecDelay="$(cat $file | grep Delay | awk 'NR == 1' | awk -F= '{print $2}' )"
		[[ "$ExecDelay" == "" ]] && ExecDelay=0

		run-delay "$ExecCommand" "$ExecDelay" &
	fi
done

for var in Weather:256 BGDelay:6 BG:1024 CoinMode:4 CoinPrice:2048 kmap:64; do
	var_name="$(echo $var | awk -F: '{print $1}')"
	var_size="$(echo $var | awk -F: '{print $2}')"

	shmm i3-$var_name -a $var_size
done

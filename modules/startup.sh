#!/bin/sh

#PROCS="conky nm-applet"

#sh ~/.config/polybar/modules/sync_clock.sh

cd ~/.config/polybar/modules/
git push origin master
cd -

for proc in $PROCS; do
	( 
		sleep 1
		[[ "$(pgrep $proc)" ]] && echo $proc up ||
		if [ "$proc" == "conky" ]; then
			$proc -c ~/.config/polybar/modules/conky.conf
		else
			$proc
		fi
	) &
done

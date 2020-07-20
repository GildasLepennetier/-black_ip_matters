#!/usr/bin/env bash
set -e
while [ 0 ];do
	source main.param.sh
	
	for TODO in $(cat $LIST_TODO | grep -v -e '^$' -e '^#'); do
		bash $TODO
	done
	sleep $((60*$SLEEP_MIN))s
	
	#grep "$WARNING_IP" blacklist.* -n
	
done

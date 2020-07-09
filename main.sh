#!/usr/bin/env bash
set -e
while [ 0 ];do
	source main.param.sh
	for TODO in $(cat $LIST_TODO | grep -v "^#"); do
		bash $TODO
	done
	sleep $((60*$SLEEP_MIN))s
done

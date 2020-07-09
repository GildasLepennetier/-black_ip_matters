#!/usr/bin/env bash
set -e
SLEEP_MIN=1
LIST_TODO=todo.txt
while [ 0 ];do
	for TODO in $(cat $LIST_TODO);do
		bash $TODO
	done
	sleep $((60*$SLEEP_MIN))s
done

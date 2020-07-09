#!/usr/bin/env bash
set -e
SLEEP_MIN=1
while [ 0 ]; do
	DATE=$(date +"%Y-%d-%m %T" )
	COUNT1=$(cat blacklist.txt | wc -l)
	wget -q https://www.abuseipdb.com/ -O index.html 2> /dev/null
	cat index.html | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > new.txt
	cat blacklist.txt new.txt | sort | uniq > blacklist.txt.tmp
	mv blacklist.txt.tmp blacklist.txt
	COUNT2=$(cat blacklist.txt | wc -l)
	rm index.html
	rm new.txt
	EXEMPLE=$(shuf -n 1 blacklist.txt)
	echo -e "+$(($COUNT2-$COUNT1)) IP\t[total: $COUNT2]\t$DATE"
	sleep $((60*$SLEEP_MIN))s
done

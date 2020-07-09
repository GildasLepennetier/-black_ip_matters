#!/usr/bin/env bash
set -e
SLEEP_MIN=10
while [ 0 ]; do
	echo -e "\nStill running $(date)"
	echo "$(wc -l blacklist.txt) IPs before"
	wget -q https://www.abuseipdb.com/ -O index.html 2> /dev/null
	cat index.html | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > new.txt
	cat blacklist.txt new.txt | sort | uniq > blacklist.txt.tmp
	echo "$(wc -l blacklist.txt) IPs total now"
	mv blacklist.txt.tmp blacklist.txt
	rm index.html
	rm new.txt
	echo "exemple: $(shuf -n 1 blacklist.txt)"
	sleep $((60*$SLEEP_MIN))s	#10 min
done

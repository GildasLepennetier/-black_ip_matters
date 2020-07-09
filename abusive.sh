#!/usr/bin/env bash
set -e
# check the website
DATABASE="blacklist.abusive.txt"
WEBSITE="https://www.abuseipdb.com/"
NAME_DISPLAY="[abusive ip web]"
DATE=$(date +"%Y-%d-%m %T" )
COUNT1=$(cat ${DATABASE} | wc -l)
wget -q $WEBSITE -O index.html 2> /dev/null
cat index.html | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > ${DATABASE}.new
cat ${DATABASE} ${DATABASE}.new | sort | uniq > ${DATABASE}.tmp
mv ${DATABASE}.tmp ${DATABASE}
COUNT2=$(cat ${DATABASE} | wc -l)
rm index.html
rm ${DATABASE}.new
EXEMPLE=$(shuf -n 1 ${DATABASE})
echo -e "$NAME_DISPLAY\t+$(($COUNT2-$COUNT1)) IP\t[total: $COUNT2]\t$DATE\t\tex:$EXEMPLE"

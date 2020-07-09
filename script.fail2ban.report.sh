#!/usr/bin/env bash
set -e
# check the website
DATABASE="blacklist.fail2ban-report.all.txt"
WEBSITE="https://lists.blocklist.de/lists/all.txt"
NAME_DISPLAY="[fail2ban-report]"
DATE=$(date +"%Y-%d-%m %T" )

COUNT1=$(cat ${DATABASE} | wc -l)
wget -q $WEBSITE -O blacklist.fail2ban-report.all.LATEST.txt 2> /dev/null
cat blacklist.fail2ban-report.all.LATEST.txt | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > ${DATABASE}.new
cat ${DATABASE} ${DATABASE}.new | sort | uniq > ${DATABASE}.tmp
mv ${DATABASE}.tmp ${DATABASE}
COUNT2=$(cat ${DATABASE} | wc -l)
#rm blacklist.fail2ban-report.all.LATEST.txt
rm ${DATABASE}.new
EXEMPLE=$(shuf -n 1 ${DATABASE})
echo -e "$NAME_DISPLAY\t+$(($COUNT2-$COUNT1)) IP\t[total: $COUNT2]\t$DATE\t\tex:$EXEMPLE"


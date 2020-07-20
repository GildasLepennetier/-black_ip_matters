#!/usr/bin/env bash
set -e
# check the logs for you
DATABASE="blacklist.fail2ban.txt"
NAME_DISPLAY="[fail2ban-local]"
DATE=$(date +"%Y-%d-%m %T" )
COUNT1=$(cat ${DATABASE} | wc -l)
zgrep 'Ban' /var/log/fail2ban.log | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > ${DATABASE}.new
cat ${DATABASE} ${DATABASE}.new | sort | uniq > ${DATABASE}.tmp
mv ${DATABASE}.tmp ${DATABASE}
rm ${DATABASE}.new
COUNT2=$(cat ${DATABASE} | wc -l)
EXEMPLE=$(shuf -n 1 ${DATABASE})
echo -e "$NAME_DISPLAY\t+$(($COUNT2-$COUNT1)) IP\t[total: $COUNT2]\t$DATE\t\tex:$EXEMPLE"

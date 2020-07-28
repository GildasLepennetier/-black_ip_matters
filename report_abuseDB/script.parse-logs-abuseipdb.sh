#!/usr/bin/env bash
set -e 

SCRIPTNAME=$(readlink -nf $0)

# Operand: the file to parse.
secureLogFile=/var/log/auth.log
# Operand: the API key of the AbuseIPDB user.
key=0f2918838d975ad2abd710d844762f8acb9d288103eac72cd10327795cd9bd17bee3c9dbc95c63af

# Standard operand checking.
if [ -z $secureLogFile ]; then
	echo -e "$SCRIPTNAME\tMissing input file. Aborting." >&2
	exit 1;
elif [ ! -r $secureLogFile ]; then
	echo -e "$SCRIPTNAME\tFile does not exist or is not readable. Aborting." >&2
	exit 1;
fi

# Pick the Unit Separator (non-printing character) to delimit the fields.
unit_sep=$'\031'

echo -e "$SCRIPTNAME\tgetting the data"
# Find the pattern matches for an invalid user.
pcregrep -o1 -o2 -o3 --om-separator="$unit_sep" -e '([a-zA-Z]+ [0-9]+ [0-9]+:[0-9]+:[0-9]+) .* (Invalid user [a-zA-Z0-9]+ from (([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})) port [0-9]+)' $secureLogFile > matches.txt

# Create CSV headers.
echo "IP,Categories,ReportDate,Comment" > report.csv

# Rearrange the order of the fields for our bulk uploader.
# IP & ReportDate generally don't need to be enclosed, but we'll play it safe.

echo -e "$SCRIPTNAME\tcreating the report"
gawk -F "$unit_sep" 'BEGIN {OFS=","} {print "\""$3"\",\"18,22\",\""$1"\",\""$2"\""}' matches.txt | sort | uniq | tail -n 9999 >> report.csv

# Clean up. Comment out if you want to peruse the matches.
rm matches.txt


echo -e "$SCRIPTNAME\tsend data - nb of records: $( tail -n +2 report.csv | wc -l)"
# Report to AbuseIPDB.
curl https://api.abuseipdb.com/api/v2/bulk-report -F csv=@report.csv -H "Key: $key" -H "Accept: application/json" > output.json

mv report.csv report.last_uniq_9999.csv

exit 0;

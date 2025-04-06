#!/bin/bash

pathToCertPem=$1

dt=$(date --date="$(openssl x509 -enddate -noout -in ${pathToCertPem} | cut -d= -f 2)" --iso-8601)

dtMinus1=$(date --date="$dt - 1 days" --iso-8601)
dtMinus7=$(date --date="$dt - 7 days" --iso-8601)
dtMinus14=$(date --date="$dt - 14 days" --iso-8601)

echo "dt '${dt}', dtMinus1 '${dtMinus1}', dtMinus7 '${dtMinus7}', dtMinus14 '${dtMinus14}'"

today="$(date +%Y-%m-%d)"

send_notification() {
    local days=$1
    local pathToCertPem=$2
    local dt=$3

    domainName=$(openssl x509 -in ${pathToCertPem} -noout -subject | sed -n 's/^.*CN=\(.*\)$/\1/p')
    echo "Certificate expires in ${days} days" | mail -s "Certificate for ${domainName} expires on ${dt}"
}

if [ "$today" == "$dtMinus1" ]; then
    send_notification "1" "$pathToCertPem" "$dt"
elif [ "$today" == "$dtMinus7" ]; then
    send_notification "7" "$pathToCertPem" "$dt"
elif [ "$today" == "$dtMinus14" ]; then
    send_notification "14" "$pathToCertPem" "$dt"
fi

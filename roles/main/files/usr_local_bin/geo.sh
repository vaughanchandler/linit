#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Shows geolocation data from ip-api.com for the specified IP addresses or domain names."
	echo "Usage: $0 [address...]"
	exit
fi

for address in $@; do
	curl -s "http://ip-api.com/json/$address" | jq
done

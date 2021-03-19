#!/bin/bash

# Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# Username
USERNAME=$(/usr/bin/logname)

# Start in user home directory
cd /home/$USERNAME

# Current timestamp
CURRENT_TIMESTAMP=$(/usr/bin/date +%s)



# Create cache directory if it doesn't exist yet
if [ ! -d ~/dfd-crypto-ticker/cache ]; then
/usr/bin/mkdir -p ~/dfd-crypto-ticker/cache
fi



# Check to see if the kucoin cache data needs to be updated
if [ -f ~/dfd-crypto-ticker/cache/kucoin-auth.json ]; then

# 6 hours (in seconds) between refreshings
KUCOIN_REFRESH=21600

KUCOIN_LAST_MODIFIED=$(/usr/bin/date +%s -r ~/dfd-crypto-ticker/cache/kucoin-auth.json)

KUCOIN_THRESHOLD=$((KUCOIN_LAST_MODIFIED + KUCOIN_REFRESH))

	if [ "$CURRENT_TIMESTAMP" -ge "$KUCOIN_THRESHOLD" ]; then
	UPDATE_KUCOIN=1
	fi

else
UPDATE_KUCOIN=1

fi



# If KUCOIN update flagged, cache new kucoin data to kucoin-auth.json, AND flag a JS CACHE update
if [ "$UPDATE_KUCOIN" == 1 ]; then

/usr/bin/curl -X POST https://api.kucoin.com/api/v1/bullet-public > ~/dfd-crypto-ticker/cache/kucoin-auth.json

/bin/sleep 3

UPDATE_JS=1

fi



# If JS CACHE update flagged, ready all desired json cache vars for cache.js updating
if [ "$UPDATE_JS" == 1 ]; then


# Kucoin data
KUCOIN_TOKEN=$(/usr/bin/jq .data.token ~/dfd-crypto-ticker/cache/kucoin-auth.json)

KUCOIN_ENDPOINT=$(/usr/bin/jq .data.instanceServers[0].endpoint ~/dfd-crypto-ticker/cache/kucoin-auth.json)


# Don't nest / indent, or it could malform the settings            
read -r -d '' JS_CACHE <<- EOF
\r
var kucoin_token = $KUCOIN_TOKEN;
\r
var kucoin_endpoint = $KUCOIN_ENDPOINT;
\r
\r
EOF


# Write to cache.js
echo -e "$JS_CACHE" > ~/dfd-crypto-ticker/cache/cache.js

/bin/sleep 3

fi




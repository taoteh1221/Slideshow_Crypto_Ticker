#!/bin/bash

# Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# Start in user home directory
cd ~/


# Create cache directory if it doesn't exist yet
if [ ! -d ~/dfd-crypto-ticker/cache ]; then
/usr/bin/mkdir -p ~/dfd-crypto-ticker/cache/json
/usr/bin/mkdir -p ~/dfd-crypto-ticker/cache/js
fi


# Current timestamp
CURRENT_TIMESTAMP=$(/usr/bin/date +%s)

# 1 day threshold (in seconds)
SECONDS_THRESHOLD=86400


# Kucoin cache update flag
if [ -f ~/dfd-crypto-ticker/cache/json/kucoin-auth.json ]; then

KUCOIN_LAST_MODIFIED=$(/usr/bin/date +%s -r ~/dfd-crypto-ticker/cache/json/kucoin-auth.json)

KUCOIN_THRESHOLD=$((KUCOIN_LAST_MODIFIED + SECONDS_THRESHOLD))

	if [ "$CURRENT_TIMESTAMP" -ge "$KUCOIN_THRESHOLD" ]; then
	UPDATE_KUCOIN=1
	fi

else
UPDATE_KUCOIN=1

fi


# If update flagged
if [ "$UPDATE_KUCOIN" == 1 ]; then

/usr/bin/curl -X POST https://api.kucoin.com/api/v1/bullet-public > ~/dfd-crypto-ticker/cache/json/kucoin-auth.json

/bin/sleep 3

# Write required Kucoin data to kucoin-auth.js
KUCOIN_TOKEN=$(/usr/bin/jq .data.token ~/dfd-crypto-ticker/cache/json/kucoin-auth.json)

KUCOIN_ENDPOINT=$(/usr/bin/jq .data.instanceServers[0].endpoint ~/dfd-crypto-ticker/cache/json/kucoin-auth.json)

# Don't nest / indent, or it could malform the settings            
read -r -d '' KUCOIN_JS <<- EOF
\r
var kucoin_token = $KUCOIN_TOKEN;
\r
var kucoin_endpoint = $KUCOIN_ENDPOINT;
\r
\r
EOF

					
echo -e "$KUCOIN_JS" > ~/dfd-crypto-ticker/cache/js/kucoin-auth.js

/bin/sleep 3

fi





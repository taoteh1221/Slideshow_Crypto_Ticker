#!/bin/bash

# Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				

# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


# Start in user home directory
cd /home/$TERMINAL_USERNAME


# Current timestamp
CURRENT_TIMESTAMP=$(/usr/bin/date +%s)


# Create cache directory if it doesn't exist yet
if [ ! -d ~/slideshow-crypto-ticker/cache ]; then
/usr/bin/mkdir -p ~/slideshow-crypto-ticker/cache
fi


# Check to see if the kucoin cache data needs to be updated
if [ -f ~/slideshow-crypto-ticker/cache/kucoin-auth.json ]; then

# 12 hours (in seconds) between cache refreshes
KUCOIN_REFRESH=43200

KUCOIN_LAST_MODIFIED=$(/usr/bin/date +%s -r ~/slideshow-crypto-ticker/cache/kucoin-auth.json)

KUCOIN_THRESHOLD=$((KUCOIN_LAST_MODIFIED + KUCOIN_REFRESH))

	if [ "$CURRENT_TIMESTAMP" -ge "$KUCOIN_THRESHOLD" ]; then
	UPDATE_KUCOIN=1
	fi

else
UPDATE_KUCOIN=1

fi


# If KUCOIN update flagged, cache new kucoin data to kucoin-auth.json, AND flag a JS CACHE update
if [ "$UPDATE_KUCOIN" == 1 ]; then

/usr/bin/curl -X POST https://api.kucoin.com/api/v1/bullet-public > ~/slideshow-crypto-ticker/cache/kucoin-auth.json

/bin/sleep 3

UPDATE_JS=1

fi


# If JS CACHE update flagged, ready all desired json cache vars for cache.js updating
if [ "$UPDATE_JS" == 1 ]; then


# Kucoin data
KUCOIN_TOKEN=$(/usr/bin/jq .data.token ~/slideshow-crypto-ticker/cache/kucoin-auth.json)

KUCOIN_ENDPOINT=$(/usr/bin/jq .data.instanceServers[0].endpoint ~/slideshow-crypto-ticker/cache/kucoin-auth.json)
    
    # Properly render the js
    if [ -z "$KUCOIN_TOKEN" ]; then
    KUCOIN_TOKEN=";"
    else
    KUCOIN_TOKEN=" = ${KUCOIN_TOKEN};"
    fi
    
    if [ -z "$KUCOIN_ENDPOINT" ]; then
    KUCOIN_ENDPOINT=";"
    else
    KUCOIN_ENDPOINT=" = ${KUCOIN_ENDPOINT};"
    fi


# Don't nest / indent, or it could malform the settings            
read -r -d '' JS_CACHE <<- EOF
\r
var kucoin_token$KUCOIN_TOKEN
\r
var kucoin_endpoint$KUCOIN_ENDPOINT
\r
\r
EOF


# Write to cache.js
echo -e "$JS_CACHE" > ~/slideshow-crypto-ticker/cache/cache.js

/bin/sleep 3

fi




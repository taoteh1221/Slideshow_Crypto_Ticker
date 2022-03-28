#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH


# Current timestamp
CURRENT_TIMESTAMP=$(date +%s)


# Check to see if the kucoin cache data needs to be updated
if [ -f ~/slideshow-crypto-ticker/cache/kucoin-auth.json ]; then

# 1 hour (in seconds) between cache refreshes
KUCOIN_REFRESH=3600

KUCOIN_LAST_MODIFIED=$(date +%s -r ~/slideshow-crypto-ticker/cache/kucoin-auth.json)

KUCOIN_THRESHOLD=$(($KUCOIN_LAST_MODIFIED + $KUCOIN_REFRESH))

	if [ "$CURRENT_TIMESTAMP" -ge "$KUCOIN_THRESHOLD" ]; then
	UPDATE_KUCOIN=1
	fi

else
UPDATE_KUCOIN=1

fi


# If KUCOIN update flagged, cache new kucoin data to kucoin-auth.json, AND flag a JS CACHE update
if [ "$UPDATE_KUCOIN" == 1 ]; then

curl -X POST https://api.kucoin.com/api/v1/bullet-public > ~/slideshow-crypto-ticker/cache/kucoin-auth.json

sleep 3

UPDATE_JS=1

fi


# If JS CACHE update flagged, ready all desired json cache vars for kucoin.js updating
if [ "$UPDATE_JS" == 1 ]; then


# Kucoin data
KUCOIN_TOKEN=$(jq .data.token ~/slideshow-crypto-ticker/cache/kucoin-auth.json)

KUCOIN_ENDPOINT=$(jq .data.instanceServers[0].endpoint ~/slideshow-crypto-ticker/cache/kucoin-auth.json)

KUCOIN_UPDATE_TIME=$(date +%s%N | cut -b1-13) # Javascript timestamping uses milliseconds
    
    
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
    
    if [ -z "$KUCOIN_UPDATE_TIME" ]; then
    KUCOIN_UPDATE_TIME=";"
    else
    KUCOIN_UPDATE_TIME=" = ${KUCOIN_UPDATE_TIME};"
    fi


# Don't nest / indent, or it could malform the settings            
read -r -d '' KUCOIN_CACHE <<- EOF
\r
var kucoin_token$KUCOIN_TOKEN
\r
var kucoin_endpoint$KUCOIN_ENDPOINT
\r
var kucoin_update_time$KUCOIN_UPDATE_TIME
\r
\r
EOF


# Write to kucoin.js
echo -e "$KUCOIN_CACHE" > ~/slideshow-crypto-ticker/cache/kucoin.js

/bin/sleep 3

fi




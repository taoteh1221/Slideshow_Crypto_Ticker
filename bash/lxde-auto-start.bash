#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# Give system time to boot
sleep 20
				
FIND_DISPLAY=$(w -h $USER | awk '$3 ~ /:[0-9.]*/{print $3}')

DISPLAY=$FIND_DISPLAY

export DISPLAY=$FIND_DISPLAY

xset s off

xset -dpms

xset s noblank

unclutter -idle 0.5 -root &


# Cache updating (MAKE SURE IT EXISTS BEFORE RUNNING THE TICKER)
bash ~/slideshow-crypto-ticker/bash/cron/cache.bash


sleep 2


DEFAULT_BROWSER=$(cat ~/slideshow-crypto-ticker/cache/default_browser.dat)
DEFAULT_BROWSER=$(echo "${DEFAULT_BROWSER}" | xargs) # Trim any whitespace
# If DEFAULT browser parameter wasn't set, use chromium
if [ -z "$DEFAULT_BROWSER" ]; then
DEFAULT_BROWSER="chromium"
fi


# If CLI browser parameter wasn't included, use default browser
if [ -z "$1" ]; then
SET_BROWSER=$DEFAULT_BROWSER
echo " "
echo "Browser not specified, using default browser ${DEFAULT_BROWSER}..."
echo " "
else

    if [ -f ~/slideshow-crypto-ticker/bash/browser-support/$1.bash ]; then
    SET_BROWSER=$1
    else
    SET_BROWSER=$DEFAULT_BROWSER
    echo " "
    echo "Browser '$1' not supported, falling back to default browser ${DEFAULT_BROWSER}..."
    echo " "
    fi
    
fi


# Browser running logic
bash ~/slideshow-crypto-ticker/bash/browser-support/$SET_BROWSER.bash



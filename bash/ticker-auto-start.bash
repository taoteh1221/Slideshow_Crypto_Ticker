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


# If explicit browser parameter wasn't included, use default browser
if [ -z "$1" ]; then
SET_BROWSER="chromium"
else

    if [ -f ~/slideshow-crypto-ticker/bash/browser-support/$1.bash ]; then
    SET_BROWSER=$1
    else
    SET_BROWSER="chromium"
    fi
    
fi


# Browser running logic
bash ~/slideshow-crypto-ticker/bash/browser-support/$SET_BROWSER.bash



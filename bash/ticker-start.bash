#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				
				
FIND_DISPLAY=$(w -h $USER | awk '$3 ~ /:[0-9.]*/{print $3}')

DISPLAY=$FIND_DISPLAY

export DISPLAY=$FIND_DISPLAY


###################################


# Start in user home directory
cd /home/$USER

xset s off

xset -dpms

xset s noblank

unclutter -idle 0.5 -root &


# Cache updating (MAKE SURE IT EXISTS BEFORE RUNNING THE TICKER)
~/slideshow-crypto-ticker/bash/cron/cache.bash


sleep 2

				
if [ -f /home/$USER/slideshow-crypto-ticker/cache/browser.bash ]; then
~/slideshow-crypto-ticker/cache/browser.bash
fi


# If default browser wasn't set, set as firefox
if [ -z "$DEFAULT_BROWSER" ]; then
DEFAULT_BROWSER="firefox"
fi


# If explicit browser parameter wasn't included, use default browser
if [ -z "$1" ]; then
SET_BROWSER=$DEFAULT_BROWSER
else
SET_BROWSER=$1
fi


# Browser running logic
~/slideshow-crypto-ticker/bash/$SET_BROWSER.bash &>/dev/null &



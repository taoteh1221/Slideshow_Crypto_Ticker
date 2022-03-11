#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				
				
FIND_DISPLAY=$(w -h $USER | awk '$3 ~ /:[0-9.]*/{print $3}')

DISPLAY=$FIND_DISPLAY

export DISPLAY=$FIND_DISPLAY

# Start in user home directory
cd /home/$USER


# Firefox's FULL PATH
FIREFOX_PATH=$(which firefox-esr)

# If 'firefox-esr' wasn't found, look for 'firefox'
if [ -z "$FIREFOX_PATH" ]
then
FIREFOX_PATH=$(which firefox)
fi

# Enable graphics acceleration
export MOZ_ACCELERATED=1

# kiosk mode (for UX)
$FIREFOX_PATH --kiosk -private -new-tab ~/slideshow-crypto-ticker/index.html


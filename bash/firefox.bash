#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				

# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


# Start in user home directory
cd /home/$TERMINAL_USERNAME


# Firefox's FULL PATH
FIREFOX_PATH=$(which firefox-esr)

# If 'firefox-esr' wasn't found, look for 'firefox'
if [ -z "$FIREFOX_PATH" ]
then
FIREFOX_PATH=$(which firefox)
fi


# kiosk mode (for UX)
$FIREFOX_PATH --kiosk -new-tab ~/slideshow-crypto-ticker/index.html


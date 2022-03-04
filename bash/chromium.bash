#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				

# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


# Start in user home directory
cd /home/$TERMINAL_USERNAME


# Chromium's FULL PATH
CHROMIUM_PATH=$(which chromium)

# If 'chromium' wasn't found, look for 'chromium-browser'
if [ -z "$CHROMIUM_PATH" ]
then
CHROMIUM_PATH=$(which chromium-browser)
fi


# Incognito mode doesn't prompt to restore previous session, yay
# We also set it to not check for upgrades for 7 days (SETTING TO ZERO DOES NOT WORK), 
# to avoid the upgrade prompt popup on non-touch screens (for UX)
$CHROMIUM_PATH --check-for-update-interval=604800 --noerrdialogs --disable-infobars --incognito --kiosk ~/slideshow-crypto-ticker/index.html &>/dev/null &


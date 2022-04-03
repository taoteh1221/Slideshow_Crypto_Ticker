#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com

				
FIND_DISPLAY=$(w -h $USER | awk '$3 ~ /:[0-9.]*/{print $3}')

DISPLAY=$FIND_DISPLAY

export DISPLAY=$FIND_DISPLAY

# Chromium's FULL PATH
CHROMIUM_PATH=$(which chromium)

# If 'chromium' wasn't found, look for 'chromium-browser'
if [ -z "$CHROMIUM_PATH" ]; then
CHROMIUM_PATH=$(which chromium-browser)
fi

# Incognito mode doesn't prompt to restore previous session, yay
# We also set it to not check for upgrades for 7 days (SETTING TO ZERO DOES NOT WORK), 
# to avoid the upgrade prompt popup (for UX on raspberry pi devices)
$CHROMIUM_PATH --check-for-update-interval=604800 --noerrors --noerrdialogs --disable-restore-session-state --disable-session-crashed-bubble --disable-infobars --incognito --kiosk $HOME/slideshow-crypto-ticker/index.html


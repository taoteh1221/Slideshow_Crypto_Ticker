#!/bin/bash

# Copyright 2019-2024 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com (leave this copyright / attribution intact in ALL forks / copies!)
		
# Chromium's FULL PATH
CHROMIUM_PATH=$(which chromium)

# If 'chromium' wasn't found, look for 'chromium-browser'
if [ -z "$CHROMIUM_PATH" ]; then
CHROMIUM_PATH=$(which chromium-browser)
fi

# Incognito mode doesn't prompt to restore previous session, yay
# We also set it to not check for upgrades for 7 days (SETTING TO ZERO DOES NOT WORK), 
# to avoid the upgrade prompt popup (for UX on raspberry pi devices)
# USE #FULL# PATH TO AVOID POSSIBLE BUGS IN BROWSER!
$CHROMIUM_PATH --check-for-update-interval=604800 --noerrors --noerrdialogs --disable-restore-session-state --disable-session-crashed-bubble --disable-infobars --incognito --kiosk $HOME/slideshow-crypto-ticker/index.html


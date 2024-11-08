#!/bin/bash

# Copyright 2019-2024 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com (leave this copyright / attribution intact in ALL forks / copies!)
			
# Firefox's FULL PATH
FIREFOX_PATH=$(which firefox-esr)

# If 'firefox-esr' wasn't found, look for 'firefox'
if [ -z "$FIREFOX_PATH" ]; then
FIREFOX_PATH=$(which firefox)
fi

# Enable graphics acceleration
export MOZ_ACCELERATED=1

# kiosk / private mode (for UX on crashes / restarts / etc)
# USE #FULL# PATH TO AVOID POSSIBLE BUGS IN BROWSER!
$FIREFOX_PATH --kiosk -private -new-tab $HOME/slideshow-crypto-ticker/index.html


#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				

# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


export DISPLAY=:0 


###################################


# Start in user home directory
cd /home/$TERMINAL_USERNAME

xset s off

xset -dpms

xset s noblank

unclutter -idle 0.5 -root &


# Cache updating (MAKE SURE IT EXISTS BEFORE RUNNING THE TICKER)
~/slideshow-crypto-ticker/bash/cron/cache.bash


# Remove crash notices (for UX)
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences


sleep 2


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
$CHROMIUM_PATH --check-for-update-interval=604800 --noerrdialogs --disable-infobars --incognito --kiosk ~/slideshow-crypto-ticker/index.html




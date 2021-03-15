#!/bin/bash

# Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com

export DISPLAY=:0 

###################################

# Start in user home directory
cd ~/


/usr/bin/xset s off

/usr/bin/xset -dpms

/usr/bin/xset s noblank

/usr/bin/unclutter -idle 0.5 -root &


# Kucoin auth cache updating (MAKE SURE IT EXISTS BEFORE RUNNING THE TICKER)
~/dfd-crypto-ticker/bash/cron/kucoin-auth.bash


/bin/sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences
/bin/sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences



sleep 2

# Incognito mode doesn't prompt to restore previous session, yay
# We also set it to not check for upgrades for 7 days (SETTING TO ZERO DOES NOT WORK), to avoid the upgrade prompt popup
/usr/bin/chromium-browser --check-for-update-interval=604800 --noerrdialogs --disable-infobars --incognito --kiosk ~/dfd-crypto-ticker/index.html




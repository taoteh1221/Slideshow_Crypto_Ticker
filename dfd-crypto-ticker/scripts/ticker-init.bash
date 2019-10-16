#!/bin/bash

export DISPLAY=:0 

###################################

# Reliably set working directory to .../dfd-crypto-ticker/... under any home directory username
cd "$(dirname "$0")"
cd ../


/usr/bin/xset s off

/usr/bin/xset -dpms

/usr/bin/xset s noblank

/usr/bin/unclutter -idle 0.5 -root &


/bin/sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/Default/Preferences
/bin/sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences



sleep 2

#incognito mode doesn't prompt to restore previous session, yay
/usr/bin/chromium-browser --noerrdialogs --disable-infobars --incognito --kiosk ~/dfd-crypto-ticker/apps/ticker/index.html




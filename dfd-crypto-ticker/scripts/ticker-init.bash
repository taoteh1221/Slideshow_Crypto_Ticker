#!/bin/bash

# Device scale setting, adjust to fit your screen size ("1.00" is for 3.5" LCD screens)
DEVICE_SCALE="1.00"

###################################

# Reliably set working directory to .../dfd-crypto-ticker/... under any home directory username
cd "$(dirname "$0")"
cd ../

export DISPLAY=:0 

/usr/bin/xset s off

/usr/bin/xset -dpms

/usr/bin/xset s noblank

/usr/bin/unclutter -idle 0

#incognito mode doesn't prompt to restore previous session, yay
/usr/bin/chromium-browser ./apps/ticker/index.html --start-fullscreen --incognito --force-device-scale-factor=$DEVICE_SCALE


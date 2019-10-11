#!/bin/bash

# Device scale setting, adjust to fit your screen size ("1.00" is for 3.5" LCD screens)
DEVICE_SCALE="1.00"

export DISPLAY=:0  

/usr/bin/chromium-browser /home/pi/dfd-crypto-ticker/apps/ticker/index.html --force-device-scale-factor=$DEVICE_SCALE --start-fullscreen

/usr/bin/xdotool key F11


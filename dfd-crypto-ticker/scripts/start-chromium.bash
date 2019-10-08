#!/bin/bash

DISPLAY=:0 /usr/bin/chromium-browser /home/pi/dfd-crypto-ticker/apps/ticker/index.html --force-device-scale-factor=1.00 --start-fullscreen
sleep 25
/usr/bin/xdotool key F11


#!/bin/bash

export DISPLAY=:0 

/usr/bin/xset s off

/usr/bin/xset -dpms

/usr/bin/xset s noblank

/usr/bin/unclutter -idle 0

/bin/bash /home/pi/dfd-crypto-ticker/scripts/start-chromium.bash &


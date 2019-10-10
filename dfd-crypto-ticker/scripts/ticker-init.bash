#!/bin/bash

export DISPLAY=:0 

/usr/bin/xset s off

/usr/bin/xset -dpms

/usr/bin/xset s noblank

/bin/bash /home/pi/dfd-crypto-ticker/scripts/start-chromium.bash &

/usr/bin/unclutter -idle 0


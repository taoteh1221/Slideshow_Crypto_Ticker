#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com

				
FIND_DISPLAY=$(w -h $USER | awk '$3 ~ /:[0-9.]*/{print $3}')

DISPLAY=$FIND_DISPLAY

export DISPLAY=$FIND_DISPLAY

# No fullscreen flag, AND -a for kiosk mode CRASHES WITH SEGFAULT, 
# so we use xte AFTER midori starts to toggle fullscreen with F11
# USE #FULL# PATH TO AVOID POSSIBLE BUGS IN BROWSER!
midori $HOME/slideshow-crypto-ticker/index.html --display=$FIND_DISPLAY &
sleep 15
xte "key F11" -x$FIND_DISPLAY


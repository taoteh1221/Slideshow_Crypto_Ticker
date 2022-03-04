#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH


export DISPLAY=:0


# chromium
WID=$(xdotool search --onlyvisible --class chromium|head -1)
xdotool windowactivate ${WID}
xdotool key ctrl+F5

# firefox
WID=$(xdotool search --onlyvisible --class firefox|head -1)
xdotool windowactivate ${WID}
xdotool key ctrl+F5
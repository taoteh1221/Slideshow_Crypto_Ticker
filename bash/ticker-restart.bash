#!/bin/bash

# Copyright 2019-2023 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


FIND_DISPLAY=$(w -h $USER | awk '$3 ~ /:[0-9.]*/{print $3}')

DISPLAY=$FIND_DISPLAY

export DISPLAY=$FIND_DISPLAY


# firefox is stubborn at refreshing JS
rm -rf ~/.cache/mozilla/firefox/*
sleep 1

# chromium / epiphany / firefox refresh
xdotool key F5
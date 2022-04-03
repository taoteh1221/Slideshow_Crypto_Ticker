#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


FIND_DISPLAY=$(w -h $USER | awk '$3 ~ /:[0-9.]*/{print $3}')

DISPLAY=$FIND_DISPLAY

export DISPLAY=$FIND_DISPLAY


# firefox
rm -rf ~/.cache/mozilla/firefox/*
# midori
rm -rf ~/.cache/midori/*
sleep 1

# midori / epiphany / chromium / firefox
xdotool key F5
#!/bin/bash

# Copyright 2019-2021 GPLv3, DFD Crypto Ticker by Mike Kilday: http://DragonFrugal.com


export DISPLAY=:0

WID=$(xdotool search --onlyvisible --class chromium|head -1)
xdotool windowactivate ${WID}
xdotool key ctrl+F5

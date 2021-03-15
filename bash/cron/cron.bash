#!/bin/bash

# Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# Start in user home directory
cd ~/


# Keep screensaver off
~/dfd-crypto-ticker/bash/cron/keep-screensaver-off.bash


#################################################################
# Update cache files if they don't exist , or are stale
#################################################################


# Kucoin auth cache updating
~/dfd-crypto-ticker/bash/cron/kucoin-auth.bash


#################################################################
# END update cache files
#################################################################




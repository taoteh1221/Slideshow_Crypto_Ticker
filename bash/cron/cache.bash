#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				

# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


# Start in user home directory
cd /home/$TERMINAL_USERNAME


# Current timestamp
CURRENT_TIMESTAMP=$(/usr/bin/date +%s)


# Create cache directory if it doesn't exist yet
if [ ! -d ~/slideshow-crypto-ticker/cache ]; then
/usr/bin/mkdir -p ~/slideshow-crypto-ticker/cache
fi


# Kucoin updating
~/slideshow-crypto-ticker/bash/cron/kucoin.bash


# Raspi temps updating
~/slideshow-crypto-ticker/bash/cron/system-info.bash



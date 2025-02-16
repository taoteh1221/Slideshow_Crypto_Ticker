#!/bin/bash

# Copyright 2019-2025 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com (leave this copyright / attribution intact in ALL forks / copies!)

# Authentication of X sessions
export XAUTHORITY=~/.Xauthority 


# EXPLICITLY set any dietpi paths 
# Export too, in case we are calling another bash instance in this script
if [ -f /boot/dietpi/.version ]; then
PATH=/boot/dietpi:$PATH
export PATH=$PATH
fi

# EXPLICITLY set any ~/.local/bin paths
# Export too, in case we are calling another bash instance in this script
if [ -d ~/.local/bin ]; then
PATH=~/.local/bin:$PATH
export PATH=$PATH
fi
				

# EXPLICITLY set any /usr/sbin path
# Export too, in case we are calling another bash instance in this script
if [ -d /usr/sbin ]; then
PATH=/usr/sbin:$PATH
export PATH=$PATH
fi


# Cache updating (MAKE SURE IT EXISTS BEFORE RUNNING THE TICKER)
bash ~/slideshow-crypto-ticker/bash/cron/cache.bash

sleep 2

DEFAULT_BROWSER=$(cat ~/slideshow-crypto-ticker/cache/default_browser.dat)
DEFAULT_BROWSER=$(echo "${DEFAULT_BROWSER}" | xargs) # Trim any whitespace


# If DEFAULT browser parameter wasn't set, use firefox
if [ -z "$DEFAULT_BROWSER" ]; then
DEFAULT_BROWSER="firefox"
fi


# If CLI browser parameter wasn't included, use default browser
if [ -z "$1" ]; then
SET_BROWSER=$DEFAULT_BROWSER
echo " "
echo "Browser not specified, using default browser ${SET_BROWSER}..."
echo " "
else

    if [ -f ~/slideshow-crypto-ticker/bash/browser-support/$1.bash ]; then
    SET_BROWSER=$1
    echo " "
    echo "Using browser '$SET_BROWSER'..."
    echo " "
    else
    SET_BROWSER=$DEFAULT_BROWSER
    echo " "
    echo "Browser '$1' not supported, falling back to default browser ${SET_BROWSER}..."
    echo " "
    fi
    
fi


# Browser running logic
bash ~/slideshow-crypto-ticker/bash/browser-support/$SET_BROWSER.bash &>/dev/null &



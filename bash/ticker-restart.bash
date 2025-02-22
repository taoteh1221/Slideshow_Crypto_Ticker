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


# Are we using wayland display manager?
RUNNING_WAYLAND=$(loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type | grep -i wayland)

# Are we using x11 display manager?
RUNNING_X11=$(loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type | grep -i x11)

# firefox is stubborn at refreshing JS
rm -rf ~/.cache/mozilla/firefox/*
sleep 1

# chromium / epiphany / firefox refresh
# X11
if [ "$RUNNING_X11" != "" ]; then

FIND_DISPLAY=$(cat -e "/proc/$$/environ" | sed 's/\^@/\n/g' | grep DISPLAY | sed 's/.*=\(.*\).*/\1/')


     # If DISPLAY parameter wasn't set, try systemd environment check
     if [ -z "$FIND_DISPLAY" ]; then
     FIND_DISPLAY=$(systemctl --user show-environment | grep DISPLAY | sed 's/.*=\(.*\).*/\1/')
     fi
     
     
     # If DISPLAY parameter STILL wasn't set, use :0 (DEFAULT for 1st display)
     if [ -z "$FIND_DISPLAY" ]; then
     FIND_DISPLAY=":0"
     fi


DISPLAY=$FIND_DISPLAY

export DISPLAY=$FIND_DISPLAY

xdotool type F5

# NON-X11
else

~/ticker-stop

sleep 1


# If CLI browser parameter wasn't included, use default browser
if [ "$1" != "" ] && [ -f ~/slideshow-crypto-ticker/bash/browser-support/$1.bash ]; then
SET_BROWSER=$1
fi


~/ticker-start $SET_BROWSER

fi


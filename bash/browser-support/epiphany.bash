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

# Are we using wayland display manager?
RUNNING_WAYLAND=$(loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type | grep -i wayland)

# Are we using x11 display manager?
RUNNING_X11=$(loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type | grep -i x11)


if [ "$RUNNING_X11" != "" ]; then

xset s off

xset -dpms

xset s noblank

fi

				
# Create epiphany user directory if it doesn't exist yet
if [ ! -d ~/.config/epiphany ]; then
mkdir -p ~/.config/epiphany
fi


# epiphany's FULL PATH
EPIPHANY_PATH=$(which epiphany)


# If 'epiphany' wasn't found, look for 'epiphany-browser'
if [ -z "$EPIPHANY_PATH" ]; then
EPIPHANY_PATH=$(which epiphany-browser)
fi


# Reduce crashes
export WEBKIT_DISABLE_TBS=1

# kiosk / private mode (for UX on crashes / restarts / etc)
# --profile needed if FIRST RUN, OTHERWISE IT WON'T START!
# No fullscreen flag, AND -a for kiosk mode doesn't go fullscreen, 
# so we use xte AFTER epiphany starts to toggle fullscreen with F11
# USE #FULL# PATH TO AVOID POSSIBLE BUGS IN BROWSER!
$EPIPHANY_PATH -a -i --profile ~/.config/epiphany $HOME/slideshow-crypto-ticker/index.html &


# Epiphany does NOT seem to have a fullscreen command,
# BUT we can only virtually type F11 (for fullscreen) on x11
if [ "$RUNNING_X11" != "" ]; then
sleep 30
xdotool key F11
fi


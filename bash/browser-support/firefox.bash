#!/bin/bash

# Copyright 2019-2025 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com (leave this copyright / attribution intact in ALL forks / copies!)

# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


# If logname doesn't work, use the $SUDO_USER or $USER global var
if [ -z "$TERMINAL_USERNAME" ]; then

    if [ -z "$SUDO_USER" ]; then
    TERMINAL_USERNAME=$USER
    else
    TERMINAL_USERNAME=$SUDO_USER
    fi

fi


# Find out what display manager is being used on the PHYSICAL display
DISPLAY_SESSION=$(loginctl show-user "$TERMINAL_USERNAME" -p Display --value)
DISPLAY_SESSION=$(echo "${DISPLAY_SESSION}" | xargs) # trim whitespace

# Display type
DISPLAY_TYPE=$(loginctl show-session "$DISPLAY_SESSION" -p Type)

# Are we using x11 display manager?
RUNNING_X11=$(echo "$DISPLAY_TYPE" | grep -i x11)

# Are we using wayland display manager?
RUNNING_WAYLAND=$(echo "$DISPLAY_TYPE" | grep -i wayland)


if [ "$RUNNING_X11" != "" ]; then

xset s off

xset -dpms

xset s noblank

fi

			
# Firefox's FULL PATH
FIREFOX_PATH=$(which firefox-esr)


# If 'firefox-esr' wasn't found, look for 'firefox'
if [ -z "$FIREFOX_PATH" ]; then
FIREFOX_PATH=$(which firefox)
fi


# Enable graphics acceleration
export MOZ_ACCELERATED=1

# kiosk / private mode (for UX on crashes / restarts / etc)
# USE #FULL# PATH TO AVOID POSSIBLE BUGS IN BROWSER!
$FIREFOX_PATH --kiosk -private -new-tab $HOME/slideshow-crypto-ticker/index.html


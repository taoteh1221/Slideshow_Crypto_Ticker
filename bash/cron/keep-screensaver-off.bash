#!/bin/bash

# Copyright 2019-2025 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com (leave this copyright / attribution intact in ALL forks / copies!)

FIND_DISPLAY=$(cat -e "/proc/$$/environ" | sed 's/\^@/\n/g' | grep DISPLAY | sed 's/.*=\(.*\).*/\1/')


# If DISPLAY parameter wasn't set, try systemd environment check
if [ -z "$FIND_DISPLAY" ]; then
FIND_DISPLAY=$(systemctl --user show-environment | grep DISPLAY | sed 's/.*=\(.*\).*/\1/')
fi


# If DISPLAY parameter STILL wasn't set, use :0 (DEFAULT for 1st display)
if [ -z "$FIND_DISPLAY" ]; then
FIND_DISPLAY=":0"
fi


# Only use first result (space-delimited)
FIND_DISPLAY=${FIND_DISPLAY%%[[:space:]]*}

DISPLAY=$FIND_DISPLAY

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


# Virtually type the ctrl key (ONLY WORKS ON X11!)
if [ "$RUNNING_X11" != "" ]; then
xdotool key ctrl
fi


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


# Suppress default browser startup dialogue
gsettings set org.gnome.Epiphany ask-for-default false

sleep 1

# Force fullscreen
gsettings set org.gnome.Epiphany.lockdown disable-fullscreen

sleep 1

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


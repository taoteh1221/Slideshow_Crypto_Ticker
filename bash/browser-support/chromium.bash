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

				
# In case user changed the hostname, just blow away singleton data in the cache
# (OTHERWISE CHROMIUM WON'T START!)
# https://github.com/puppeteer/puppeteer/issues/4860
if [ -d ~/.config/chromium ]; then
rm -rf ~/.config/chromium/Singleton*
fi


# Chromium's FULL PATH
CHROMIUM_PATH=$(which chromium)


# If 'chromium' wasn't found, look for 'chromium-browser'
if [ -z "$CHROMIUM_PATH" ]; then
CHROMIUM_PATH=$(which chromium-browser)
fi


# Incognito mode doesn't prompt to restore previous session, yay
# Basic password storage prevents any startup dialog related to creating / opening a keyring
# We also set it to not check for upgrades for 7 days (SETTING TO ZERO DOES NOT WORK), 
# to avoid the upgrade prompt popup (for UX on raspberry pi devices)
# USE #FULL# PATH TO AVOID POSSIBLE BUGS IN BROWSER!
$CHROMIUM_PATH --check-for-update-interval=604800 --password-store=basic --noerrors --noerrdialogs --disable-restore-session-state --disable-session-crashed-bubble --disable-infobars --incognito --kiosk $HOME/slideshow-crypto-ticker/index.html


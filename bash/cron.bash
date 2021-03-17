#!/bin/bash

# Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


USERNAME=$(/usr/bin/logname)


# Start in user home directory
cd /home/$USERNAME


# Keep screensaver off
~/dfd-crypto-ticker/bash/cron/keep-screensaver-off.bash


# Cache updating
~/dfd-crypto-ticker/bash/cron/cache.bash


#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				

# Start in user home directory
cd /home/$USER


# Keep screensaver off
~/slideshow-crypto-ticker/bash/cron/keep-screensaver-off.bash


# Cache updating
~/slideshow-crypto-ticker/bash/cron/cache.bash


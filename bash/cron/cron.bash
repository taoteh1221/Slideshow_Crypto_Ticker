#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


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



# Cache updating
bash ~/slideshow-crypto-ticker/bash/cron/cache.bash


# Keep screensaver off
bash ~/slideshow-crypto-ticker/bash/cron/keep-screensaver-off.bash

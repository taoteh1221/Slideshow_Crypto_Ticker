#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com


export PATH=$PATH


# Create cache directory if it doesn't exist yet
if [ ! -d ~/slideshow-crypto-ticker/cache ]; then
/usr/bin/mkdir -p ~/slideshow-crypto-ticker/cache
fi


# Kucoin updating
bash ~/slideshow-crypto-ticker/bash/cron/kucoin.bash


# Raspi temps updating
bash ~/slideshow-crypto-ticker/bash/cron/system-info.bash



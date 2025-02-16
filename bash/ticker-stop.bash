#!/bin/bash

# Copyright 2019-2025 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com (leave this copyright / attribution intact in ALL forks / copies!)


pkill -o chromium > /dev/null 2>&1
pkill -o chrome > /dev/null 2>&1
pkill -o epiphany > /dev/null 2>&1
pkill -o firefox > /dev/null 2>&1

# Assure we cleanly exit, since we are killing the process anyway
exit
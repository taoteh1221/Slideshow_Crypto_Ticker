#!/bin/bash

# Copyright 2019-2021 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com

echo "THIS SCRIPT CURRENTLY ONLY SUPPORTS \"goodtft LCD-show\" LCDs! Enter your model number to continue (example: MHS35)"

read MODEL

echo "Select 1 or 2 to choose witch display to boot into. Type 3 to Skip"

OPTIONS="hdmi lcd-$MODEL"

select opt in $OPTIONS; do
        if [ "$opt" = "hdmi" ]; then
        cd ~/goodtft/builds/LCD-show
	sudo ./LCD-hdmi
        break
       elif [ "$opt" = "lcd-$MODEL" ]; then
        cd ~/goodtft/builds/LCD-show
	sudo ./$MODEL-show
        break
       else
        echo "Skipping display switch..."
        break
       fi
done

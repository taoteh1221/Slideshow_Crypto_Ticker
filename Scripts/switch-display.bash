#!/bin/bash

echo "This script currently only supports \"goodtft LCD-show\" LCDs. Enter your model number to continue (example: MHS35)"

read MODEL

echo "Select 1 or 2 to choose witch display to boot into. Type 3 to Skip"

OPTIONS="hdmi lcd-$MODEL"

select opt in $OPTIONS; do
        if [ "$opt" = "hdmi" ]; then
        cd ~/Builds/LCD-show
	sudo ./LCD-hdmi
        break
       elif [ "$opt" = "lcd-$MODEL" ]; then
        cd ~/Builds/LCD-show
	sudo ./$MODEL-show
        break
       else
        echo "Thanks"
        break
       fi
done

#!/bin/bash

# Copyright 2019-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com
#Attribution: https://peterries.net/blog/displaying-pi-temp/

# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH
				

# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


# Start in user home directory
cd /home/$TERMINAL_USERNAME


# Current timestamp
CURRENT_TIMESTAMP=$(/usr/bin/date +%s)
				

# get the CPU temp in Celsius as a number

cpu=$(</sys/class/thermal/thermal_zone0/temp)

# convert the cpu temp to Fahr.

far=$(echo - | awk -v cpu=$cpu '{print cpu / 1000 * 9 / 5 + 32}')

# round that number to at most two decimals

far2=$(echo - | awk -v f=$far '{print int(f * 100) / 100}')

# convert the cpu temp number

cel=$(echo - | awk -v cpu=$cpu '{print cpu / 1000}')

# round that number to at most two decimals

cel2=$(echo - | awk -v c=$cel '{print int(c * 100) / 100}')
    
    
    # Properly render the js
    if [ -z "$cel2" ]; then
    cel2=";"
    else
    cel2=" = ${cel2};"
    fi
    
    if [ -z "$far2" ]; then
    far2=";"
    else
    far2=" = ${far2};"
    fi


# Don't nest / indent, or it could malform the settings            
read -r -d '' RASPI_DATA <<- EOF
\r
var cel2$cel2
\r
var far2$far2
\r
\$("#raspi_data").css({ "display": "block" });
\$("#raspi_data").html('CPU: ' + cel2 + '°C (' + far2 + '°F)').css("color", "#FFFF00");
\r
\r
EOF


# Write to raspi_data.js
echo -e "$RASPI_DATA" > ~/slideshow-crypto-ticker/cache/raspi_data.js

/bin/sleep 3




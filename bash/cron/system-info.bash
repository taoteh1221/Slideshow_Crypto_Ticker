#!/bin/bash

# Copyright 2019-2023 GPLv3, Slideshow Crypto Ticker by Mike Kilday: http://DragonFrugal.com
#Attribution: https://peterries.net/blog/displaying-pi-temp/

# Percentage of system memory used
memory_used_percent=$(echo - | free | grep Mem | awk '{print $3/$2 * 100.0}')

# round that number to at most two decimals

memory_used_percent2=$(echo - | awk -v m=$memory_used_percent '{print int(m * 100) / 100}')
				

# get the CPU temp in Celsius as a number

cpu=$(</sys/class/thermal/thermal_zone0/temp)

# convert the cpu temp number

cel=$(echo - | awk -v cpu=$cpu '{print cpu / 1000}')

# round that number to at most two decimals

cel2=$(echo - | awk -v c=$cel '{print int(c * 100) / 100}')
    
    
    # Properly render the js    
    if [ -z "$memory_used_percent2" ]; then
    memory_used_percent2=";"
    else
    memory_used_percent2=" = ${memory_used_percent2};"
    fi
    
    if [ -z "$cel2" ]; then
    cel2=";"
    else
    cel2=" = ${cel2};"
    fi


# Don't nest / indent, or it could malform the settings            
read -r -d '' RASPI_DATA <<- EOF
\r
var memory_used_percent2$memory_used_percent2
\r
var cel2$cel2
\r
\$("#system_data").css({ "display": "block" });
\$("#system_data").html('CPU: ' + cel2 + '°C, Memory: ' + memory_used_percent2 + '%');
\r
\r
EOF


# Write to system-info.js
echo -e "$RASPI_DATA" > ~/slideshow-crypto-ticker/cache/system-info.js

/bin/sleep 3





DFD Crypto Ticker - Developed by Michael Kilday <mike@dragonfrugal.com>, released free / open source (under GPL v3)

Copyright 2019 GPLv3

Real Time Crypto Price Ticker For Raspberry Pis With LCD Screens, including 24 hour volume and full Coinbase Pro support (more exchanges coming in the future).

Supports all Coinbase Pro markets, and can run in "slideshow mode", to show all the markets you want.

Example on a 3.5" LCD: https://www.youtube.com/watch?v=0TDnpYrGnOg

Developed on a Raspi v2 B+, with this screen / case: https://smile.amazon.com/gp/product/B07N38B86S/

Download Latest Version: https://github.com/taoteh1221/DFD_Crypto_Ticker/releases


#############################################################################################


To install / upgrade everything automatically on a Raspberry Pi (an affordable low power single board computer), copy / paste / run the command below in a terminal program while logged in on the Raspberry Pi:


wget -O RASPI-INSTALL.bash https://git.io/JenUe;chmod +x RASPI-INSTALL.bash;sudo ./RASPI-INSTALL.bash


Follow the prompts. This automated script will install and configure the app.


After installation, edit the following file in a text editor to switch between the different Coinbase Pro crypto assets and their paired markets: 

/home/pi/dfd-crypto-ticker/apps/ticker/config.js


You may need to adjust the initial chromium web browser scale size if your screen is NOT 3.5". This can be edited with a text editor in:
/home/pi/dfd-crypto-ticker/scripts/start-chromium.bash


If you have a "goodtft LCD-show" device and you auto-installed it's drivers during installation, you can switch between the LCD and your normal monitor by running the command:

./display


#############################################################################################


MANUAL CONFIGURATION (IF AUTO-INSTALL SCRIPT FAILS)...


Upload the 'dfd-crypto-ticker' directory in the download archive into /home/pi/ on your raspberry pi.


Run these commands:

sudo apt update && sudo apt upgrade

sudo apt install xdotool unclutter

chmod -R 755 /home/pi/dfd-crypto-ticker/scripts

ln -s /home/pi/dfd-crypto-ticker/scripts/switch-display.bash ~/display


Edit the following file: /home/pi/.config/lxsession/LXDE-pi/autostart and add the following lines:

@xset s off
@xset -dpms
@xset s noblank
# start chromium
@/bin/bash /home/pi//home/pi/dfd-crypto-ticker/scripts/start-chromium.bash &
# hide cursor
@unclutter -idle 0


Add this as a cron job every minute:

* * * * * /bin/bash /home/pi//home/pi/dfd-crypto-ticker/scripts/keep.screensaver.off.bash > /dev/null 2>&1


## ONLY RUN BELOW COMMANDS IF YOU HAVE A "goodtft LCD-show" LCD screen:

sudo apt update && sudo apt upgrade

sudo apt install git

cd /home/pi/dfd-crypto-ticker/builds

git clone https://github.com/goodtft/LCD-show.git

cd ~/

chmod -R 755 /home/pi/dfd-crypto-ticker/builds



#############################################################################################
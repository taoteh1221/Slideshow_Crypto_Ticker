
DFD Crypto Ticker - Developed by Michael Kilday <mike@dragonfrugal.com>, released free / open source (under GPL v3)

Copyright 2019 GPLv3

Real Time Crypto Price Ticker For Raspberry Pis With LCD Screens, including 24 hour volume and full Coinbase Pro support (more exchanges coming in the future).

Supports all Coinbase Pro markets, and can run in "slideshow mode", to show all the markets you want.

Example on a 3.5" LCD: https://www.youtube.com/watch?v=jyd_BYfUjUg

Developed on a Raspi v2 B+, with this screen / case: https://smile.amazon.com/gp/product/B07N38B86S/

Download Latest Version: https://github.com/taoteh1221/DFD_Crypto_Ticker/releases


#############################################################################################


AUTOMATIC INSTALLATION


To install / upgrade everything automatically on a Raspberry Pi (an affordable low power single board computer), copy / paste / run the command below in a terminal program while logged in on the Raspberry Pi:


wget -O TICKER-RASPI-INSTALL.bash https://git.io/JeWmm;chmod +x TICKER-RASPI-INSTALL.bash;sudo ./TICKER-RASPI-INSTALL.bash


Follow the prompts, and the automated script will install the ticker (rebooting after install will run the ticker at startup automatically).


#############################################################################################


CONFIGURING AFTER INSTALLATION


Edit the following file in a text editor to switch between the different Coinbase Pro crypto assets and their paired markets: 

/home/pi/dfd-crypto-ticker/apps/ticker/config.js


Example editing config.js in nano by command-line:

nano ~/dfd-crypto-ticker/apps/ticker/config.js


After updating config.js, reload the ticker with this command:

cd ~/;./reload


You may need to adjust the initial chromium web browser scale size if your screen is NOT 3.5". This can be edited with a text editor in:
/home/pi/dfd-crypto-ticker/scripts/start-chromium.bash


If you have a "goodtft LCD-show" LCD screen and you installed it's drivers, you can now switch between the LCD and your normal monitor by running the command:

cd ~/;./display


#############################################################################################



MANUAL INSTALLATION (IF AUTO-INSTALL SCRIPT FAILS, ETC)...



Upload the 'dfd-crypto-ticker' directory in the download archive into /home/pi/ on your raspberry pi.



Run these commands (logged in as user pi):

sudo apt update && sudo apt upgrade

sudo apt install xdotool unclutter -y

chmod -R 755 ~/dfd-crypto-ticker/scripts

ln -s ~/dfd-crypto-ticker/scripts/chromium-refresh.bash ~/reload



Create / edit the following file: /home/pi/.config/lxsession/LXDE-pi/autostart and add the following lines:

@xset s off
@xset -dpms
@xset s noblank
@/bin/bash /home/pi/dfd-crypto-ticker/scripts/start-chromium.bash &
@unclutter -idle 0



Add this as a cron job every minute, by creating the following file (you'll need sudo permissions): /etc/cron.d/ticker and add the following line:

* * * * * pi /bin/bash /home/pi/dfd-crypto-ticker/scripts/keep.screensaver.off.bash > /dev/null 2>&1



## ONLY RUN BELOW COMMANDS IF YOU HAVE A "goodtft LCD-show" LCD screen:

sudo apt update && sudo apt upgrade

sudo apt install git

cd ~/dfd-crypto-ticker/builds

git clone https://github.com/goodtft/LCD-show.git

cd ~/

chmod -R 755 ~/dfd-crypto-ticker/builds

ln -s ~/dfd-crypto-ticker/scripts/switch-display.bash ~/display



#############################################################################################




Real Time BTC Price Ticker For Raspberry Pis With LCD Screens

Example on a 3.5" LCD: https://www.youtube.com/watch?v=0TDnpYrGnOg

Developed on a Raspi v2 B+, with this screen / case: https://smile.amazon.com/gp/product/B07N38B86S/

#############################################################################################

Upload the exact directory structure in the download archive into /home/pi/ on your raspberry pi

#############################################################################################

Run these commands:

sudo apt update && sudo apt upgrade

sudo apt install xdotool unclutter

chmod -R 755 /home/pi/Scripts

ln -s /home/pi/Scripts/switch-display.bash ~/display

## ONLY RUN BELOW COMMANDS IF YOU HAVE A "goodtft LCD-show" LCD

cd ~/Builds

git clone https://github.com/goodtft/LCD-show.git

cd ~/

chmod -R 755 /home/pi/Builds

#############################################################################################

Edit the following file: /home/pi/.config/lxsession/LXDE-pi/autostart and add the following lines:

@xset s off
@xset -dpms
@xset s noblank
# start chromium
@/bin/bash /home/pi/Scripts/start-chromium.bash &
# hide cursor
@unclutter -idle 0

#############################################################################################

Add this as a cron job every minute:

* * * * * /bin/bash /home/pi/Scripts/keep.screensaver.off.bash > /dev/null 2>&1

#############################################################################################

Edit the following file to switch between USD / EUR / GBP markets: 

/home/pi/Apps/Ticker-UI/config.js

#############################################################################################

After completing above setup, you can switch between HDMI / LCD on "goodtft LCD-show" devices by running the command:

./display

You may need to adjust the initial chromium scale size if your screen isn't 3.5". This can be done in Scripts/start-chromium.bash

#############################################################################################



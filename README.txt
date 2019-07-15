

#############################################################################################

Upload the exact directory structure in the download archive into /home/pi/ on your raspberry pi

#############################################################################################

Run these commands:

sudo apt update && sudo apt upgrade

sudo apt install xdotool unclutter

chmod -R 755 /home/pi/Scripts

chmod -R 755 /home/pi/Builds

ln -s /home/pi/Scripts/switch-display.bash ~/display

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

After completing above setup, you can switch between HDMI / LCD on "goodtft LCD-show" devices by running the command:

./display

You may need to adjust the initial chromium scale size if your screen isn't 3.5". This can be done in Scripts/start-chromium.bash

#############################################################################################



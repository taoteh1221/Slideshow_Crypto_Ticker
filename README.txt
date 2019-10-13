
DFD Crypto Ticker - Developed by Michael Kilday <mike@dragonfrugal.com>, released free / open source (under GPL v3)

Copyright 2019 GPLv3

Real Time Crypto Price Ticker For Raspberry Pis With LCD Screens, including 24 hour volume and full Coinbase Pro support (more exchanges coming in the future).

Supports all Coinbase Pro markets, and can run in "slideshow mode", to show all the markets you want.

Example on a 3.5" LCD: https://www.youtube.com/watch?v=W043CHKKjC8

Developed on a Raspi v2 B+, with this screen / case: https://smile.amazon.com/gp/product/B07N38B86S/

Download Latest Version: https://github.com/taoteh1221/DFD_Crypto_Ticker/releases


#############################################################################################


AUTOMATIC INSTALLATION

IMPORTANT NOTES: This install script has been designed to run generically on Debian-based systems, but has only been tested on Raspberry Pis running Raspian. For Ticker autostart at system boot, the LXDE Desktop is required (this is the default desktop on Raspberry Pis). The ticker can also be manually started (see CONFIGURING AFTER INSTALLATION).


To install / upgrade everything automatically on a Raspberry Pi (an affordable low power single board computer), copy / paste / run the command below in a terminal program while logged in on the Raspberry Pi:


wget -O TICKER-INSTALL.bash https://git.io/JeWWx;chmod +x TICKER-INSTALL.bash;sudo ./TICKER-INSTALL.bash


Follow the prompts, and the automated script will install / configure the ticker.


#############################################################################################


CONFIGURING AFTER INSTALLATION


Edit the following file in a text editor to switch between different exchanges / crypto assets / base pairings, and to configure slideshow speed / font size / vertical position / screen orientation: 

/home/pi/dfd-crypto-ticker/apps/ticker/config.js


Example editing config.js in nano by command-line:

nano ~/dfd-crypto-ticker/apps/ticker/config.js


After updating config.js, reload the ticker with this command:

~/reload


If you have a "goodtft LCD-show" LCD screen and you installed it's drivers, you can now switch between the LCD and your normal monitor by running the command:

~/display


You may need to adjust the initial chromium web browser scale size if your screen is NOT 3.5". This can be edited with a text editor in:
/home/pi/dfd-crypto-ticker/scripts/ticker-init.bash


If ticker autostart on system boot fails for any reason, the ticker can be started MANUALLY (after system boot) with this command:

bash ~/dfd-crypto-ticker/scripts/ticker-init.bash &>/dev/null &


#############################################################################################



MANUAL INSTALLATION (IF AUTO-INSTALL SCRIPT FAILS, ETC)...


IMPORTANT NOTES: If your system is not a Raspberry Pi, or you are logged in / running as a user other than 'pi', just substitute that username in place of the 'pi' user in (/home/pi/) references below. Additionally, the path .../lxsession/LXDE-pi/... should remain as 'LXDE-pi' on Raspberry Pis REGARDLESS of what user you login / run as. On other Debain-based systems with the LXDE Desktop installed, 'LXDE-pi' will NEED TO BE CHANGED to the proper profile name (usually can be determined as the most recently-created subdirectory name within /etc/xdg/lxsession/).



Upload the 'dfd-crypto-ticker' directory in the download archive into /home/pi/ on your Raspberry Pi.



Run these commands (logged in as user pi):

sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade

sudo apt-get install xdotool unclutter raspberrypi-ui-mods rpi-chromium-mods ttf-ancient-fonts ttf-dejavu ttf-mscorefonts-installer fonts-symbola fonts-noto xfonts-unifont ttf-unifont -y

chmod -R 755 ~/dfd-crypto-ticker/scripts

ln -s ~/dfd-crypto-ticker/scripts/chromium-refresh.bash ~/reload



Create / edit the following file: /home/pi/.config/lxsession/LXDE-pi/autostart and add the following line:

@/bin/bash /home/pi/dfd-crypto-ticker/scripts/ticker-init.bash &

IF /home/pi/.config/lxsession/LXDE-pi/autostart IS BLANK / NON-EXISTANT WHEN YOU EDIT IT, 
ADD THE LINES IN THIS FILE ---FIRST ABOVE--- THAT COMMAND (to preserve your CURRENT desktop settings): /etc/xdg/lxsession/LXDE-pi/autostart



Add this as a cron job every minute, by creating the following file (you'll need sudo permissions): /etc/cron.d/ticker and add the following line (and a carriage return AFTER it to be safe):

* * * * * pi /bin/bash /home/pi/dfd-crypto-ticker/scripts/keep-screensaver-off.bash > /dev/null 2>&1



If your system DOES NOT have /etc/cron.d/ on it, then NEARLY the same format (minus the username) can be installed via the 'crontab -e' command (logged in as the user you want running the cron job):

* * * * * /bin/bash /home/pi/dfd-crypto-ticker/scripts/keep-screensaver-off.bash > /dev/null 2>&1



IMPORTANT CRON JOB NOTES: MAKE SURE YOU ONLY USE EITHER /etc/cron.d/, or 'crontab -e', NOT BOTH...ANY OLD DUPLICATE ENTRIES WILL RUN YOUR CRON JOB TOO OFTEN.


When you've finished setting up everything, reboot to activate the ticker with this command:
sudo reboot


## ONLY RUN BELOW COMMANDS IF YOU HAVE A "goodtft LCD-show" LCD screen:

sudo apt update && sudo apt upgrade

sudo apt install git

cd ~/dfd-crypto-ticker/builds

git clone https://github.com/goodtft/LCD-show.git

cd ~/

chmod -R 755 ~/dfd-crypto-ticker/builds

ln -s ~/dfd-crypto-ticker/scripts/switch-display.bash ~/display



#############################################################################################



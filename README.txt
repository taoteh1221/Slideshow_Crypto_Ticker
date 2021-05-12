
Slideshow Crypto Ticker - Developed by Michael Kilday <mike@dragonfrugal.com>, released free / open source (under GPL v3)

Copyright 2019-2021 GPLv3

Open source / 100% FREE real time slideshow crypto price ticker for Raspberry Pi LCD screens, including 24 hour volume and Binance / Coinbase Pro / Kraken / Kucoin / Bitstamp / Bitfinex / HitBTC / OKex / LoopRing support (more exchanges coming in the future).

Supports running in "slideshow mode", to show all the markets you want.

Example on a 3.5" LCD: https://www.youtube.com/watch?v=bvPQ6PLy_ME

Developed on a Raspi v3 B+, with this screen / case: https://smile.amazon.com/gp/product/B07N38B86S

Project Website: https://sourceforge.net/projects/dfd-crypto-ticker

Download Latest Version: https://github.com/taoteh1221/Slideshow_Crypto_Ticker/releases

Issue Reporting (Features / Issues / Help): https://github.com/taoteh1221/Slideshow_Crypto_Ticker/issues

Discord: https://discord.gg/WZVK2nm

Telegram: https://t.me/joinchat/Oo2XZRS2HsOXSMGejgSO0A

Twitter: https://twitter.com/taoteh1221

Private Contact: https://dragonfrugal.com/contact


Donations support further development... 

Bitcoin:  3Nw6cvSgnLEFmQ1V4e8RSBG23G7pDjF3hW

Ethereum:  0x644343e8D0A4cF33eee3E54fE5d5B8BFD0285EF8

Github Sponsors:  https://github.com/sponsors/taoteh1221

Patreon:   https://www.patreon.com/dragonfrugal

PayPal:    https://www.paypal.me/dragonfrugal


#############################################################################################


AUTOMATIC INSTALLATION

IMPORTANT NOTES: This install script has been designed to run generically on Debian-based systems, but has only been tested on Raspberry Pis running Raspian. For Ticker autostart at system boot, the LXDE Desktop is #REQUIRED# (this is the default desktop on Raspberry Pis). The ticker can also be manually started (see CONFIGURING AFTER INSTALLATION).


To install / upgrade everything automatically on a Raspberry Pi (an affordable low power single board computer), copy / paste / run the command below in a terminal program (using the 'Terminal' app in the system menu, or over remote SSH), while logged in AS THE USER THAT WILL RUN THE APP (user must have sudo privileges):


wget --no-cache -O TICKER-INSTALL.bash https://git.io/Jqzjk;chmod +x TICKER-INSTALL.bash;sudo ./TICKER-INSTALL.bash


Follow the prompts, and the automated script will install / configure the ticker. KUCOIN MARKETS #WILL NOT WORK# IF YOU DO NOT INSTALL THE TICKER PROPERLY!


#############################################################################################


CONFIGURING AFTER INSTALLATION


Edit the following file in a text editor to switch between different exchanges / crypto assets / base pairings, and to configure settings for slideshow speed / font sizes and colors / background color / vertical position / screen orientation / google font used / monospace emulation: 

/home/YOUR_USER_NAME/slideshow-crypto-ticker/config.js


Example editing config.js in nano by command-line:

nano ~/slideshow-crypto-ticker/config.js


After updating config.js, restart the ticker with this command:

~/ticker-restart


If autostart does not work / is not setup, you can run this command MANUALLY, #AFTER BOOTING INTO THE DESKTOP INTERFACE#, to start Slideshow Crypto Ticker:

~/ticker-start


To stop Slideshow Crypto Ticker:

~/ticker-stop


If you have a "goodtft LCD-show" LCD screen and you installed it's drivers, you can now switch between the LCD and your normal monitor by running the command:

~/goodtft-only


#############################################################################################



MANUAL INSTALLATION (IF AUTO-INSTALL SCRIPT FAILS, ETC)...


IMPORTANT NOTES: USE RASPBIAN #FULL# DESKTOP, #NOT# LITE, OR YOU LIKELY WILL HAVE SOME ISSUES EVEN AFTER UPGRADING TO GUI (trust me). If your system is NOT a Raspberry Pi, or you are logged in / running as a user other than 'pi', just substitute that username in place of the 'YOUR_USER_NAME' user in references below.


UPGRADE NOTES: For v2.13.0 and higher, delete any OLDER install's /scripts/ and /apps/ sub-directories WITHIN the main 'slideshow-crypto-ticker' directory (THESE ARE NO LONGER USED).


Create a new directory / folder named 'slideshow-crypto-ticker' in /home/YOUR_USER_NAME/ on your Raspberry Pi,
and put all the app's files and folders into this directory.


---------------------


Run these commands (logged in as user YOUR_USER_NAME):

sudo apt-get update && sudo apt-get upgrade

sudo apt-get install xdotool unclutter sed -y

chmod -R 755 ~/slideshow-crypto-ticker/bash

ln -s ~/slideshow-crypto-ticker/bash/ticker-restart.bash ~/ticker-restart

ln -s ~/slideshow-crypto-ticker/bash/ticker-start.bash ~/ticker-start

ln -s ~/slideshow-crypto-ticker/bash/ticker-stop.bash ~/ticker-stop


---------------------


Create / edit the following file (you'll need sudo/root permissions): /lib/systemd/system/ticker.service and add the following:

[Unit]
Description=Chromium Ticker
Wants=graphical.target
After=graphical.target

[Service]
Environment=DISPLAY=:0  
Environment=XAUTHORITY=/home/YOUR_USER_NAME/.Xauthority
Type=simple
ExecStart=/bin/bash /home/YOUR_USER_NAME/slideshow-crypto-ticker/bash/ticker-auto-start.bash
Restart=on-abort
User=YOUR_USER_NAME
Group=YOUR_USER_NAME

[Install]
WantedBy=graphical.target


After creating the service file above, we enable it with this command (so it runs on system startup):

sudo systemctl enable ticker.service


---------------------


Add this as a cron job every minute, by creating the following file (you'll need sudo/root permissions): /etc/cron.d/ticker and add the following line (and a carriage return AFTER it to be safe):

* * * * * YOUR_USER_NAME /bin/bash /home/YOUR_USER_NAME/slideshow-crypto-ticker/bash/cron/cron.bash > /dev/null 2>&1



If your system DOES NOT have /etc/cron.d/ on it, then NEARLY the same format (minus the username) can be installed via the 'crontab -e' command (logged in as the user you want running the cron job):

* * * * * /bin/bash /home/YOUR_USER_NAME/slideshow-crypto-ticker/bash/cron/cron.bash > /dev/null 2>&1



IMPORTANT CRON JOB NOTES: MAKE SURE YOU ONLY USE EITHER /etc/cron.d/, or 'crontab -e', NOT BOTH...ANY OLD DUPLICATE ENTRIES WILL RUN YOUR CRON JOB TOO OFTEN.


---------------------


When you've finished setting up everything, reboot to activate the ticker with this command:
sudo reboot


## ONLY RUN BELOW COMMANDS IF YOU HAVE A "goodtft LCD-show" LCD screen:

sudo apt-get update && sudo apt-get upgrade

sudo apt install git

cd ~/slideshow-crypto-ticker/builds

git clone https://github.com/goodtft/LCD-show.git

cd ~/

chmod -R 755 ~/slideshow-crypto-ticker/builds

ln -s ~/slideshow-crypto-ticker/bash/goodtft-only.bash ~/goodtft-only



#############################################################################################



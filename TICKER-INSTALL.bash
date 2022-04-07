#!/bin/bash

# Copyright 2014-2022 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com


echo " "
echo "PLEASE REPORT ANY ISSUES HERE: https://github.com/taoteh1221/Slideshow_Crypto_Ticker/issues"
echo " "
echo "Initializing, please wait..."
echo " "


# EXPLICITLY set any dietpi paths 
# Export too, in case we are calling another bash instance in this script
if [ -f /boot/dietpi/.version ]; then
PATH=/boot/dietpi:$PATH
export PATH=$PATH
fi
				

# EXPLICITLY set any ~/.local/bin paths
# Export too, in case we are calling another bash instance in this script
if [ -d ~/.local/bin ]; then
PATH=~/.local/bin:$PATH
export PATH=$PATH
fi
				

# EXPLICITLY set any /usr/sbin path
# Export too, in case we are calling another bash instance in this script
if [ -d /usr/sbin ]; then
PATH=/usr/sbin:$PATH
export PATH=$PATH
fi


######################################

# https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux

if hash tput > /dev/null 2>&1; then

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`

reset=`tput sgr0`

else

red=``
green=``
yellow=``
blue=``
magenta=``
cyan=``

reset=``

fi


######################################


# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


# If logname doesn't work, use the $SUDO_USER or $USER global var
if [ -z "$TERMINAL_USERNAME" ]; then

    if [ -z "$SUDO_USER" ]; then
    TERMINAL_USERNAME=$USER
    else
    TERMINAL_USERNAME=$SUDO_USER
    fi

fi


# Get date / time
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')

# Current timestamp
CURRENT_TIMESTAMP=$(date +%s)

# Get the host ip address
IP=`hostname -I` 


# If a symlink, get link target for script location
 # WE ALWAYS WANT THE FULL PATH!
if [[ -L "$0" ]]; then
SCRIPT_LOCATION=$(readlink "$0")
else
SCRIPT_LOCATION="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/"$(basename "$0")""
fi

# Now set path / file vars, after setting SCRIPT_LOCATION
SCRIPT_PATH="$( cd -- "$(dirname "$SCRIPT_LOCATION")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT_NAME=$(basename "$SCRIPT_LOCATION")


# Get the operating system and version
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi


######################################

echo " "

if [ "$EUID" -ne 0 ] || [ "$TERMINAL_USERNAME" == "root" ]; then 
 echo "${red}Please run as a NORMAL USER WITH 'sudo' PERMISSIONS (NOT LOGGED IN AS 'root').${reset}"
 echo " "
 echo "${cyan}Exiting...${reset}"
 echo " "
 exit
fi

######################################


# Get primary dependency apps, if we haven't yet
    
# Install git if needed
GIT_PATH=$(which git)

if [ -z "$GIT_PATH" ]; then

echo " "
echo "${cyan}Installing required component git, please wait...${reset}"
echo " "

sudo apt update

sudo apt install git -y

fi


# Install curl if needed
CURL_PATH=$(which curl)

if [ -z "$CURL_PATH" ]; then

echo " "
echo "${cyan}Installing required component curl, please wait...${reset}"
echo " "

sudo apt update

sudo apt install curl -y

fi


# Install jq if needed
JQ_PATH=$(which jq)

if [ -z "$JQ_PATH" ]; then

echo " "
echo "${cyan}Installing required component jq, please wait...${reset}"
echo " "

sudo apt update

sudo apt install jq -y

fi


# Install wget if needed
WGET_PATH=$(which wget)

if [ -z "$WGET_PATH" ]; then

echo " "
echo "${cyan}Installing required component wget, please wait...${reset}"
echo " "

sudo apt update

sudo apt install wget -y

fi


# Install sed if needed
SED_PATH=$(which sed)

if [ -z "$SED_PATH" ]; then

echo " "
echo "${cyan}Installing required component sed, please wait...${reset}"
echo " "

sudo apt update

sudo apt install sed -y

fi


# Install less if needed
LESS_PATH=$(which less)
				
if [ -z "$LESS_PATH" ]; then

echo " "
echo "${cyan}Installing required component less, please wait...${reset}"
echo " "

sudo apt update

sudo apt install less -y

fi


# Install expect if needed
EXPECT_PATH=$(which expect)
				
if [ -z "$EXPECT_PATH" ]; then

echo " "
echo "${cyan}Installing required component expect, please wait...${reset}"
echo " "

sudo apt update

sudo apt install expect -y

fi


# Install avahi-daemon if needed (for .local names on internal / home network)
AVAHID_PATH=$(which avahi-daemon)

if [ -z "$AVAHID_PATH" ]; then

echo " "
echo "${cyan}Installing required component avahi-daemon, please wait...${reset}"
echo " "

sudo apt update

sudo apt install avahi-daemon -y

fi


# Install bc if needed (for decimal math in bash)
BC_PATH=$(which bc)

if [ -z "$BC_PATH" ]; then

echo " "
echo "${cyan}Installing required component bc, please wait...${reset}"
echo " "

sudo apt update

sudo apt install bc -y

fi


# dependency check END


######################################


# Start in user home directory
# WE DON'T USE ~/ FOR PATHS IN THIS SCRIPT BECAUSE:
# 1) WE'RE #RUNNING AS SUDO# ANYWAYS (WE CAN INSTALL ANYWHERE WE WANT)
# 2) WE SET THE USER WE WANT TO INSTALL UNDER DYNAMICALLY
# 3) IN CASE THE USER INITIATES INSTALL AS ANOTHER ADMIN USER
cd /home/$TERMINAL_USERNAME


######################################


echo " "
echo "${yellow}Enter the system username to configure installation for:"
echo "(leave blank / hit enter for default of username '${TERMINAL_USERNAME}')${reset}"
echo " "

read APP_USER
echo " "
        
if [ -z "$APP_USER" ]; then
APP_USER=${1:-$TERMINAL_USERNAME}
echo "${green}Using default username: $APP_USER${reset}"
else
echo "${green}Using username: $APP_USER${reset}"
fi


if [ ! -d "/home/$APP_USER/" ]; then    		
echo " "
echo "${red}Directory /home/$APP_USER/ DOES NOT exist, cannot install Slideshow Crypto Ticker."
echo " "
echo "Please create user $APP_USER's home directory before running this installation.${reset}"
exit
fi

echo " "


######################################

  				
echo "${green}You have set the user information as..."
echo " "
echo "User: $APP_USER"
echo " "
echo "User home directory: /home/$APP_USER/${reset}"
echo " "

echo "${yellow}If this information is NOT correct, please exit installation and start again.${reset}"
echo " "

echo "${yellow} "
read -n1 -s -r -p $"Press y to continue (or press n to exit)..." key
echo "${reset} "

    if [ "$key" = 'y' ] || [ "$key" = 'Y' ]; then
    echo " "
    echo "${green}Continuing...${reset}"
    echo " "
    else
    echo " "
    echo "${green}Exiting...${reset}"
    echo " "
    exit
    fi

echo " "


######################################


# MIGRATE SAFELY TO NEW APP NAMED DIR (we delete the old one if the user completes installation)
\cp -r /home/$APP_USER/dfd-crypto-ticker /home/$APP_USER/slideshow-crypto-ticker > /dev/null 2>&1


echo "${yellow}TECHNICAL NOTE:"
echo " "
echo "This script was designed to install on Debian-based operating systems (Raspberry Pi OS, Ubuntu, etc),"
echo "for small single-board computers WITH SMALL IN-CASE LCD SCREENS."
echo " "
echo "It is ONLY recommended to install this ticker app IF your device has an LCD screen installed.${reset}"
echo " "

echo "${cyan}Your operating system has been detected as:"
echo " "
echo "$OS v$VER${reset}"
echo " "

echo "${yellow}This script may OR MAY NOT work on all Debian-based system setups.${reset}"
echo " "

echo "${red}USE A #FULL# DESKTOP SETUP, #NOT# LITE, OR YOU LIKELY WILL HAVE SOME ISSUES WITH CHROMIUM BROWSER EVEN"
echo "AFTER UPGRADING TO GUI / CHROME (trust me)."
echo " "
echo "(Chromium, Epiphany, Firefox, OR Midori are supported [chromium recommended ON LOW POWER DEVICES, all these browsers will be installed if available])${reset}"
echo " "

if [ -f "/etc/debian_version" ]; then
echo "${cyan}Your system has been detected as Debian-based, which is compatible with this automated installation script."
echo " "
echo "Continuing...${reset}"
echo " "
else
echo "${red}Your system has been detected as NOT BEING Debian-based. Your system is NOT compatible with this automated installation script."
echo " "
echo "Exiting...${reset}"
exit
fi
  				
				
if [ -f /home/$APP_USER/slideshow-crypto-ticker/config.js ]; then
echo "${yellow}A configuration file from a previous install of Slideshow Crypto Ticker has been detected on your system."
echo " "
echo "${green}During this upgrade / re-install, it will be backed up to:"
echo " "
echo "/home/$APP_USER/slideshow-crypto-ticker/config.js.BACKUP.$DATE${reset}"
echo " "
echo "This will save any custom settings within it."
echo " "
echo "You will need to manually move any custom settings in this backup file to the new config.js file with a text editor.${reset}"
echo " "
fi


echo "PLEASE REPORT ANY ISSUES HERE: https://github.com/taoteh1221/Slideshow_Crypto_Ticker/issues"
echo " "

echo "${yellow} "
read -n1 -s -r -p $"Press y to continue (or press n to exit)..." key
echo "${reset} "

    if [ "$key" = 'y' ] || [ "$key" = 'Y' ]; then
    echo " "
    echo "${green}Continuing...${reset}"
    echo " "
    else
    echo " "
    echo "${green}Exiting...${reset}"
    echo " "
    exit
    fi

echo " "


######################################


echo "${cyan}Making sure your system is updated before installation, please wait...${reset}"

echo " "
			
apt-get update

#DO NOT RUN dist-upgrade, bad things can happen, lol
apt-get upgrade -y

echo " "
				
echo "${cyan}System update completed.${reset}"
				
sleep 3
				
echo " "

# If we are NOT running raspi os, we need the lxde desktop
if [ ! -f /usr/bin/raspi-config ]; then

echo "${red}WE NEED TO MAKE SURE LXDE #AND# LIGHTDM RUN AT STARTUP, AS THE USER '${APP_USER}',"
echo "IF YOU WANT THE TICKER TO #AUTOMATICALLY RUN ON SYSTEM STARTUP# / REBOOT."
echo " "
echo "CHOOSE \"LIGHTDM\" WHEN ASKED, FOR \"AUTO-LOGIN AT BOOT\" CAPABILITIES.${reset}"
echo " "
echo "${yellow}Select 1 or 2 to choose whether to setup LXDE Desktop, or skip.${reset}"
echo " "
    
    OPTIONS="setup_lxde skip"
    
    select opt in $OPTIONS; do
            if [ "$opt" = "setup_lxde" ]; then
            
            echo " "
            echo "${cyan}Installing LXDE desktop and required components, please wait...${reset}"
            echo " "
            
            apt install xserver-xorg lightdm lxde -y
            
            sleep 5
            
            echo " "
            echo "${cyan}Configuring lightdm auto-login at boot for user '${APP_USER}', please wait...${reset}"
            echo " "
            
                # Auto-login LXDE
                if [ ! -f /etc/lightdm/lightdm.conf ]; then
                
                
# Don't nest / indent, or it could malform the settings            
read -r -d '' LXDE_AUTO_LOGIN <<- EOF
\r
autologin-user=$APP_USER
autologin-user-timeout=delay
user-session=LXDE
\r
EOF

				# Setup LXDE to run at boot
				
				touch /etc/lightdm/lightdm.conf
					
				echo -e "$LXDE_AUTO_LOGIN" > /etc/lightdm/lightdm.conf
					
                
                else
                
                sed -i "s/#autologin-user-timeout=.*/autologin-user-timeout=delay/g" /etc/lightdm/lightdm.conf
                sleep 2
                sed -i "s/#autologin-user=.*/autologin-user=${APP_USER}/g" /etc/lightdm/lightdm.conf
                sleep 2
                sed -i "s/autologin-user=.*/autologin-user=${APP_USER}/g" /etc/lightdm/lightdm.conf
                sleep 2
                sed -i "s/user-session=.*/user-session=LXDE/g" /etc/lightdm/lightdm.conf
                
                fi
            
            sleep 2
            
            # Enable GUI on boot
            systemctl set-default graphical
            
            echo " "
            echo "${cyan}LXDE desktop and required components have been installed and configured.${reset}"
            echo " "
            
            
                # If we are running dietpi OS, WARN USER AN ADDITIONAL STEP #MAY# BE NEEDED
                if [ -f /boot/dietpi/.version ]; then
                echo "${red}DietPi #SHOULD NOT REQUIRE# USING THE dietpi-autostart UTILITY TO SET LXDE TO AUTO-LOGIN"
                echo "AS THE USER '${APP_USER}', SINCE #WE JUST SETUP LXDE AUTO-LOGIN ALREADY#.${reset}"
                fi
            
            
            break
           elif [ "$opt" = "skip" ]; then
            echo " "
            echo "${green}Skipping LXDE desktop setup...${reset}"
            break
           fi
    done
    
else

echo "${red}THIS TICKER #REQUIRES# RUNNING THE DESKTOP INTERFACE LXDE AT STARTUP (#already the default# in Raspberry Pi OS Desktop),"
echo "AS THE USER '${APP_USER}', IF YOU WANT THE TICKER TO #AUTOMATICALLY RUN ON SYSTEM STARTUP# / REBOOT.${reset}"

fi

echo " "


######################################


echo "Do you want this script to automatically download the latest version of Slideshow Crypto Ticker"
echo "from Github.com, and install it?"
echo " "
echo "(auto-install will overwrite / upgrade any previous install located at: /home/$APP_USER/slideshow-crypto-ticker)"
echo " "

echo "${yellow}Select 1, 2, or 3 to choose whether to auto-install / remove Slideshow Crypto Ticker, or skip.${reset}"
echo " "

OPTIONS="install_ticker_app remove_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_ticker_app" ]; then
        
        	
				echo " "
				
				echo "${cyan}Proceeding with required component installation, please wait...${reset}"
				
				echo " "
				
				# bsdtar installs may fail (essentially the same package as libarchive-tools),
				# SO WE RUN BOTH SEPERATELY IN CASE AN ERROR THROWS, SO OTHER PACKAGES INSTALL OK AFTERWARDS
				
				echo "${yellow}(you can safely ignore any upcoming 'bsdtar' install errors, if 'libarchive-tools'"
				echo "installs OK...and visa versa, as they are essentially the same package)${reset}"
				echo " "
				
				# Ubuntu 16.x, and other debian-based systems
				apt-get install bsdtar -y
				
				sleep 1
				
				# Ubuntu 18.x and higher
				apt-get install libarchive-tools -y
				
				sleep 1
				
				# midori on raspbian
				apt-get install midori -y
				
				sleep 1
				
				# Firefox on raspbian
				apt-get install firefox-esr -y
				
				sleep 1
				
				# Firefox on ubuntu, etc
				apt-get install firefox -y
				
				sleep 1
				
				# epiphany on raspbian
				apt-get install epiphany-browser -y
				
				sleep 1
				
				# Chromium on raspbian
				apt-get install chromium-browser -y
				
				sleep 10

                # Look for 'epiphany-browser'
                EPIPHANY_PATH=$(which epiphany-browser)

                    # If 'epiphany-browser' NOT found, install epiphany UNLESS THIS IS RASPI OS
                    if [ -z "$EPIPHANY_PATH" ] && [ ! -f /usr/bin/raspi-config ]; then
    
    				# epiphany on ubuntu, etc
    				apt-get install epiphany -y
    				
    				sleep 1
    				
                    fi

                # Look for 'chromium-browser'
                CHROMIUM_PATH=$(which chromium-browser)

                    # If 'chromium-browser' NOT found, install chromium UNLESS THIS IS RASPI OS
                    # ('chromium-browser' IS DEFAULT ON RASPI OS, AND THIS WOULD TRIGGER REPLACING IT WITH A #DOWNGRADED# VERSION)
                    if [ -z "$CHROMIUM_PATH" ] && [ ! -f /usr/bin/raspi-config ]; then
    
    				# Chromium on ubuntu, etc
    				apt-get install chromium -y
    				
    				sleep 1
    				
                    fi
				
				# Grapics card detection support for firefox (for browser GPU acceleration)
				apt install libpci-dev -y
				
				sleep 1
				
				# Not sure we need this Mesa 3D Graphics Library / OpenGL stuff, but leave for
				# now until we determine why firefox is having issues enabling GPU acceleration
				apt install freeglut3-dev -y
				
				sleep 1
				
				apt install libglu1-mesa-dev -y
				
				sleep 1
				
				apt install mesa-utils mesa-common-dev -y
				
				sleep 1
				
				apt install mesa-vulkan-drivers vulkan-icd -y

				
				# Safely install other packages seperately, so they aren't cancelled by 'package missing' errors
				apt-get install xdotool unclutter openssl x11-xserver-utils xautomation -y
				
				sleep 5
				
				
    				# FIX FOR 2022-1-28 RASPI OS CHROMIUM BUG
    				# https://github.com/RPi-Distro/chromium-browser/issues/28
    				# /etc/chromium.d/ticker-fix-egl CAN BE NAMED ANYTHING, AS LONG AS IT'S IN /etc/chromium.d/
    				CHROMIUM_GL=$(sed -n '/ --use-gl=egl/p' /etc/chromium.d/ticker-fix-egl)
				
                    if [ "$CHROMIUM_GL" == "" ]; then 
                    
                    echo " "
                    echo "${red}EGL not enabled for chromium, enabling it now, please wait...${reset}"
                    echo " "
                    
                    # Add EGL config to /etc/chromium.d/ticker-fix-egl
				    echo 'export CHROMIUM_FLAGS="$CHROMIUM_FLAGS --use-gl=egl"' | tee /etc/chromium.d/ticker-fix-egl
				    
                    fi        
                    
				
				echo " "
				
				echo "${cyan}Required component installation completed.${reset}"
				
				sleep 3
				
				echo " "
				
				
					if [ -f /home/$APP_USER/slideshow-crypto-ticker/config.js ]; then
					
					\cp /home/$APP_USER/slideshow-crypto-ticker/config.js /home/$APP_USER/slideshow-crypto-ticker/config.js.BACKUP.$DATE
						
					chown $APP_USER:$APP_USER /home/$APP_USER/slideshow-crypto-ticker/config.js.BACKUP.$DATE
						
					CONFIG_BACKUP=1
					
					fi
				
				
				echo "${cyan}Downloading and installing the latest version of Slideshow Crypto Ticker, from Github.com, please wait...${reset}"
				
				echo " "
				
				mkdir Slideshow-Crypto-Ticker-TEMP
				
				cd Slideshow-Crypto-Ticker-TEMP
				
				ZIP_DL=$(curl -s 'https://api.github.com/repos/taoteh1221/Slideshow_Crypto_Ticker/releases/latest' | jq -r '.zipball_url')
				
				wget -O Slideshow-Crypto-Ticker-TEMP.zip $ZIP_DL
				
				bsdtar --strip-components=1 -xvf Slideshow-Crypto-Ticker-TEMP.zip
				
				rm Slideshow-Crypto-Ticker-TEMP.zip
				
				# Remove depreciated directory structure from any previous installs
				rm -rf /home/$APP_USER/slideshow-crypto-ticker/apps > /dev/null 2>&1
				rm -rf /home/$APP_USER/slideshow-crypto-ticker/scripts > /dev/null 2>&1
				rm -rf /home/$APP_USER/slideshow-crypto-ticker/cache/json > /dev/null 2>&1
				rm -rf /home/$APP_USER/slideshow-crypto-ticker/cache/js > /dev/null 2>&1

				sleep 1
				
  				# Copy over the upgrade install files to the install directory, after cleaning up dev files
				# No trailing forward slash here
				
  				mkdir -p /home/$APP_USER/slideshow-crypto-ticker
				
				rm -rf .git > /dev/null 2>&1
				rm -rf .github > /dev/null 2>&1
				rm .gitattributes > /dev/null 2>&1
				rm .gitignore > /dev/null 2>&1
				rm .whitesource > /dev/null 2>&1
				rm CODEOWNERS > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/switch-display.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/ticker-auto-start.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/chromium-refresh.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/chromium.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/epiphany.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/firefox.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/ticker-init.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/cron.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/cron/kucoin-auth.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/cron/raspi-temps.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/js/jquery.min.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/js/functions.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/js/init.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/cache/cache.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/cache/raspi_data.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/cache/browser.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/ATTRIBUTION-CREDIT-INFO.txt > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/images/upload-cloud-fill.svg > /dev/null 2>&1
				rm /home/$APP_USER/reload > /dev/null 2>&1
				
				\cp -r ./ /home/$APP_USER/slideshow-crypto-ticker

				sleep 3
				
				cd ../
				
				rm -rf Slideshow-Crypto-Ticker-TEMP
				
				chmod -R 755 /home/$APP_USER/slideshow-crypto-ticker/bash
				
				# No trailing forward slash here
				chown -R $APP_USER:$APP_USER /home/$APP_USER/slideshow-crypto-ticker
				
				# If an older depreciated version, just re-create the symlink after deleting to be safe
				
				rm /home/$APP_USER/ticker-restart > /dev/null 2>&1
				
				sleep 1
			
				ln -s /home/$APP_USER/slideshow-crypto-ticker/bash/ticker-restart.bash /home/$APP_USER/ticker-restart
				
				chown $APP_USER:$APP_USER /home/$APP_USER/ticker-restart
			
				ln -s /home/$APP_USER/slideshow-crypto-ticker/bash/ticker-start.bash /home/$APP_USER/ticker-start
				
				chown $APP_USER:$APP_USER /home/$APP_USER/ticker-start
			
				ln -s /home/$APP_USER/slideshow-crypto-ticker/bash/ticker-stop.bash /home/$APP_USER/ticker-stop
				
				chown $APP_USER:$APP_USER /home/$APP_USER/ticker-stop
				
				echo " "
				
				echo "${green}Slideshow Crypto Ticker has been installed.${reset}"
				
	        	INSTALL_SETUP=1
   	     	
   	     	
        break
       elif [ "$opt" = "remove_ticker_app" ]; then
       
        echo " "
        echo "${cyan}Removing Slideshow Crypto Ticker and some required components, please wait...${reset}"
		  echo " "
				
        # ONLY removing unclutter, AS WE DON'T WANT TO F!CK UP THE WHOLE SYSTEM, REMOVING ANY OTHER ALREADY-USED / DEPENDANT PACKAGES TOO!!
		  apt-get remove unclutter -y
				
		  echo " "
		  echo "${cyan}Removal of 'unclutter' app package completed, please wait...${reset}"
		  echo " "
		  echo "${yellow}(IF YOU USED unclutter FOR ANOTHER APP, RE-INSTALL WITH: sudo apt-get install unclutter)${reset}"
		  echo " "
				
				
		  sleep 3
        
        rm /etc/cron.d/ticker > /dev/null 2>&1
        
        rm /lib/systemd/system/ticker.service > /dev/null 2>&1
        
        rm /home/$APP_USER/ticker-restart > /dev/null 2>&1
        
        rm /home/$APP_USER/ticker-start > /dev/null 2>&1
        
        rm /home/$APP_USER/ticker-stop > /dev/null 2>&1
        
        rm -rf /home/$APP_USER/slideshow-crypto-ticker > /dev/null 2>&1

		  sleep 3
        
		  echo " "
		  echo "${green}Slideshow Crypto Ticker has been removed from the system, PLEASE REBOOT to complete the removal process.${reset}"
        
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "${green}Skipping auto-install of Slideshow Crypto Ticker.${reset}"
        break
       fi
done

echo " "



######################################


# REMOVE OLD DIRECTORY LOCATION (if we got this far in this script, new location is now the live install)
rm -rf /home/$APP_USER/dfd-crypto-ticker > /dev/null 2>&1


echo "Do you want to automatically configure Slideshow Crypto Ticker for your system (autostart at login / keep screen turned on)?"
echo " "

echo "${yellow}Select 1 or 2 to choose whether to auto-configure Slideshow Crypto Ticker system settings, or skip it.${reset}"
echo " "

OPTIONS="auto_config_ticker_system skip"

select opt in $OPTIONS; do

        if [ "$opt" = "auto_config_ticker_system" ]; then
  				
                echo " "
                echo "${yellow}Select the NUMBER next to the browser you want to use to render the ticker (chromium recommended ON LOW POWER DEVICES).${reset}"
                echo " "
                
                    if [ -f /usr/bin/raspi-config ]; then
                    echo "${red}IT'S #HIGHLY RECOMMENDED# TO CHOOSE CHROMIUM ON A LOW POWER RASPBERRY PI DEVICE (FOR GRAPHICS ACCELERATION BENEFITS).${reset}"
                    echo " "
                    fi
                
                USER_BROWSER="chromium epiphany firefox midori"
                
                    select opt in $USER_BROWSER; do
                           if [ "$opt" = "chromium" ]; then
                            SET_BROWSER=$opt
                            break
                           elif [ "$opt" = "epiphany" ]; then
                            SET_BROWSER=$opt
                            break
                           elif [ "$opt" = "firefox" ]; then
                            SET_BROWSER=$opt
                            break
                           elif [ "$opt" = "midori" ]; then
                            SET_BROWSER=$opt
                            break
                           fi
                    done
                
                
                echo " "
                echo "${green}Using $SET_BROWSER as the default ticker browser...${reset}"
                echo " "

				echo " "
				echo "${cyan}Configuring Slideshow Crypto Ticker on your system, please wait...${reset}"
				echo " "
				

                    # Create cache directory if it doesn't exist yet
                    if [ ! -d /home/$APP_USER/slideshow-crypto-ticker/cache ]; then
                    mkdir -p /home/$APP_USER/slideshow-crypto-ticker/cache
                    fi

				
				echo -e "$SET_BROWSER" > /home/$APP_USER/slideshow-crypto-ticker/cache/default_browser.dat
				
				chown -R $APP_USER:$APP_USER /home/$APP_USER/slideshow-crypto-ticker/cache > /dev/null 2>&1
				

# Don't nest / indent, or it could malform the settings            
read -r -d '' TICKER_STARTUP <<- EOF
@/home/$APP_USER/slideshow-crypto-ticker/bash/lxde-auto-start.bash $SET_BROWSER
\r
EOF

				# Setup to run at LXDE login
                    
                # REMOVE #OLD WAY# THIS SCRIPT USED TO DO IT
                rm /lib/systemd/system/ticker.service > /dev/null 2>&1
                    
                      
                    if [ -f /usr/bin/raspi-config ]; then
                    # KNOWN raspi LXDE profile
                    LXDE_PROFILE="LXDE-pi"
                    else
                          
                    # Auto-detect or set to KNOWN LXDE default
                    # Unfortunately not much documentation on listing LXDE profile names,
                    # BUT looks fairly reliable to just check in /home/$APP_USER/.config/lxpanel
                    # (PRESUMING IT EXISTS ALREADY AT THIS POINT / ONLY ONE PROFILE PER LXDE USER IN USER FILES)
                    LXDE_PROFILE=$(ls /home/$APP_USER/.config/lxpanel)
                    LXDE_PROFILE=$(echo "${LXDE_PROFILE}" | xargs) # trim whitespace
                      
                        # If LXDE profile var was NOT auto-setup properly
                        # (contains whitespace MID-VARIABLE or is empty),
                        # go with KNOWN default from LXDE documentation
                        if [[ $LXDE_PROFILE =~ " " ]] || [ -z "$LXDE_PROFILE" ]; then
                        LXDE_PROFILE="LXDE"
                        LXDE_ALERT=1
                        fi
                      
                    fi
                      
				
				mkdir -p /home/$APP_USER/.config/lxsession/$LXDE_PROFILE > /dev/null 2>&1
				
				sleep 2
				
				
    				LXDE_AUTOSTART_OLD=$(sed -n '/ticker-auto-start.bash/p' /home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart)
    				LXDE_AUTOSTART_NEW=$(sed -n '/lxde-auto-start.bash/p' /home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart)
    				LXDE_AUTOSTART_BROWSER=$(sed -n "/lxde-auto-start.bash ${SET_BROWSER}/p" /home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart)
    				
				    # https://forums.raspberrypi.com/viewtopic.php?t=294014
				
				    # If it's our (borked) OLDER version, or USER autostart file doesn't exist yet
                    if [ "$LXDE_AUTOSTART_OLD" != "" ] || [ ! -f /home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart ]; then 
                    
                    echo " "
                    echo "${cyan}Enabling USER-defined LXDE autostart (/home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart), please wait...${reset}"
                    echo " "
                    
                    \cp /etc/xdg/lxsession/$LXDE_PROFILE/autostart /home/$APP_USER/.config/lxsession/$LXDE_PROFILE/
				    
                    fi        
                    
                    
                    sleep 2

                    
                    # If we have not appended our (NEWSEST LOGIC) ticker autostart yet
                    if [ "$LXDE_AUTOSTART_NEW" == "" ]; then 
                    
                    echo " "
                    echo "${cyan}Adding ticker autostart to USER-defined LXDE autostart (/home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart), please wait...${reset}"
                    echo " "
                    
                    # APPEND to autostart
                    echo -e "$TICKER_STARTUP" >> /home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart
                    
                    # OR changed to a different browser
                    elif [ "$LXDE_AUTOSTART_BROWSER" == "" ]; then
                    
                    echo " "
                    echo "${cyan}Updating ticker autostart browser to ${SET_BROWSER}, in USER-defined LXDE autostart (/home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart), please wait...${reset}"
                    echo " "
                    
                    sed -i "s/lxde-auto-start.bash .*/lxde-auto-start.bash ${SET_BROWSER}/g" /home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart
				    
                    fi        
				
				
				sleep 2
				
				# Make sure any new files / folders have user permissions
				chown -R $APP_USER:$APP_USER /home/$APP_USER/.config > /dev/null 2>&1
				
				AUTOSTART_ALERT=1
					
				# Setup cron (to check logs after install: tail -f /var/log/syslog | grep cron -i)

				CRONJOB="* * * * * $APP_USER bash /home/$APP_USER/slideshow-crypto-ticker/bash/cron/cron.bash > /dev/null 2>&1"

				# Play it safe and be sure their is a newline after this job entry
				echo -e "$CRONJOB\n" > /etc/cron.d/ticker
				
		  		# cron.d entries must be a permission of 644
		  		chmod 644 /etc/cron.d/ticker
		  		
				# cron.d entries MUST BE OWNED BY ROOT
				chown root:root /etc/cron.d/ticker
				
        		CRON_SETUP=1
				
				echo " "
				echo "${green}Slideshow Crypto Ticker system configuration complete.${reset}"
				echo " "
				
				    if [ "$LXDE_ALERT" = "1" ]; then
    				echo " "
                    echo "${red}WARNING: LXDE Desktop's profile could NOT be determined (default 'LXDE' was used), TICKER AUTO-START MAY FAIL!${reset}"
    				echo " "
				    fi
				
	        	CONFIG_SETUP=1
   	     	

        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "${green}Skipping auto-configuration of Slideshow Crypto Ticker system settings.${reset}"
        break
       fi
done

echo " "



######################################



echo "${red}WARNING:"
echo "#DO NOT INSTALL# THE 'goodtft LCD-show' LCD DRIVERS BELOW, UNLESS YOU HAVE A 'goodtft LCD-show' LCD SCREEN!${reset}"
echo " "

echo "${yellow}Select 1 or 2 to choose whether to install 'goodtft LCD-show' LCD drivers, or skip.${reset}"
echo " "

OPTIONS="install_goodtft skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_goodtft" ]; then
			
			echo " "
			echo "${cyan}Setting up for 'goodtft LCD-show' LCD drivers, please wait...${reset}"
			echo " "
			
			ln -s /home/$APP_USER/slideshow-crypto-ticker/bash/goodtft-only.bash /home/$APP_USER/goodtft-only
				
			chown $APP_USER:$APP_USER /home/$APP_USER/goodtft-only
			
			mkdir -p /home/$APP_USER/goodtft/builds
			
			cd /home/$APP_USER/goodtft/builds
			
			git clone https://github.com/goodtft/LCD-show.git
			
			chmod -R 755 /home/$APP_USER/goodtft/builds
			
			# No trailing forward slash here
			chown -R $APP_USER:$APP_USER /home/$APP_USER/goodtft/builds

				
			echo " "
			echo "${green}'goodtft LCD-show' LCD driver setup completed.${reset}"
				
			echo " "
			
			
			GOODTFT_SETUP=1
			
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "${green}Skipping 'goodtft LCD-show' LCD driver setup...${reset}"
        break
       fi
done

echo " "


######################################
			
# Return to user's home directory
cd /home/$APP_USER/


echo "${yellow} "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "# SAVE THE INFORMATION BELOW FOR FUTURE ACCESS TO THIS APP #"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "${reset} "


if [ "$CONFIG_BACKUP" = "1" ]; then

echo "${green}The previously-installed Slideshow Crypto Ticker configuration"
echo "file /home/$APP_USER/slideshow-crypto-ticker/config.js has been backed up to:"
echo " "
echo "/home/$APP_USER/slideshow-crypto-ticker/config.js.BACKUP.$DATE${reset}"
echo " "
echo "${yellow}You will need to manually move any custom settings in this backup file to the new config.js file with a text editor.${reset}"
echo " "

fi


if [ "$AUTOSTART_ALERT" = "1" ]; then

echo "${green}Ticker autostart at login has been configured at:"
echo " "
echo "/home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart${reset}"
echo " "
echo "${yellow}(the ticker should now start at boot/login with the $SET_BROWSER browser)${reset}"
echo " "
				
	if [ "$LXDE_ALERT" = "1" ]; then
    echo " "
    echo "${red}WARNING: LXDE Desktop's profile could NOT be determined (default 'LXDE' was used), TICKER AUTO-START MAY FAIL!${reset}"
    echo " "
	fi

fi


if [ "$CRON_SETUP" = "1" ]; then

echo "${green}A cron job has been setup for user '$APP_USER', as a command in /etc/cron.d/ticker:"
echo " "
echo "$CRONJOB"
echo "${reset} "

fi


if [ "$AUTOSTART_ALERT" = "1" ]; then

echo "${yellow}If autostart does not work, you can run this command MANUALLY,"
echo "#AFTER BOOTING INTO THE DESKTOP INTERFACE#, to start Slideshow Crypto Ticker:"
echo " "
echo "~/ticker-start"
echo " "
echo "If you prefer chromium, epiphany, firefox, or midori (you set $SET_BROWSER as the default):"
echo " "
echo "~/ticker-start chromium"
echo " "
echo "~/ticker-start epiphany"
echo " "
echo "~/ticker-start firefox"
echo " "
echo "~/ticker-start midori"
echo " "
echo "To stop Slideshow Crypto Ticker:"
echo " "
echo "~/ticker-stop"
echo "${reset} "

else

echo "${yellow}#AFTER BOOTING INTO THE DESKTOP INTERFACE#, to start Slideshow Crypto Ticker:"
echo " "
echo "~/ticker-start"
echo " "
echo "If you prefer chromium, epiphany, firefox, or midori (chromium recommended ON LOW POWER DEVICES):"
echo " "
echo "~/ticker-start chromium"
echo " "
echo "~/ticker-start epiphany"
echo " "
echo "~/ticker-start firefox"
echo " "
echo "~/ticker-start midori"
echo " "
echo "To stop Slideshow Crypto Ticker:"
echo " "
echo "~/ticker-stop"
echo "${reset} "

fi


echo "${yellow}Edit the following file in a text editor to activate different exchanges / crypto assets / base pairings,"
echo "and to configure settings for slideshow speed / font sizes and colors / background color / vertical position /"
echo "screen orientation / google font used / monospace emulation / activated pairings / etc / etc:"
echo " "
echo "/home/$APP_USER/slideshow-crypto-ticker/config.js"
echo " "

echo "Example editing config.js in nano by command-line:"
echo " "
echo "nano ~/slideshow-crypto-ticker/config.js"
echo " "

echo "After updating config.js, restart the ticker with this command:"
echo " "
echo "~/ticker-restart"
echo "${reset} "

echo "${cyan}Ticker installation / setup should be complete (if you chose those options), unless you saw any error"
echo "messages on your screen during setup."
echo "${reset} "


if [ "$GOODTFT_SETUP" = "1" ]; then

echo "${yellow}TO COMPLETE THE 'goodtft LCD-show' LCD DRIVERS SETUP, run this command below"
echo "to configure / activate your 'goodtft LCD-show' LCD screen:"
echo " "
echo "~/goodtft-only"
echo " "

echo "(your device will restart automatically afterwards)"
echo "${reset} "

elif [ "$AUTOSTART_ALERT" = "1" ]; then

echo "${red}You must restart your device to auto-start the ticker, by running this command:"
echo " "
echo "sudo reboot"
echo "${reset} "

fi


if [ "$AUTOSTART_ALERT" = "1" ]; then

echo " "
echo "${red}TICKER AUTO-START #REQUIRES# RUNNING THE LXDE DESKTOP AT STARTUP, AS THE USER: '${APP_USER}'${reset}"
echo " "

else

echo " "
echo "${red}TICKER #REQUIRES# RUNNING A DESKTOP INTERFACE AT STARTUP, AS THE USER: '${APP_USER}'${reset}"
echo " "

fi


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo " "


######################################


echo "${yellow}ANY DONATIONS (LARGE OR SMALL) HELP SUPPORT DEVELOPMENT OF MY APPS..."
echo " "
echo "${cyan}Bitcoin: ${green}3Nw6cvSgnLEFmQ1V4e8RSBG23G7pDjF3hW"
echo " "
echo "${cyan}Ethereum: ${green}0x644343e8D0A4cF33eee3E54fE5d5B8BFD0285EF8"
echo " "
echo "${cyan}Helium: ${green}13xs559435FGkh39qD9kXasaAnB8JRF8KowqPeUmKHWU46VYG1h"
echo " "
echo "${cyan}Solana: ${green}GvX4AU4V9atTBof9dT9oBnLPmPiz3mhoXBdqcxyRuQnU"
echo " "


######################################


# Mark the ticker install as having run already, to avoid showing
# the OPTIONAL ticker install options at end of the portfolio install
export TICKER_INSTALL_RAN=1

                    
if [ -z "$FOLIO_INSTALL_RAN" ]; then

echo " "
echo "${red}!!!!!BE SURE TO SCROLL UP, TO SAVE #ALL THE TICKER APP USAGE DOCUMENTATION#"
echo "PRINTED OUT ABOVE, BEFORE YOU SIGN OFF FROM THIS TERMINAL SESSION!!!!!${reset}"

echo " "
echo "Also check out my 100% FREE open source PRIVATE cryptocurrency investment portfolio tracker,"
echo "with email / text / Alexa / Telegram alerts, charts, mining calculators,"
echo "leverage / gain / loss / balance stats, news feeds and more:"
echo " "
echo "https://taoteh1221.github.io"
echo " "
echo "https://github.com/taoteh1221/Open_Crypto_Tracker"
echo " "

echo "Would you like to ${red}ADDITIONALLY / OPTIONALLY${reset} install Open Crypto Portfolio Tracker (server edition), private portfolio tracker on this machine?"
echo " "

echo "Select 1 or 2 to choose whether to ${red}optionally${reset} install the private portfolio tracker, or skip."
echo " "

OPTIONS="install_portfolio_tracker skip"

	select opt in $OPTIONS; do
        if [ "$opt" = "install_portfolio_tracker" ]; then
         
			
			echo " "
			
			echo "${green}Proceeding with portfolio tracker installation, please wait...${reset}"
			
			echo " "
			
			wget --no-cache -O FOLIO-INSTALL.bash https://raw.githubusercontent.com/taoteh1221/Open_Crypto_Tracker/main/FOLIO-INSTALL.bash
			
			chmod +x FOLIO-INSTALL.bash
			
			chown $APP_USER:$APP_USER FOLIO-INSTALL.bash
			
			./FOLIO-INSTALL.bash
			
			
        break
       elif [ "$opt" = "skip" ]; then
       
        echo " "
        echo "${green}Skipping the OPTIONAL portfolio tracker install...${reset}"
		echo " "
		echo "${cyan}Installation / setup has finished, exiting to terminal...${reset}"
        echo " "
		exit
		  
        break
        
       fi
	done


else

echo " "
echo "${cyan}Installation / setup has finished, exiting to terminal...${reset}"
echo " "
echo "${red}!!!!!BE SURE TO SCROLL UP, TO SAVE #ALL THE TICKER APP USAGE DOCUMENTATION#"
echo "PRINTED OUT ABOVE, BEFORE YOU SIGN OFF FROM THIS TERMINAL SESSION!!!!!${reset}"
echo " "
exit

fi


######################################

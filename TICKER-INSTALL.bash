#!/bin/bash



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


# EXPLICITLY set paths 
#PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH


# Bash's FULL PATH
BASH_PATH=$(which bash)
				

# Get logged-in username (if sudo, this works best with logname)
TERMINAL_USERNAME=$(logname)


# Get date
DATE=$(date '+%Y-%m-%d')


# Get the host ip address
IP=`hostname -I` 


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

if [ "$EUID" -ne 0 ] || [ "$TERMINAL_USERNAME" == "root" || [ "$TERMINAL_USERNAME" == "" ]; then 
 echo "${red}Please run with 'sudo' permissions (NOT LOGGED IN AS 'root').${reset}"
 echo "${cyan}Exiting...${reset}"
 exit
fi

######################################


# Start in user home directory
# WE DON'T USE ~/ FOR PATHS IN THIS SCRIPT BECAUSE:
# 1) WE'RE #RUNNING AS SUDO# ANYWAYS (WE CAN INSTALL ANYWHERE WE WANT)
# 2) WE SET THE USER WE WANT TO INSTALL UNDER DYNAMICALLY
# 3) IN CASE THE USER INITIATES INSTALL AS ANOTHER ADMIN USER
cd /home/$TERMINAL_USERNAME


######################################


echo "${yellow}Enter the system username to configure installation for:"
echo "(leave blank / hit enter for default of username '${TERMINAL_USERNAME}')${reset}"
echo " "

read APP_USER
        
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

echo "${yellow}If this information is NOT correct, please quit installation and start again.${reset}"
echo " "

echo "${yellow}Select 1 or 2 to choose whether to continue, or quit.${reset}"
echo " "

OPTIONS="continue quit"

select opt in $OPTIONS; do
        if [ "$opt" = "continue" ]; then
        echo " "
        echo "${green}Continuing with setup...${reset}"
        break
       elif [ "$opt" = "quit" ]; then
        echo " "
        echo "${green}Exiting setup...${reset}"
        exit
        break
       fi
done

echo " "


######################################


# MIGRATE SAFELY TO NEW APP NAMED DIR (we delete the old one if the user completes installation)
\cp -r /home/$APP_USER/dfd-crypto-ticker /home/$APP_USER/slideshow-crypto-ticker > /dev/null 2>&1


echo "${yellow}TECHNICAL NOTE:"
echo "This script was designed to install / setup on the Raspbian operating system, and was "
echo "developed on Raspbian Linux v10, for Raspberry Pi computers WITH SMALL IN-CASE LCD SCREENS."
echo " "
echo "It is ONLY recommended to install this ticker app IF your device has an LCD screen installed.${reset}"
echo " "

echo "${cyan}Your operating system has been detected as:"
echo " "
echo "$OS v$VER${reset}"
echo " "

echo "${yellow}This script may work on other Debian-based systems as well, but it has not been tested for that purpose.${reset}"
echo " "

echo "${red}USE RASPBIAN #FULL# DESKTOP, #NOT# LITE, OR YOU LIKELY WILL HAVE SOME ISSUES WITH CHROMIUM BROWSER EVEN"
echo "AFTER UPGRADING TO GUI / CHROME (trust me)."
echo " "
echo "(Chromium OR Firefox are required [firefox is default, and will be installed if not already])${reset}"
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

  				
echo "${yellow}Select 1 or 2 to choose whether to continue, or quit.${reset}"
echo " "

OPTIONS="continue quit"

select opt in $OPTIONS; do
        if [ "$opt" = "continue" ]; then
        echo " "
        echo "${green}Continuing with setup...${reset}"
        break
       elif [ "$opt" = "quit" ]; then
        echo " "
        echo "${green}Exiting setup...${reset}"
        exit
        break
       fi
done

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

# See if we are running on dietpi OS, as it requires us to install the LXDE desktop
DIETPI_AUTOSTART_PATH=$(which dietpi-autostart)

# If we are running dietpi OS or not
if [ -z "$DIETPI_AUTOSTART_PATH" ]
then

echo "${red}THIS TICKER #REQUIRES# RUNNING THE DESKTOP INTERFACE LXDE AT STARTUP (#already setup# in Raspberry Pi OS Desktop),"
echo "AS THE USER '${APP_USER}', IF YOU WANT THE TICKER TO #AUTOMATICALLY RUN ON SYSTEM STARTUP# / REBOOT.${reset}"

else

echo "${red}WE NEED TO MAKE SURE THE DESKTOP INTERFACE LXDE RUNS AT STARTUP IN DIETPI OS, AS THE USER '${APP_USER}',"
echo "IF YOU WANT THE TICKER TO #AUTOMATICALLY RUN ON SYSTEM STARTUP# / REBOOT.${reset}"
echo " "
echo "${yellow}Select 1 or 2 to choose whether to setup LXDE Desktop autostart, or skip.${reset}"
echo " "
    
    OPTIONS="setup_lxde_autostart skip"
    
    select opt in $OPTIONS; do
            if [ "$opt" = "setup_lxde_autostart" ]; then
            echo " "
            echo "${green}Opening dietpi-autostart...${reset}"
            $DIETPI_AUTOSTART_PATH
            break
           elif [ "$opt" = "skip" ]; then
            echo " "
            echo "${green}Skipping dietpi-autostart...${reset}"
            break
           fi
    done
    
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
				
				sleep 3
				
				# Ubuntu 18.x and higher
				apt-get install libarchive-tools -y
				
				sleep 3
				
				# Firefox on raspbian
				apt-get install firefox-esr -y
				
				sleep 3
				
				# Firefox on ubuntu
				apt-get install firefox -y
				
				sleep 3
				
				# Safely install other packages seperately, so they aren't cancelled by 'package missing' errors
				apt-get install xdotool unclutter sed curl jq openssl wget -y
				
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
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/chromium-refresh.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/ticker-init.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/cron.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/cron/kucoin-auth.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/bash/cron/raspi-temps.bash > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/js/jquery.min.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/js/functions.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/js/init.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/cache/cache.js > /dev/null 2>&1
				rm /home/$APP_USER/slideshow-crypto-ticker/cache/raspi_data.js > /dev/null 2>&1
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
                echo "${yellow}Select 1 or 2 to choose whether to use firefox or chromium, as the browser showing the ticker.${reset}"
                echo " "
                
                USER_BROWSER="firefox chromium"
                
                    select opt in $USER_BROWSER; do
                            if [ "$opt" = "firefox" ]; then
                            SET_BROWSER=$opt
                            echo " "
                            echo "${green}Using $opt browser...${reset}"
                            break
                           elif [ "$opt" = "chromium" ]; then
                            SET_BROWSER=$opt
                            echo " "
                            echo "${green}Using $opt browser...${reset}"
                            break
                           fi
                    done
                
                echo " "

				echo " "
				
				echo "${cyan}Configuring Slideshow Crypto Ticker on your system, please wait...${reset}"

				echo " "
				
				
					if [ -d "/lib/systemd/system" ]; then


# Don't nest / indent, or it could malform the settings            
read -r -d '' TICKER_STARTUP <<- EOF
\r
[Unit]
Description=Chromium Ticker
Wants=graphical.target
After=graphical.target
\r
[Service]
Environment=DISPLAY=:0  
Environment=XAUTHORITY=/home/$APP_USER/.Xauthority
Type=simple
ExecStart=$BASH_PATH /home/$APP_USER/slideshow-crypto-ticker/bash/ticker-auto-start.bash $SET_BROWSER
Restart=on-abort
User=$APP_USER
Group=$APP_USER
\r
[Install]
WantedBy=graphical.target
\r
EOF

					# Setup service to run at boot
					
					echo -e "$TICKER_STARTUP" > /lib/systemd/system/ticker.service
					
					systemctl enable ticker.service
				
					AUTOSTART_ALERT=1
					
					else
					
					AUTOSTART_ALERT=2
					
					fi
					


# Don't nest / indent, or it could malform the settings            
read -r -d '' TICKER_BROWSER <<- EOF
#!/bin/bash
\r
DEFAULT_BROWSER="$SET_BROWSER"
export DEFAULT_BROWSER="$SET_BROWSER"
\r
EOF
					mkdir /home/$APP_USER/slideshow-crypto-ticker/cache > /dev/null 2>&1
					
					chmod 777 /home/$APP_USER/slideshow-crypto-ticker/cache > /dev/null 2>&1
					
					chown $APP_USER:$APP_USER /home/$APP_USER/slideshow-crypto-ticker/cache > /dev/null 2>&1
					
					echo -e "$TICKER_BROWSER" > /home/$APP_USER/slideshow-crypto-ticker/cache/browser.bash
					
					chmod 755 /home/$APP_USER/slideshow-crypto-ticker/cache/browser.bash > /dev/null 2>&1
					
					chown $APP_USER:$APP_USER /home/$APP_USER/slideshow-crypto-ticker/cache/browser.bash > /dev/null 2>&1
					
					
				# Setup cron (to check logs after install: tail -f /var/log/syslog | grep cron -i)

				CRONJOB="* * * * * $APP_USER $BASH_PATH /home/$APP_USER/slideshow-crypto-ticker/bash/cron/cron.bash > /dev/null 2>&1"

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
			
			echo "${cyan}Proceeding with required component installation, please wait...${reset}"
			
			echo " "
			
			apt-get install git -y
			
			echo " "
			
			echo "${cyan}Required component installation completed.${reset}"
			
			sleep 3
			
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
echo "/lib/systemd/system/ticker.service${reset}"
echo " "
echo "${yellow}(the ticker will now start at boot/login with the $SET_BROWSER browser)${reset}"
echo " "

elif [ "$AUTOSTART_ALERT" = "2" ]; then

echo "${red}'systemd' settings could NOT be detected on your system,"
echo "ticker autostart at system boot COULD NOT BE ENABLED.${reset}"
echo " "	

fi


if [ "$CRON_SETUP" = "1" ]; then

echo "${green}A cron job has been setup for user '$APP_USER', as a command in /etc/cron.d/ticker:"
echo " "
echo "$CRONJOB"
echo "${reset} "

fi


if [ "$AUTOSTART_ALERT" = "1" ] || [ "$AUTOSTART_ALERT" = "2" ]; then

echo "${yellow}If autostart does not work / is not setup, you can run this command MANUALLY,"
echo "#AFTER BOOTING INTO THE DESKTOP INTERFACE#, to start Slideshow Crypto Ticker:"
echo " "
echo "~/ticker-start"
echo " "
echo "If you prefer firefox or chromium (you set $SET_BROWSER as the default):"
echo " "
echo "~/ticker-start firefox"
echo " "
echo "~/ticker-start chromium"
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
echo "If you prefer firefox or chromium (firefox is the default):"
echo " "
echo "~/ticker-start firefox"
echo " "
echo "~/ticker-start chromium"
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

elif [ "$AUTOSTART_ALERT" = "1" ] || [ "$AUTOSTART_ALERT" = "2" ]; then

echo "${red}You must restart your device to auto-start the ticker, by running this command:"
echo " "
echo "sudo reboot"
echo "${reset} "

fi


if [ "$AUTOSTART_ALERT" = "1" ] || [ "$AUTOSTART_ALERT" = "2" ]; then

echo " "
echo "${red}TICKER AUTO-START #REQUIRES# RUNNING THE RASPBERRY PI GRAPHICAL DESKTOP INTERFACE (LXDE) AT STARTUP, AS THE USER: '${APP_USER}'${reset}"
echo " "

else

echo " "
echo "${red}TICKER #REQUIRES# RUNNING A GRAPHICAL DESKTOP INTERFACE AT STARTUP, AS THE USER: '${APP_USER}'${reset}"
echo " "

fi


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo " "


######################################


echo " "
echo "Also check out my 100% FREE open source PRIVATE cryptocurrency investment portfolio tracker,"
echo "with email / text / Alexa / Ghome / Telegram alerts, charts, mining calculators,"
echo "leverage / gain / loss / balance stats, news feeds and more:"
echo " "
echo "https://taoteh1221.github.io"
echo " "
echo "https://github.com/taoteh1221/Open_Crypto_Portfolio_Tracker"
echo " "

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
echo "${red}!!!!!BE SURE TO SCROLL UP, TO SAVE #ALL THE TICKER APP USAGE DOCUMENTATION#"
echo "PRINTED OUT ABOVE, BEFORE YOU SIGN OFF FROM THIS TERMINAL SESSION!!!!!${reset}"
echo " "



######################################


# Mark the ticker install as having run already, to avoid showing
# the OPTIONAL ticker install options at end of the portfolio install
export TICKER_INSTALL_RAN=1

                    
if [ -z "$FOLIO_INSTALL_RAN" ]; then


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
			
			wget --no-cache -O FOLIO-INSTALL.bash https://raw.githubusercontent.com/taoteh1221/Open_Crypto_Portfolio_Tracker/main/FOLIO-INSTALL.bash
			
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
        echo "${red}!!!!!BE SURE TO SCROLL UP, TO SAVE #ALL THE TICKER APP USAGE DOCUMENTATION#"
        echo "PRINTED OUT ABOVE, BEFORE YOU SIGN OFF FROM THIS TERMINAL SESSION!!!!!${reset}"
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

#!/bin/bash

######################################

echo " "

if [ "$EUID" -ne 0 ]; then 
 echo "Please run as root (or sudo)."
 echo "Exiting..."
 exit
fi


######################################


# Get logged-in username (if sudo, this works best with logname)
USERNAME=$(/usr/bin/logname)


# Get date
DATE=$(date '+%Y-%m-%d')


# Get the host ip address
IP=`/bin/hostname -I` 


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


echo "Enter the system username to configure installation for:"
echo "(leave blank / hit enter for default of username '${USERNAME}')"
echo " "

read SYS_USER
        
if [ -z "$SYS_USER" ]; then
SYS_USER=${1:-$USERNAME}
echo "Using default username: $SYS_USER"
else
echo "Using username: $SYS_USER"
fi


if [ ! -d "/home/$SYS_USER/" ]; then    		
echo " "
echo "Directory /home/$SYS_USER/ DOES NOT exist, cannot install DFD Crypto Ticker."
echo " "
echo "Please create user $SYS_USER's home directory before running this installation."
exit
fi

echo " "


######################################

  				
echo "You have set the user information as..."
echo "User: $SYS_USER"
echo "User home directory: /home/$SYS_USER/"
echo " "

echo "If this information is NOT correct, please quit installation and start again."
echo " "

echo "Select 1 or 2 to choose whether to continue, or quit."
echo " "

OPTIONS="continue quit"

select opt in $OPTIONS; do
        if [ "$opt" = "continue" ]; then
        echo " "
        echo "Continuing with setup..."
        break
       elif [ "$opt" = "quit" ]; then
        echo " "
        echo "Exiting setup..."
        exit
        break
       fi
done

echo " "


######################################


echo "TECHNICAL NOTE:"
echo "This script was designed to install / setup on the Raspbian operating system,"
echo "and was developed / created on Raspbian Linux v10, for Raspberry Pi computers"
echo "WITH SMALL IN-CASE LCD SCREENS."
echo " "
echo "It is ONLY recommended to install this ticker app"
echo "IF your device has an LCD screen installed."
echo " "

echo "Your operating system has been detected as:"
echo "$OS v$VER"
echo " "

echo "This script may work on other Debian-based systems as well, but it has not been tested for that purpose."
echo " "

echo "USE RASPBIAN FULL DESKTOP, #NOT# LITE, OR YOU LIKELY WILL HAVE SOME"
echo "CHROMIUM BROWSER ISSUES EVEN AFTER UPGRADING TO GUI / CHROME (trust me)."
echo "(GUI desktop and Chromium browser are required for this ticker app)"
echo " "

if [ -f "/etc/debian_version" ]; then
echo "Your system has been detected as Debian-based, which is compatible with this automated installation script."
echo "Continuing..."
echo " "
else
echo "Your system has been detected as NOT BEING Debian-based. Your system is NOT compatible with this automated installation script."
echo "Exiting..."
exit
fi
  				
				
if [ -f /home/$SYS_USER/dfd-crypto-ticker/config.js ]; then
echo "A configuration file from a previous install of DFD Crypto Ticker has been detected on your system."
echo "During this upgrade / re-install, it will be backed up to:"
echo "/home/$SYS_USER/dfd-crypto-ticker/config.js.BACKUP.$DATE"
echo "This will save any custom settings within it."
echo "You will need to manually move any custom settings in this backup file to the new config.js file with a text editor."
echo " "
fi


echo "PLEASE REPORT ANY ISSUES HERE: https://github.com/taoteh1221/DFD_Crypto_Ticker/issues"
echo " "

  				
echo "Select 1 or 2 to choose whether to continue, or quit."
echo " "

OPTIONS="continue quit"

select opt in $OPTIONS; do
        if [ "$opt" = "continue" ]; then
        echo " "
        echo "Continuing with setup..."
        break
       elif [ "$opt" = "quit" ]; then
        echo " "
        echo "Exiting setup..."
        exit
        break
       fi
done

echo " "


######################################


echo " "

echo "Making sure your system is updated before installation, please wait..."

echo " "
			
/usr/bin/sudo /usr/bin/apt-get update

#DO NOT RUN dist-upgrade, bad things can happen, lol
/usr/bin/sudo /usr/bin/apt-get upgrade -y

echo " "
				
echo "System update completed."
				
sleep 3
				
echo " "


######################################


echo "Do you want this script to automatically download the latest version of"
echo "DFD Crypto Ticker from Github.com, and install it?"
echo "(auto-install will overwrite / upgrade any previous install located at: /home/$SYS_USER/dfd-crypto-ticker)"
echo " "

echo "Select 1, 2, or 3 to choose whether to auto-install / remove DFD Crypto Ticker, or skip."
echo " "

OPTIONS="install_ticker_app remove_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_ticker_app" ]; then
        
        	
				echo " "
				
				echo "Proceeding with required component installation, please wait..."
				
				echo " "
				
				/usr/bin/sudo /usr/bin/apt-get install xdotool unclutter sed curl jq bsdtar openssl -y
				
				echo " "
				
				echo "Required component installation completed."
				
				sleep 3
				
				echo " "
				
				
					if [ -f /home/$SYS_USER/dfd-crypto-ticker/config.js ]; then
					
					\cp /home/$SYS_USER/dfd-crypto-ticker/config.js /home/$SYS_USER/dfd-crypto-ticker/config.js.BACKUP.$DATE
						
					/bin/chown $SYS_USER:$SYS_USER /home/$SYS_USER/dfd-crypto-ticker/config.js.BACKUP.$DATE
						
					CONFIG_BACKUP=1
					
					fi
				
				
				echo "Downloading and installing the latest version of DFD Crypto Ticker, from Github.com, please wait..."
				
				echo " "
				
				mkdir DFD-Crypto-Ticker
				
				cd DFD-Crypto-Ticker
				
				ZIP_DL=$(/usr/bin/curl -s 'https://api.github.com/repos/taoteh1221/DFD_Crypto_Ticker/releases/latest' | /usr/bin/jq -r '.zipball_url')
				
				/usr/bin/wget -O DFD-Crypto-Ticker.zip $ZIP_DL
				
				/usr/bin/bsdtar --strip-components=1 -xvf DFD-Crypto-Ticker.zip
				
				rm DFD-Crypto-Ticker.zip
				
				# Remove depreciated directory structure from any previous installs
				rm -rf /home/$SYS_USER/dfd-crypto-ticker/apps 
				rm -rf /home/$SYS_USER/dfd-crypto-ticker/scripts

				/bin/sleep 1
				
  				# Copy over the upgrade install files to the install directory, after cleaning up dev files
				# No trailing forward slash here
				
  				mkdir -p /home/$SYS_USER/dfd-crypto-ticker
				
				rm -rf .git
				rm -rf .github
				rm .gitattributes
				rm .gitignore
				rm CODEOWNERS
				
				\cp -r ./ /home/$SYS_USER/dfd-crypto-ticker

				/bin/sleep 3
				
				cd ../
				
				rm -rf DFD-Crypto-Ticker
				
				/bin/chmod -R 755 /home/$SYS_USER/dfd-crypto-ticker/bash
				
				# No trailing forward slash here
				/bin/chown -R $SYS_USER:$SYS_USER /home/$SYS_USER/dfd-crypto-ticker
				
				# If an older depreciated version, just re-create the symlink after deleting to be safe
				
				rm /home/$SYS_USER/reload
				
				/bin/sleep 1
			
				ln -s /home/$SYS_USER/dfd-crypto-ticker/bash/chromium-refresh.bash /home/$SYS_USER/reload
				
				/bin/chown $SYS_USER:$SYS_USER /home/$SYS_USER/reload
				
				echo " "
				
				echo "DFD Crypto Ticker has been installed."
				
	        	INSTALL_SETUP=1
   	     	
   	     	
        break
       elif [ "$opt" = "remove_ticker_app" ]; then
       
        echo " "
        echo "Removing DFD Crypto Ticker, please wait..."
        
        rm /etc/cron.d/ticker
        
        rm /lib/systemd/system/ticker.service
        
        rm /home/$SYS_USER/reload
        
        rm -rf /home/$SYS_USER/dfd-crypto-ticker

		  /bin/sleep 3
        
		  echo " "
		  echo "DFD Crypto Ticker has been removed from the system, please reboot to complete the removal process."
        
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping auto-install of DFD Crypto Ticker."
        break
       fi
done

echo " "



######################################


echo "Do you want to automatically configure DFD Crypto Ticker for"
echo "your system (autostart at login / keep screen turned on)?"
echo " "

echo "Select 1 or 2 to choose whether to auto-configure DFD Crypto Ticker system settings, or skip it."
echo " "

OPTIONS="auto_config_ticker_system skip"

select opt in $OPTIONS; do
        if [ "$opt" = "auto_config_ticker_system" ]; then
        

				echo " "
				
				echo "Configuring DFD Crypto Ticker on your system, please wait..."

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
Environment=XAUTHORITY=/home/$SYS_USER/.Xauthority
Type=simple
ExecStart=/bin/bash /home/$SYS_USER/dfd-crypto-ticker/bash/ticker-init.bash
Restart=on-abort
User=$SYS_USER
Group=$SYS_USER
\r
[Install]
WantedBy=graphical.target
\r
EOF

					# Setup service to run at boot

					/usr/bin/touch /lib/systemd/system/ticker.service
					
					echo -e "$TICKER_STARTUP" > /lib/systemd/system/ticker.service
					
					/bin/systemctl enable ticker.service
				
					AUTOSTART_ALERT=1
					
					else
					
					AUTOSTART_ALERT=2
					
					fi
					
					
				# Setup cron (to check logs after install: tail -f /var/log/syslog | grep cron -i)
				
				/usr/bin/touch /etc/cron.d/ticker

				CRONJOB="* * * * * $SYS_USER /bin/bash /home/$SYS_USER/dfd-crypto-ticker/bash/keep-screensaver-off.bash > /dev/null 2>&1"

				# Play it safe and be sure their is a newline after this job entry
				echo -e "$CRONJOB\n" > /etc/cron.d/ticker
				
		  		# cron.d entries must be a permission of 644
		  		/bin/chmod 644 /etc/cron.d/ticker
		  		
				# cron.d entries MUST BE OWNED BY ROOT
				/bin/chown root:root /etc/cron.d/ticker
				
        		CRON_SETUP=1
				
				echo " "
				echo "DFD Crypto Ticker system configuration complete."

				echo " "
				
	        	CONFIG_SETUP=1
   	     	

        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping auto-configuration of DFD Crypto Ticker system settings."
        break
       fi
done

echo " "



######################################



echo "WARNING:"
echo "#DO NOT INSTALL# THE 'goodtft LCD-show' LCD DRIVERS BELOW, UNLESS YOU HAVE A 'goodtft LCD-show' LCD SCREEN!"
echo " "

echo "Select 1 or 2 to choose whether to install 'goodtft LCD-show' LCD drivers, or skip."
echo " "

OPTIONS="install_goodtft skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_goodtft" ]; then
         
			
			echo " "
			
			echo "Proceeding with required component installation, please wait..."
			
			echo " "
			
			/usr/bin/sudo /usr/bin/apt-get install git -y
			
			echo " "
			
			echo "Required component installation completed."
			
			sleep 3
			
			echo " "
			echo "Setting up for 'goodtft LCD-show' LCD drivers, please wait..."
			echo " "
			
			ln -s /home/$SYS_USER/dfd-crypto-ticker/bash/switch-display.bash /home/$SYS_USER/display
				
			/bin/chown $SYS_USER:$SYS_USER /home/$SYS_USER/display
			
			mkdir -p /home/$SYS_USER/goodtft/builds
			
			cd /home/$SYS_USER/goodtft/builds
			
			/usr/bin/git clone https://github.com/goodtft/LCD-show.git
			
			/bin/chmod -R 755 /home/$SYS_USER/goodtft/builds
			
			# No trailing forward slash here
			/bin/chown -R $SYS_USER:$SYS_USER /home/$SYS_USER/goodtft/builds

				
			echo " "
			echo "'goodtft LCD-show' LCD driver setup completed."
				
			echo " "
			
			
			GOODTFT_SETUP=1
			
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping 'goodtft LCD-show' LCD driver setup..."
        break
       fi
done

echo " "


######################################
			
# Return to user's home directory
cd /home/$SYS_USER/


echo " "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "# SAVE THE INFORMATION BELOW FOR FUTURE ACCESS TO THIS APP #"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " "



if [ "$AUTOSTART_ALERT" = "1" ]; then

echo "Ticker autostart at login has been configured at:"
echo "/lib/systemd/system/ticker.service"
echo "(the ticker will now start at boot/login)"
echo " "

elif [ "$AUTOSTART_ALERT" = "2" ]; then

echo "systemd settings could NOT be detected on your system,"
echo "ticker autostart at system boot COULD NOT BE ENABLED."
echo " "	

fi



if [ "$AUTOSTART_ALERT" = "1" ] || [ "$AUTOSTART_ALERT" = "2" ]; then

echo "Regardless of autostart being enabled or not, you can run this command"
echo "AFTER system boot MANUALLY, to start DFD Crypto Ticker:"
echo "bash ~/dfd-crypto-ticker/bash/ticker-init.bash &>/dev/null &"
echo " "
					

fi



if [ "$CONFIG_BACKUP" = "1" ]; then

echo "The previously-installed DFD Crypto Ticker configuration"
echo "file /home/$SYS_USER/dfd-crypto-ticker/config.js has been backed up to:"
echo "/home/$SYS_USER/dfd-crypto-ticker/config.js.BACKUP.$DATE"
echo "You will need to manually move any custom settings in this backup file to the new config.js file with a text editor."
echo " "

fi



if [ "$CRON_SETUP" = "1" ]; then

echo "A cron job has been setup for user '$SYS_USER',"
echo "as a command in /etc/cron.d/ticker:"
echo "$CRONJOB"
echo " "

fi



echo "Edit the following file in a text editor to switch between different"
echo "exchanges / crypto assets / base pairings, and to configure settings"
echo "for slideshow speed / font sizes and colors / background color"
echo "/ vertical position / screen orientation / google font used / monospace emulation:"
echo "/home/$SYS_USER/dfd-crypto-ticker/config.js"
echo " "

echo "Example editing config.js in nano by command-line:"
echo "nano ~/dfd-crypto-ticker/config.js"
echo " "

echo "After updating config.js, reload the ticker with this command:"
echo "~/reload"
echo " "

echo "Ticker installation / setup should be complete (if you chose those options), unless you saw any error messages on your screen during setup."
echo " "


if [ "$GOODTFT_SETUP" = "1" ]; then

echo "TO COMPLETE THE 'goodtft LCD-show' LCD DRIVERS SETUP, run this command below"
echo "to configure / activate your 'goodtft LCD-show' LCD screen:"
echo "~/display"
echo " "

echo "(your device will restart automatically afterwards)"
echo " "

else

echo "You must restart your device to activate the ticker, by running this command:"
echo "sudo reboot"
echo " "

fi

echo "WITH BRAND NEW INSTALLATIONS, YOU #MAY NEED TO REBOOT TWO TIMES# TO ACTIVATE THE TICKER STARTING AT BOOT TIME AUTOMATICALLY."
echo " "

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo " "


######################################


echo " "
echo "BE SURE TO SAVE ALL THE ACCESS DETAILS PRINTED OUT ABOVE, BEFORE YOU SIGN OFF FROM THIS TERMINAL SESSION."
echo " "
echo "Also check out my 100% FREE open source cryptocurrency investment portfolio tracker,"
echo "with email / text / Alexa / Ghome / Telegram alerts, charts, mining calculators,"
echo "leverage / gain / loss / balance stats, news feeds and more:"
echo " "
echo "https://taoteh1221.github.io"
echo " "
echo "https://github.com/taoteh1221/DFD_Cryptocoin_Values"
echo " "



######################################



echo "Would you like to ADDITIONALLY install DFD Cryptocoin Values (server edition), private portfolio tracker on this machine?"
echo " "

echo "Select 1 or 2 to choose whether to install the private portfolio tracker, or skip."
echo " "

OPTIONS="install_portfolio_tracker skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_portfolio_tracker" ]; then
         
			
			echo " "
			
			echo "Proceeding with portfolio tracker installation, please wait..."
			
			echo " "
			
			/usr/bin/wget -O FOLIO-INSTALL.bash https://raw.githubusercontent.com/taoteh1221/DFD_Cryptocoin_Values/main/FOLIO-INSTALL.bash
			
			/bin/chmod +x FOLIO-INSTALL.bash
			
			/usr/bin/sudo ./FOLIO-INSTALL.bash
			
			
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping portfolio tracker install..."
        break
       fi
done

echo " "


######################################

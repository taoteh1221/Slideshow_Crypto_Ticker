#!/bin/bash

######################################

echo " "

if [ "$EUID" -ne 0 ]; then 
 echo "Please run as root (or sudo)."
 echo "Exiting..."
 exit
fi


######################################


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
echo "(leave blank / hit enter for default of username 'pi')"
echo " "

read SYS_USER
        
if [ -z "$SYS_USER" ]; then
SYS_USER=${1:-pi}
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
echo "This script was designed to install / setup on the Raspian operating system,"
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

if [ -f "/etc/debian_version" ]; then
echo "Your system has been detected as Debian-based, which is compatible with this automated installation script."
echo "Continuing..."
echo " "
else
echo "Your system has been detected as NOT BEING Debian-based. Your system is NOT compatible with this automated installation script."
echo "Exiting..."
exit
fi
  				
				
if [ -f /home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js ]; then
echo "A configuration file from a previous install of DFD Crypto Ticker has been detected on your system."
echo "During this upgrade / re-install, it will be backed up to:"
echo "/home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js.BACKUP.$DATE"
echo "This will save any custom settings within it."
echo "You will need to manually move any custom settings in this backup file to the new config.js file with a text editor."
echo " "
fi

  				
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

echo "Making sure your system is updated before installation..."

echo " "
			
/usr/bin/sudo /usr/bin/apt-get update

/usr/bin/sudo /usr/bin/apt-get upgrade -y

/usr/bin/sudo /usr/bin/apt-get dist-upgrade -y

/usr/bin/sudo /usr/bin/apt-get clean

echo " "
				
echo "Proceeding with required component installation..."
				
echo " "
				
/usr/bin/sudo /usr/bin/apt-get install xdotool unclutter raspberrypi-ui-mods rpi-chromium-mods -y

echo " "
				
echo "System update / required component installation completed."
				
sleep 3
				
echo " "


######################################


echo "Do you want this script to automatically download the latest version of"
echo "DFD Crypto Ticker from Github.com, and install it?"
echo "(auto-install will overwrite / upgrade any previous install located at: /home/$SYS_USER/dfd-crypto-ticker)"
echo " "

echo "Select 1 or 2 to choose whether to auto-install DFD Crypto Ticker, or skip it."
echo " "

OPTIONS="auto_install_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "auto_install_ticker_app" ]; then
        
        	
				echo " "
				
				echo "Proceeding with required component installation..."
				
				echo " "
				
				/usr/bin/sudo /usr/bin/apt-get install curl jq bsdtar openssl -y
				
				echo " "
				
				echo "Required component installation completed."
				
				sleep 3
				
				echo " "
				
				
					if [ -f /home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js ]; then
					
					\cp /home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js /home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js.BACKUP.$DATE
						
					/bin/chown $SYS_USER:$SYS_USER /home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js.BACKUP.$DATE
						
					CONFIG_BACKUP=1
					
					fi
				
				
				echo "Downloading and installing the latest version of DFD Crypto Ticker, from Github.com..."
				
				echo " "
				
				mkdir DFD-Crypto-Ticker
				
				cd DFD-Crypto-Ticker
				
				ZIP_DL=$(/usr/bin/curl -s 'https://api.github.com/repos/taoteh1221/DFD_Crypto_Ticker/releases/latest' | /usr/bin/jq -r '.zipball_url')
				
				/usr/bin/wget -O DFD-Crypto-Ticker.zip $ZIP_DL
				
				/usr/bin/bsdtar --strip-components=1 -xvf DFD-Crypto-Ticker.zip
				
				rm DFD-Crypto-Ticker.zip
				
  				mkdir -p /home/$SYS_USER/dfd-crypto-ticker
  				
				cd dfd-crypto-ticker
				
				# No trailing forward slash here
				\cp -r ./ /home/$SYS_USER/dfd-crypto-ticker
				
				cd ../
				
				\cp LICENSE /home/$SYS_USER/dfd-crypto-ticker/LICENSE
				
				\cp README.txt /home/$SYS_USER/dfd-crypto-ticker/README.txt
				
				\cp TICKER-INSTALL.bash /home/$SYS_USER/dfd-crypto-ticker/TICKER-INSTALL.bash
				
				cd ../
				
				rm -rf DFD-Crypto-Ticker
				
				# No trailing forward slash here
				/bin/chown -R $SYS_USER:$SYS_USER /home/$SYS_USER/dfd-crypto-ticker
				
				echo " "
				
				echo "DFD Crypto Ticker has been installed."
				
	        	INSTALL_SETUP=1
   	     	
   	     	

        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping auto-install of DFD Crypto Ticker."
        break
       fi
done

echo " "



######################################


echo "Do you want to automatically configure DFD Crypto Ticker?"
echo " "

echo "Select 1 or 2 to choose whether to auto-configure DFD Crypto Ticker, or skip it."
echo " "

OPTIONS="auto_config_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "auto_config_ticker_app" ]; then
        

				echo " "
				
				echo "Configuring DFD Crypto Ticker..."

				echo " "

				/bin/chmod -R 755 /home/$SYS_USER/dfd-crypto-ticker/scripts
			
				ln -s /home/$SYS_USER/dfd-crypto-ticker/scripts/chromium-refresh.bash /home/$SYS_USER/reload
				
				/bin/chown $SYS_USER:$SYS_USER /home/$SYS_USER/reload
				
				
					if [ -d "/etc/xdg/lxsession" ]; then
					
					NEWEST_DIR=$(ls -td -- /etc/xdg/lxsession/* | head -n 1)
					
					LXDE_PROFILE=$(/usr/bin/basename $NEWEST_DIR)
				
					GLOBAL_LXDE=$(</etc/xdg/lxsession/$LXDE_PROFILE/autostart)
				
					mkdir -p /home/$SYS_USER/.config/lxsession/$LXDE_PROFILE/

					/usr/bin/touch /home/$SYS_USER/.config/lxsession/$LXDE_PROFILE/autostart

					echo -e "$GLOBAL_LXDE \n@/bin/bash /home/pi/dfd-crypto-ticker/scripts/ticker-init.bash & \n" > /home/$SYS_USER/.config/lxsession/$LXDE_PROFILE/autostart
				
					/bin/chown -R $SYS_USER:$SYS_USER /home/$SYS_USER/.config
				
					LXDE_ALERT=1
					
					else
					
					LXDE_ALERT=2
					
					fi
					
					
				# Setup cron (to check logs after install: tail -f /var/log/syslog | grep cron -i)
				
				/usr/bin/touch /etc/cron.d/ticker

				CRONJOB="* * * * * $SYS_USER /bin/bash /home/$SYS_USER/dfd-crypto-ticker/scripts/keep-screensaver-off.bash > /dev/null 2>&1"

				# Play it safe and be sure their is a newline after this job entry
				echo -e "$CRONJOB\n" > /etc/cron.d/ticker
				
		  		# cron.d entries must be a permission of 644
		  		/bin/chmod 644 /etc/cron.d/ticker
		  		
				# cron.d entries MUST BE OWNED BY ROOT
				/bin/chown root:root /etc/cron.d/ticker
				
        		CRON_SETUP=1
				
				echo " "
				echo "Ticker configuration complete."

				echo " "
				
				echo "DFD Crypto Ticker has been configured."
				
	        	CONFIG_SETUP=1
   	     	

        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping auto-configuration of DFD Crypto Ticker."
        break
       fi
done

echo " "



######################################



######################################


echo "WARNING:"
echo "DO NOT install the 'goodtft LCD-show' LCD drivers below, UNLESS YOU HAVE A 'goodtft LCD-show' LCD SCREEN."
echo " "

echo "Select 1 or 2 to choose whether to install 'goodtft LCD-show' LCD drivers, or skip."
echo " "

OPTIONS="install_goodtft skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_goodtft" ]; then
         
			
			echo " "
			
			echo "Making sure your system is updated before installing required components..."
			
			echo " "
			
			/usr/bin/sudo /usr/bin/apt-get update
			
			/usr/bin/sudo /usr/bin/apt-get upgrade -y
			
			echo " "
			
			echo "Proceeding with required component installation..."
			
			echo " "
			
			/usr/bin/sudo /usr/bin/apt-get install git -y
			
			echo " "
			
			echo "Required component installation completed."
			
			sleep 3
			
			echo " "
			echo "Setting up for 'goodtft LCD-show' LCD devices..."
			echo " "
			
			ln -s /home/$SYS_USER/dfd-crypto-ticker/scripts/switch-display.bash /home/$SYS_USER/display
				
			/bin/chown $SYS_USER:$SYS_USER /home/$SYS_USER/display
			
			mkdir -p /home/$SYS_USER/dfd-crypto-ticker/builds
			
			cd /home/$SYS_USER/dfd-crypto-ticker/builds
			
			/usr/bin/git clone https://github.com/goodtft/LCD-show.git
			
			cd /home/$SYS_USER/dfd-crypto-ticker/
			
			/bin/chmod -R 755 /home/$SYS_USER/dfd-crypto-ticker/builds
			
			# No trailing forward slash here
			/bin/chown -R $SYS_USER:$SYS_USER /home/$SYS_USER/dfd-crypto-ticker/builds

				
			echo " "
			echo "'goodtft LCD-show' LCD device setup completed."
				
			echo " "
			
			
			GOODTFT_SETUP=1
			
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping 'goodtft LCD-show' LCD setup..."
        break
       fi
done

echo " "


######################################


echo " "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "# SAVE THE INFORMATION BELOW FOR FUTURE ACCESS TO THIS APP #"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " "



if [ "$LXDE_ALERT" = "1" ]; then

echo "The most recent LXDE Desktop profile name on your operating system has been detected as:"
echo "$LXDE_PROFILE"
echo " "

echo "LXDE Desktop settings have been detected on your system successfully,"
echo "and autostart at system boot has been enabled for DFD Crypto Ticker."
echo " "

elif [ "$LXDE_ALERT" = "2" ]; then

echo "LXDE Desktop settings could NOT be detected on your system,"
echo "autostart at system boot COULD NOT BE ENABLED."
echo " "

echo "Please make sure LXDE Desktop has been setup on your device as the default desktop,"
echo "if you wish to enable autostart at system boot."
echo " "	

fi



if [ "$LXDE_ALERT" = "1" ] || [ "$LXDE_ALERT" = "2" ]; then

echo "Regardless of autostart being enabled or not, you can run this command"
echo "AFTER system boot MANUALLY, to start DFD Crypto Ticker:"
echo "bash ~/dfd-crypto-ticker/scripts/ticker-init.bash &>/dev/null &"
echo " "
					

fi



if [ "$GOODTFT_SETUP" = "1" ]; then

echo "Run the below command to configure your 'goodtft LCD-show' LCD screen:"
echo "~/display"
echo " "

fi



if [ "$CONFIG_BACKUP" = "1" ]; then

echo "The previously-installed DFD Crypto Ticker configuration"
echo "file /home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js has been backed up to:"
echo "/home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js.BACKUP.$DATE"
echo "You will need to manually move any custom settings in this backup file to the new config.js file with a text editor."
echo " "

fi



if [ "$CRON_SETUP" = "1" ]; then

echo "A cron job has been setup for user '$SYS_USER',"
echo "as a command in /etc/cron.d/ticker:"
echo "$CRONJOB"
echo " "

echo "Double-check that the command 'crontab -e' does not have any OLD MATCHING entries"
echo "pointing to the same cron job, OR YOUR CRON JOB WILL RUN TOO OFTEN."
echo "(when /etc/cron.d/ is used, then 'crontab -e' should NOT BE USED for the same cron job)"
echo " "

fi



echo "Edit the following file in a text editor to switch between the"
echo "different Coinbase Pro crypto assets and their paired markets: "
echo "/home/$SYS_USER/dfd-crypto-ticker/apps/ticker/config.js"
echo " "

echo "Example editing config.js in nano by command-line:"
echo "nano ~/dfd-crypto-ticker/apps/ticker/config.js"
echo " "

echo "After updating config.js, reload the ticker with this command:"
echo "~/reload"
echo " "

echo "Ticker installation should be complete, unless you saw any error messages on your screen."
echo "You must restart your device to activate the ticker, by running this command:"
echo "sudo reboot"
echo " "

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"



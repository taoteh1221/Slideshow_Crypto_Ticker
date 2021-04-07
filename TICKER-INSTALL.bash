#!/bin/bash

######################################

echo " "

if [ "$EUID" -ne 0 ]; then 
 echo "Please run as root (or sudo)."
 echo "Exiting..."
 exit
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



# Start in user home directory
# WE DON'T USE ~/ FOR PATHS IN THIS SCRIPT BECAUSE:
# 1) WE'RE #RUNNING AS SUDO# ANYWAYS (WE CAN INSTALL ANYWHERE WE WANT)
# 2) WE SET THE USER WE WANT TO INSTALL UNDER DYNAMICALLY
# 3) IN CASE THE USER INITIATES INSTALL AS ANOTHER ADMIN USER
cd /home/$TERMINAL_USERNAME


######################################


echo "Enter the system username to configure installation for:"
echo "(leave blank / hit enter for default of username '${TERMINAL_USERNAME}')"
echo " "

read APP_USER
        
if [ -z "$APP_USER" ]; then
APP_USER=${1:-$TERMINAL_USERNAME}
echo "Using default username: $APP_USER"
else
echo "Using username: $APP_USER"
fi


if [ ! -d "/home/$APP_USER/" ]; then    		
echo " "
echo "Directory /home/$APP_USER/ DOES NOT exist, cannot install Slideshow Crypto Ticker."
echo " "
echo "Please create user $APP_USER's home directory before running this installation."
exit
fi

echo " "


######################################

  				
echo "You have set the user information as..."
echo " "
echo "User: $APP_USER"
echo " "
echo "User home directory: /home/$APP_USER/"
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
echo "This script was designed to install / setup on the Raspbian operating system, and was "
echo "developed on Raspbian Linux v10, for Raspberry Pi computers WITH SMALL IN-CASE LCD SCREENS."
echo " "
echo "It is ONLY recommended to install this ticker app IF your device has an LCD screen installed."
echo " "

echo "Your operating system has been detected as:"
echo " "
echo "$OS v$VER"
echo " "

echo "This script may work on other Debian-based systems as well, but it has not been tested for that purpose."
echo " "

echo "USE RASPBIAN #FULL# DESKTOP, #NOT# LITE, OR YOU LIKELY WILL HAVE SOME CHROMIUM BROWSER ISSUES EVEN"
echo "AFTER UPGRADING TO GUI / CHROME (trust me)."
echo " "
echo "(GUI desktop and Chromium browser are required for this ticker app)"
echo " "

if [ -f "/etc/debian_version" ]; then
echo "Your system has been detected as Debian-based, which is compatible with this automated installation script."
echo " "
echo "Continuing..."
echo " "
else
echo "Your system has been detected as NOT BEING Debian-based. Your system is NOT compatible with this automated installation script."
echo " "
echo "Exiting..."
exit
fi
  				
				
if [ -f /home/$APP_USER/dfd-crypto-ticker/config.js ]; then
echo "A configuration file from a previous install of Slideshow Crypto Ticker has been detected on your system."
echo " "
echo "During this upgrade / re-install, it will be backed up to:"
echo " "
echo "/home/$APP_USER/dfd-crypto-ticker/config.js.BACKUP.$DATE"
echo " "
echo "This will save any custom settings within it."
echo " "
echo "You will need to manually move any custom settings in this backup file to the new config.js file with a text editor."
echo " "
fi


echo "PLEASE REPORT ANY ISSUES HERE: https://github.com/taoteh1221/Slideshow_Crypto_Ticker/issues"
echo " "


echo "THIS TICKER INSTALL #REQUIRES# RUNNING THE RASPBERRY PI GRAPHICAL DESKTOP INTERFACE (LXDE) AT STARTUP, AS THE USER: '${APP_USER}'"
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
			
apt-get update

#DO NOT RUN dist-upgrade, bad things can happen, lol
apt-get upgrade -y

echo " "
				
echo "System update completed."
				
sleep 3
				
echo " "


######################################


echo "Do you want this script to automatically download the latest version of Slideshow Crypto Ticker"
echo "from Github.com, and install it?"
echo " "
echo "(auto-install will overwrite / upgrade any previous install located at: /home/$APP_USER/dfd-crypto-ticker)"
echo " "

echo "Select 1, 2, or 3 to choose whether to auto-install / remove Slideshow Crypto Ticker, or skip."
echo " "

OPTIONS="install_ticker_app remove_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_ticker_app" ]; then
        
        	
				echo " "
				
				echo "Proceeding with required component installation, please wait..."
				
				echo " "
				
				# bsdtar installs may fail (essentially the same package as libarchive-tools),
				# SO WE RUN BOTH SEPERATELY IN CASE AN ERROR THROWS, SO OTHER PACKAGES INSTALL OK AFTERWARDS
				
				echo "(you can safely ignore any upcoming 'bsdtar' install errors, if 'libarchive-tools'"
				echo "installs OK...and visa versa, as they are essentially the same package)"
				echo " "
				
				# Ubuntu 16.x, and other debian-based systems
				apt-get install bsdtar -y
				
				sleep 3
				
				# Ubuntu 18.x and higher
				apt-get install libarchive-tools -y
				
				sleep 3
				
				# Safely install other packages seperately, so they aren't cancelled by 'package missing' errors
				apt-get install xdotool unclutter sed curl jq openssl wget -y
				
				echo " "
				
				echo "Required component installation completed."
				
				sleep 3
				
				echo " "
				
				
					if [ -f /home/$APP_USER/dfd-crypto-ticker/config.js ]; then
					
					\cp /home/$APP_USER/dfd-crypto-ticker/config.js /home/$APP_USER/dfd-crypto-ticker/config.js.BACKUP.$DATE
						
					chown $APP_USER:$APP_USER /home/$APP_USER/dfd-crypto-ticker/config.js.BACKUP.$DATE
						
					CONFIG_BACKUP=1
					
					fi
				
				
				echo "Downloading and installing the latest version of Slideshow Crypto Ticker, from Github.com, please wait..."
				
				echo " "
				
				mkdir DFD-Crypto-Ticker
				
				cd DFD-Crypto-Ticker
				
				ZIP_DL=$(curl -s 'https://api.github.com/repos/taoteh1221/Slideshow_Crypto_Ticker/releases/latest' | jq -r '.zipball_url')
				
				wget -O DFD-Crypto-Ticker.zip $ZIP_DL
				
				bsdtar --strip-components=1 -xvf DFD-Crypto-Ticker.zip
				
				rm DFD-Crypto-Ticker.zip
				
				# Remove depreciated directory structure from any previous installs
				rm -rf /home/$APP_USER/dfd-crypto-ticker/apps > /dev/null 2>&1
				rm -rf /home/$APP_USER/dfd-crypto-ticker/scripts > /dev/null 2>&1
				rm -rf /home/$APP_USER/dfd-crypto-ticker/cache/json > /dev/null 2>&1
				rm -rf /home/$APP_USER/dfd-crypto-ticker/cache/js > /dev/null 2>&1

				sleep 1
				
  				# Copy over the upgrade install files to the install directory, after cleaning up dev files
				# No trailing forward slash here
				
  				mkdir -p /home/$APP_USER/dfd-crypto-ticker
				
				rm -rf .git > /dev/null 2>&1
				rm -rf .github > /dev/null 2>&1
				rm .gitattributes > /dev/null 2>&1
				rm .gitignore > /dev/null 2>&1
				rm CODEOWNERS > /dev/null 2>&1
				rm /home/$APP_USER/dfd-crypto-ticker/bash/cron/cron.bash > /dev/null 2>&1
				rm /home/$APP_USER/dfd-crypto-ticker/bash/cron/kucoin-auth.bash > /dev/null 2>&1
				
				\cp -r ./ /home/$APP_USER/dfd-crypto-ticker

				sleep 3
				
				cd ../
				
				rm -rf DFD-Crypto-Ticker
				
				chmod -R 755 /home/$APP_USER/dfd-crypto-ticker/bash
				
				# No trailing forward slash here
				chown -R $APP_USER:$APP_USER /home/$APP_USER/dfd-crypto-ticker
				
				# If an older depreciated version, just re-create the symlink after deleting to be safe
				
				rm /home/$APP_USER/reload
				
				sleep 1
			
				ln -s /home/$APP_USER/dfd-crypto-ticker/bash/chromium-refresh.bash /home/$APP_USER/reload
				
				chown $APP_USER:$APP_USER /home/$APP_USER/reload
				
				echo " "
				
				echo "Slideshow Crypto Ticker has been installed."
				
	        	INSTALL_SETUP=1
   	     	
   	     	
        break
       elif [ "$opt" = "remove_ticker_app" ]; then
       
        echo " "
        echo "Removing Slideshow Crypto Ticker and some required components, please wait..."
		  echo " "
				
        # ONLY removing unclutter, AS WE DON'T WANT TO F!CK UP THE WHOLE SYSTEM, REMOVING ANY OTHER ALREADY-USED / DEPENDANT PACKAGES TOO!!
		  apt-get remove unclutter -y
				
		  echo " "
		  echo "Removal of 'unclutter' app package completed, please wait..."
		  echo " "
		  echo "(IF YOU USED unclutter FOR ANOTHER APP, RE-INSTALL WITH: sudo apt-get install unclutter)"
		  echo " "
				
				
		  sleep 3
        
        rm /etc/cron.d/ticker
        
        rm /lib/systemd/system/ticker.service
        
        rm /home/$APP_USER/reload
        
        rm -rf /home/$APP_USER/dfd-crypto-ticker

		  sleep 3
        
		  echo " "
		  echo "Slideshow Crypto Ticker has been removed from the system, PLEASE REBOOT to complete the removal process."
        
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping auto-install of Slideshow Crypto Ticker."
        break
       fi
done

echo " "



######################################


echo "Do you want to automatically configure Slideshow Crypto Ticker for your system (autostart at login / keep screen turned on)?"
echo " "

echo "Select 1 or 2 to choose whether to auto-configure Slideshow Crypto Ticker system settings, or skip it."
echo " "

OPTIONS="auto_config_ticker_system skip"

select opt in $OPTIONS; do
        if [ "$opt" = "auto_config_ticker_system" ]; then
        

				echo " "
				
				echo "Configuring Slideshow Crypto Ticker on your system, please wait..."

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
ExecStart=$BASH_PATH /home/$APP_USER/dfd-crypto-ticker/bash/ticker-init.bash
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
					
					
				# Setup cron (to check logs after install: tail -f /var/log/syslog | grep cron -i)

				CRONJOB="* * * * * $APP_USER $BASH_PATH /home/$APP_USER/dfd-crypto-ticker/bash/cron.bash > /dev/null 2>&1"

				# Play it safe and be sure their is a newline after this job entry
				echo -e "$CRONJOB\n" > /etc/cron.d/ticker
				
		  		# cron.d entries must be a permission of 644
		  		chmod 644 /etc/cron.d/ticker
		  		
				# cron.d entries MUST BE OWNED BY ROOT
				chown root:root /etc/cron.d/ticker
				
        		CRON_SETUP=1
				
				echo " "
				echo "Slideshow Crypto Ticker system configuration complete."

				echo " "
				
	        	CONFIG_SETUP=1
   	     	

        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping auto-configuration of Slideshow Crypto Ticker system settings."
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
			
			apt-get install git -y
			
			echo " "
			
			echo "Required component installation completed."
			
			sleep 3
			
			echo " "
			echo "Setting up for 'goodtft LCD-show' LCD drivers, please wait..."
			echo " "
			
			ln -s /home/$APP_USER/dfd-crypto-ticker/bash/switch-display.bash /home/$APP_USER/display
				
			chown $APP_USER:$APP_USER /home/$APP_USER/display
			
			mkdir -p /home/$APP_USER/goodtft/builds
			
			cd /home/$APP_USER/goodtft/builds
			
			git clone https://github.com/goodtft/LCD-show.git
			
			chmod -R 755 /home/$APP_USER/goodtft/builds
			
			# No trailing forward slash here
			chown -R $APP_USER:$APP_USER /home/$APP_USER/goodtft/builds

				
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
cd /home/$APP_USER/


echo " "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "# SAVE THE INFORMATION BELOW FOR FUTURE ACCESS TO THIS APP #"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " "



if [ "$AUTOSTART_ALERT" = "1" ]; then

echo "Ticker autostart at login has been configured at:"
echo " "
echo "/lib/systemd/system/ticker.service"
echo " "
echo "(the ticker will now start at boot/login)"
echo " "

elif [ "$AUTOSTART_ALERT" = "2" ]; then

echo "'systemd' settings could NOT be detected on your system,"
echo "ticker autostart at system boot COULD NOT BE ENABLED."
echo " "	

fi



if [ "$AUTOSTART_ALERT" = "1" ] || [ "$AUTOSTART_ALERT" = "2" ]; then

echo "If autostart does not work, you can run this command MANUALLY,"
echo "#AFTER BOOTING INTO THE DESKTOP INTERFACE#, to start Slideshow Crypto Ticker:"
echo " "
echo "bash ~/dfd-crypto-ticker/bash/ticker-init.bash &>/dev/null &"
echo " "
					

fi



if [ "$CONFIG_BACKUP" = "1" ]; then

echo "The previously-installed Slideshow Crypto Ticker configuration"
echo "file /home/$APP_USER/dfd-crypto-ticker/config.js has been backed up to:"
echo " "
echo "/home/$APP_USER/dfd-crypto-ticker/config.js.BACKUP.$DATE"
echo " "
echo "You will need to manually move any custom settings in this backup file to the new config.js file with a text editor."
echo " "

fi



if [ "$CRON_SETUP" = "1" ]; then

echo "A cron job has been setup for user '$APP_USER', as a command in /etc/cron.d/ticker:"
echo " "
echo "$CRONJOB"
echo " "

fi



echo "Edit the following file in a text editor to activate different exchanges / crypto assets / base pairings,"
echo "and to configure settings for slideshow speed / font sizes and colors / background color / vertical position /"
echo "screen orientation / google font used / monospace emulation / activated pairings / etc / etc:"
echo " "
echo "/home/$APP_USER/dfd-crypto-ticker/config.js"
echo " "

echo "Example editing config.js in nano by command-line:"
echo " "
echo "nano ~/dfd-crypto-ticker/config.js"
echo " "

echo "After updating config.js, reload the ticker with this command:"
echo " "
echo "~/reload"
echo " "

echo "Ticker installation / setup should be complete (if you chose those options), unless you saw any error"
echo "messages on your screen during setup."
echo " "


if [ "$GOODTFT_SETUP" = "1" ]; then

echo "TO COMPLETE THE 'goodtft LCD-show' LCD DRIVERS SETUP, run this command below"
echo "to configure / activate your 'goodtft LCD-show' LCD screen:"
echo " "
echo "~/display"
echo " "

echo "(your device will restart automatically afterwards)"
echo " "

else

echo "You must restart your device to activate the ticker, by running this command:"
echo " "
echo "sudo reboot"
echo " "

fi


echo "THIS TICKER INSTALL #REQUIRES# RUNNING THE RASPBERRY PI GRAPHICAL DESKTOP INTERFACE (LXDE) AT STARTUP, AS THE USER: '${APP_USER}'"
echo " "

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo " "


######################################


echo " "
echo "BE SURE TO SAVE ALL THE ACCESS DETAILS PRINTED OUT ABOVE, BEFORE YOU SIGN OFF FROM THIS TERMINAL SESSION."
echo " "
echo "Also check out my 100% FREE open source private cryptocurrency investment portfolio tracker,"
echo "with email / text / Alexa / Ghome / Telegram alerts, charts, mining calculators,"
echo "leverage / gain / loss / balance stats, news feeds and more:"
echo " "
echo "https://taoteh1221.github.io"
echo " "
echo "https://github.com/taoteh1221/Open_Crypto_Portfolio_Tracker"
echo " "

echo "ANY DONATIONS (LARGE OR SMALL) HELP SUPPORT DEVELOPMENT OF MY APPS..."
echo " "
echo "Bitcoin: 3Nw6cvSgnLEFmQ1V4e8RSBG23G7pDjF3hW"
echo " "
echo "Ethereum: 0x644343e8D0A4cF33eee3E54fE5d5B8BFD0285EF8"
echo " "



######################################



echo "Would you like to ADDITIONALLY install Open Crypto Portfolio Tracker (server edition), private portfolio tracker on this machine?"
echo " "

echo "Select 1 or 2 to choose whether to install the private portfolio tracker, or skip."
echo " "

OPTIONS="install_portfolio_tracker skip"

select opt in $OPTIONS; do
        if [ "$opt" = "install_portfolio_tracker" ]; then
         
			
			echo " "
			
			echo "Proceeding with portfolio tracker installation, please wait..."
			
			echo " "
			
			wget --no-cache -O FOLIO-INSTALL.bash https://raw.githubusercontent.com/taoteh1221/Open_Crypto_Portfolio_Tracker/main/FOLIO-INSTALL.bash
			
			chmod +x FOLIO-INSTALL.bash
			
			chown $APP_USER:$APP_USER FOLIO-INSTALL.bash
			
			./FOLIO-INSTALL.bash
			
			
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "Skipping portfolio tracker install..."
        break
       fi
done

echo " "


######################################

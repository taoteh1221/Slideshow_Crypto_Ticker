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


echo "TECHNICAL NOTE:"
echo "This script was designed to install / setup on the Raspian operating system,"
echo "and was developed / created on Raspbian Linux v10, for Raspberry Pi computers."
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

echo " "
				
echo "Proceeding with required component installation..."
				
echo " "
				
/usr/bin/sudo /usr/bin/apt-get install xdotool unclutter -y

echo " "
				
echo "Required component installation completed."
				
sleep 3
				
echo " "


######################################


echo "Do you want this script to automatically download the latest version of"
echo "DFD Crypto Ticker from Github.com, and install it?"
echo "(auto-install will overwrite / upgrade any previous install located at: /home/pi/dfd-crypto-ticker)"
echo " "

echo "Select 1 or 2 to choose whether to auto-install DFD Crypto Ticker, or skip it."
echo " "

OPTIONS="auto_install_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "auto_install_ticker_app" ]; then
        
        	
				echo " "
				
				echo "Making sure your system is updated before installing required components..."
				
				echo " "
				
				/usr/bin/sudo /usr/bin/apt-get update
				
				/usr/bin/sudo /usr/bin/apt-get upgrade -y
				
				echo " "
				
				echo "Proceeding with required component installation..."
				
				echo " "
				
				/usr/bin/sudo /usr/bin/apt-get install curl jq bsdtar openssl -y
				
				echo " "
				
				echo "Required component installation completed."
				
				sleep 3
				
				echo " "
				
				echo "Downloading and installing the latest version of DFD Crypto Ticker, from Github.com..."
				
				echo " "
				
				mkdir DFD-Crypto-Ticker
				
				cd DFD-Crypto-Ticker
				
				ZIP_DL=$(/usr/bin/curl -s 'https://api.github.com/repos/taoteh1221/DFD_Crypto_Ticker/releases/latest' | /usr/bin/jq -r '.zipball_url')
				
				/usr/bin/wget -O DFD-Crypto-Ticker.zip $ZIP_DL
				
				/usr/bin/bsdtar --strip-components=1 -xvf DFD-Crypto-Ticker.zip
				
				rm DFD-Crypto-Ticker.zip
				
  				mkdir -p /home/pi/dfd-crypto-ticker
  				
				cd dfd-crypto-ticker
				
				# No trailing forward slash here
				\cp -r ./ /home/pi/dfd-crypto-ticker
				
				cd ../
				
				mv -v LICENSE /home/pi/dfd-crypto-ticker/LICENSE
				
				mv -v README.txt /home/pi/dfd-crypto-ticker/README.txt
				
				cd ../
				
				rm -rf DFD-Crypto-Ticker
				
				# No trailing forward slash here
				chown -R pi:pi /home/pi/dfd-crypto-ticker
				
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
echo "(##NOT RECOMMENDED## IF YOU HAVE ALREADY CONFIGURED THIS APP ON THIS SYSTEM ONCE ALREADY)"
echo " "

echo "Select 1 or 2 to choose whether to auto-configure DFD Crypto Ticker, or skip it."
echo " "

OPTIONS="auto_config_ticker_app skip"

select opt in $OPTIONS; do
        if [ "$opt" = "auto_config_ticker_app" ]; then
        

				echo " "
				
				echo "Configuring DFD Crypto Ticker..."

				echo " "

				chmod -R 755 /home/pi/dfd-crypto-ticker/scripts
				
				mkdir -p /home/pi/.config/lxsession/LXDE-pi/

				touch /home/pi/.config/lxsession/LXDE-pi/autostart

				echo '@xset s off' >>  /home/pi/.config/lxsession/LXDE-pi/autostart

				echo '@xset -dpms' >>  /home/pi/.config/lxsession/LXDE-pi/autostart

				echo '@xset s noblank' >>  /home/pi/.config/lxsession/LXDE-pi/autostart

				echo '# start chromium' >>  /home/pi/.config/lxsession/LXDE-pi/autostart

				echo '@/bin/bash /home/pi/dfd-crypto-ticker/scripts/start-chromium.bash &' >>  /home/pi/.config/lxsession/LXDE-pi/autostart

				echo '# hide cursor' >>  /home/pi/.config/lxsession/LXDE-pi/autostart

				echo '@unclutter -idle 0' >>  /home/pi/.config/lxsession/LXDE-pi/autostart

				chown pi:pi /home/pi/.config/lxsession/LXDE-pi/autostart
				
				touch /etc/cron.d/ticker

				CRONJOB="* * * * * pi /bin/bash /home/pi/dfd-crypto-ticker/scripts/keep.screensaver.off.bash > /dev/null 2>&1"

				echo "$CRONJOB" >>  /etc/cron.d/ticker

				chown pi:pi /etc/cron.d/ticker
				
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


echo "Select 1 or 2 to choose whether to install 'goodtft LCD-show' LCD, or skip."
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
			
			ln -s /home/pi/dfd-crypto-ticker/scripts/switch-display.bash /home/pi/display
			
			mkdir -p /home/pi/dfd-crypto-ticker/builds
			
			cd /home/pi/dfd-crypto-ticker/builds
			
			/usr/bin/git clone https://github.com/goodtft/LCD-show.git
			
			cd /home/pi/dfd-crypto-ticker/
			
			chmod -R 755 /home/pi/dfd-crypto-ticker/builds
			
			# No trailing forward slash here
			chown -R pi:pi /home/pi/dfd-crypto-ticker/builds
				
			chown pi:pi /home/pi/display

				
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

if [ "$GOODTFT_SETUP" = "1" ]; then

echo "Run the below command (in /home/pi/) to configure your goodtft device:"
echo "sudo ./display"
echo " "

fi

echo "Edit the following file in a text editor to switch between the"
echo "different Coinbase Pro crypto assets and their paired markets: "
echo "/home/pi/dfd-crypto-ticker/apps/ticker/config.js"

echo " "

echo "You must restart your device to activate the Ticker (it should run automatically at startup when you reboot)."
echo " "

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"



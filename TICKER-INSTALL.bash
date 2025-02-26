#!/bin/bash

# Copyright 2019-2025 GPLv3, Slideshow Crypto Ticker by Mike Kilday: Mike@DragonFrugal.com (leave this copyright / attribution intact in ALL forks / copies!)


ISSUES_URL="https://github.com/taoteh1221/Slideshow_Crypto_Ticker/issues"

echo " "
echo "PLEASE REPORT ANY ISSUES HERE: $ISSUES_URL"
echo " "
echo "Initializing, please wait..."
echo " "


######################################


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


# In case we are recursing back into this script (for filtering params etc),
# flag export of a few more basic sys vars if present

# Authentication of X sessions
export XAUTHORITY=~/.Xauthority 
# Working directory
export PWD=$PWD
				

######################################


# Get the *INTERNAL* NETWORK ip address
IP=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')


######################################


# Are we running on an ARM-based CPU?
if [ -f "/etc/debian_version" ]; then
IS_ARM=$(dpkg --print-architecture | grep -i "arm")
elif [ -f "/etc/redhat-release" ]; then
IS_ARM=$(uname -r | grep -i "aarch64")
fi


######################################


# Get date / time
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')

# Current timestamp
CURRENT_TIMESTAMP=$(date +%s)

# Are we running on Ubuntu OS?
IS_UBUNTU=$(cat /etc/os-release | grep -i "ubuntu")


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

# Parent directory of the script location
PARENT_DIR="$(dirname "$SCRIPT_LOCATION")"


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


# For setting user agent header in curl, since some API servers !REQUIRE! a set user agent OR THEY BLOCK YOU
CUSTOM_CURL_USER_AGENT_HEADER="User-Agent: Curl (${OS}/$VER; compatible;)"


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


if [ "$EUID" -ne 0 ] || [ "$TERMINAL_USERNAME" == "root" ]; then 

echo " "
echo "${red}Please run as a NORMAL USER WITH 'sudo' PERMISSIONS (NOT LOGGED IN AS 'root').${reset}"

echo "${yellow} "
read -n1 -s -r -p $"PRESS ANY KEY to exit..." key
echo "${reset} "

    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
    echo " "
    echo "${green}Exiting...${reset}"
    echo " "
    exit
    fi

fi


######################################


# Find out what display manager is being used on the PHYSICAL display
DISPLAY_SESSION=$(loginctl show-user "$TERMINAL_USERNAME" -p Display --value)
DISPLAY_SESSION=$(echo "${DISPLAY_SESSION}" | xargs) # trim whitespace

# Display type
DISPLAY_TYPE=$(loginctl show-session "$DISPLAY_SESSION" -p Type)

# Are we using x11 display manager?
RUNNING_X11=$(echo "$DISPLAY_TYPE" | grep -i x11)

# Are we using wayland display manager?
RUNNING_WAYLAND=$(echo "$DISPLAY_TYPE" | grep -i wayland)


# Are we running a wayland compositor?
if [ "$RUNNING_WAYLAND" != "" ]; then
	   
# Are we using labwc compositor?
RUNNING_LABWC=$(ps aux | grep -i labwc | grep -v grep) # EXCLUDE THE WORD GREP!

elif [ "$RUNNING_X11" != "" ]; then

     # Are we using lightdm, as the display manager?
     if [ -f "/etc/debian_version" ]; then
     LIGHTDM_DISPLAY=$(cat /etc/X11/default-display-manager | grep -i "lightdm")
     elif [ -f "/etc/redhat-release" ]; then
     LIGHTDM_DISPLAY=$(ls -al /etc/systemd/system/display-manager.service | grep -i "lightdm")
     fi

fi


######################################


if [ -f "/etc/debian_version" ]; then

echo "${green}Your system has been detected as Debian-based, which is compatible with this automated script."

# USE 'apt-get' IN SCRIPTING!
# https://askubuntu.com/questions/990823/apt-gives-unstable-cli-interface-warning
PACKAGE_INSTALL="sudo apt-get install"
PACKAGE_REMOVE="sudo apt-get --purge remove"

echo " "
echo "Continuing...${reset}"
echo " "

elif [ -f "/etc/redhat-release" ]; then

echo "${green}Your system has been detected as Redhat-based, which is compatible with this automated script."

PACKAGE_INSTALL="sudo yum install"
PACKAGE_REMOVE="sudo yum remove"

echo " "
echo "Continuing...${reset}"
echo " "

else

echo "${red}Your system has been detected as NOT BEING Debian-based OR Redhat-based. Your system is NOT compatible with this automated script."

echo "${yellow} "
read -n1 -s -r -p $"PRESS ANY KEY to exit..." key
echo "${reset} "

    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
    echo " "
    echo "${green}Exiting...${reset}"
    echo " "
    exit
    fi

fi

     
echo "${yellow} "
read -n1 -s -r -p $"PRESS ANY KEY to continue..." key
echo "${reset} "
     
    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
    echo " "
    echo "${green}Continuing...${reset}"
    echo " "
    fi
     
echo " "


######################################


# Ubuntu uses snaps for very basic libraries these days, so we need to configure for possible snap installs
if [ "$IS_UBUNTU" != "" ]; then

sudo apt install snapd -y

sleep 3
          
UBUNTU_SNAP_INSTALL="sudo snap install"

fi


######################################


# Path to app (CROSS-DISTRO-COMPATIBLE)
get_app_path() {

app_path_result=$(whereis -b $1)
app_path_result="${app_path_result#*$1: }"
app_path_result=${app_path_result%%[[:space:]]*}
app_path_result="${app_path_result#*$1:}"
     
     
     # If we have found the library already installed on this system
     if [ ! -z "$app_path_result" ]; then
     
     PATH_CHECK_REENTRY="" # Reset reentry flag
     
     echo "$app_path_result"
     
     # If we are re-entering from the else statement below, quit trying, with warning sent to terminal (NOT function output)
     elif [ ! -z "$PATH_CHECK_REENTRY" ]; then
     
     PATH_CHECK_REENTRY="" # Reset reentry flag
     
     echo "${red} " > /dev/tty
     echo "System path for '$1' NOT FOUND, even AFTER package installation attempts, giving up." > /dev/tty
     echo " " > /dev/tty

     echo "*PLEASE* REPORT THIS ISSUE HERE, *IF THIS SCRIPT OR THE INSTALLED APP FAILS TO RUN PROPERLY FROM THIS POINT ONWARD*:" > /dev/tty
     echo " " > /dev/tty
     echo "$ISSUES_URL" > /dev/tty
     echo "${reset} " > /dev/tty
     
     echo "${yellow} " > /dev/tty
     read -n1 -s -r -p $"PRESS ANY KEY to continue..." key
     echo "${reset} " > /dev/tty
     
         if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
         echo " " > /dev/tty
         echo "${green}Continuing...${reset}" > /dev/tty
         echo " " > /dev/tty
         fi
     
     echo " " > /dev/tty
     
     # If library not found, attempt package installation
     else
     
     
          # Handle package name exceptions...
          
          if [ -f "/etc/debian_version" ]; then
          
          
               # bsdtar on Ubuntu 18.x and higher
               if [ "$1" == "bsdtar" ]; then
               SYS_PACK="libarchive-tools"
               
               # xdg-user-dir (package name differs)
               elif [ "$1" == "xdg-user-dir" ]; then
               SYS_PACK="xdg-user-dirs"
     
               # rsyslogd (package name differs)
               elif [ "$1" == "rsyslogd" ]; then
               SYS_PACK="rsyslog"
     
               # snap (package name differs)
               elif [ "$1" == "snap" ]; then
               SYS_PACK="snapd"
     
               # xorg (package name differs)
               elif [ "$1" == "xorg" ]; then
               SYS_PACK="xserver-xorg"
     
               # chromium-browser (package name differs)
               elif [ "$1" == "chromium-browser" ]; then
               SYS_PACK="chromium"
     
               # epiphany-browser (package name differs)
               elif [ "$1" == "epiphany-browser" ]; then
               SYS_PACK="epiphany"
     
               else
               SYS_PACK="$1"
               fi
          
          
          elif [ -f "/etc/redhat-release" ]; then
          
          
               if [ "$1" == "xdg-user-dir" ]; then
               SYS_PACK="xdg-user-dirs"
     
               # rsyslogd (package name differs)
               elif [ "$1" == "rsyslogd" ]; then
               SYS_PACK="rsyslog"
     
               # xorg (package name differs)
               elif [ "$1" == "xorg" ]; then
               SYS_PACK="gnome-session-xsession"
     
               # chromium-browser (package name differs)
               elif [ "$1" == "chromium-browser" ]; then
               SYS_PACK="chromium"
     
               # epiphany-browser (package name differs)
               elif [ "$1" == "epiphany-browser" ]; then
               SYS_PACK="epiphany"
     
               # avahi-daemon (package name differs)
               elif [ "$1" == "avahi-daemon" ]; then
               SYS_PACK="avahi"
     
               else
               SYS_PACK="$1"
               fi
               
               
          else
          SYS_PACK="$1"
          fi
          
          
          # Terminal alert for good UX...
          if [ "$1" != "$SYS_PACK" ]; then
          echo " " > /dev/tty
          echo "${yellow}'$1' is found WITHIN '$SYS_PACK', changing package request accordingly...${reset}" > /dev/tty
          echo " " > /dev/tty
          fi


     echo " " > /dev/tty
     echo "${cyan}Installing required component '$SYS_PACK', please wait...${reset}" > /dev/tty
     echo " " > /dev/tty
     
     sleep 3
               
     $PACKAGE_INSTALL $SYS_PACK -y > /dev/tty
     
     
          # If UBUNTU (*NOT* any other OS) snap was detected on the system, try a snap install too
          # (as they moved some libs over to snap / snap-only? now)
          # (only if we are NOT installing snap itself)
          if [ "$IS_UBUNTU" != "" ] && [ $SYS_PACK != "snapd" ]; then
          
          echo " " > /dev/tty
          echo "${yellow}CHECKING FOR UBUNTU SNAP PACKAGE '$SYS_PACK', please wait...${reset}" > /dev/tty
          echo " " > /dev/tty
          
          sleep 3
          
          $UBUNTU_SNAP_INSTALL $SYS_PACK > /dev/tty
          
          fi
     
     
     sleep 2
     
     PATH_CHECK_REENTRY=1 # Set reentry flag, right before reentry
     
     echo $(get_app_path "$1")
           
     fi


}


######################################


# Make sure automatic suspend / sleep is disabled
if [ ! -f "${HOME}/.sleep_disabled.dat" ]; then

echo "${red}We need to make sure your system will NOT AUTO SUSPEND / SLEEP, or your app server could stop running.${reset}"

echo "${yellow} "
read -n1 -s -r -p $"PRESS F to fix this (disables auto suspend / sleep), OR any other key to skip fixing..." key
echo "${reset} "

    if [ "$key" = 'f' ] || [ "$key" = 'F' ]; then

    echo " "
    echo "${cyan}Disabling auto suspend / sleep...${reset}"
    echo " "
    
    echo -e "ran" > ${HOME}/.sleep_disabled.dat
    
         if [ -f "/etc/debian_version" ]; then
         sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target > /dev/null 2>&1
         elif [ -f "/etc/redhat-release" ]; then
         sudo -u gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0 > /dev/null 2>&1
         fi
	   
    else

    echo " "
    echo "${green}Skipping...${reset}"
    echo " "
    
    fi

fi


######################################


# ON ARM REDHAT-BASED SYSTEMS ONLY:
# Do we have kernel updates disabled?
if [ -f "/etc/redhat-release" ] && [ ! -f "${HOME}/.redhat_kernel_alert.dat" ]; then

# Are we auto-selecting the NEWEST kernel, to boot by default in grub?
KERNEL_BOOTED_UPDATES=$(sudo sed -n '/UPDATEDEFAULT=yes/p' /etc/sysconfig/kernel)


     if [ "$IS_ARM" != "" ] && [ "$KERNEL_BOOTED_UPDATES" != "" ]; then
     
     echo "${red}Your ARM-based device is CURRENTLY setup to UPDATE the grub bootloader to boot from THE LATEST KERNEL. THIS MAY CAUSE SOME ARM-BASED DEVICES TO NOT BOOT (without MANUALLY selecting a different kernel at boot time).${reset}"
     
     echo "${yellow} "
     read -n1 -s -r -p $"PRESS F to fix this (disable grub auto-selecting NEW kernels to boot), OR any other key to skip fixing..." key
     echo "${reset} "
     
         if [ "$key" = 'f' ] || [ "$key" = 'F' ]; then
     
         echo " "
         echo "${cyan}Disabling grub auto-selecting NEW kernels to boot...${reset}"
         echo " "
         
         sudo sed -i 's/UPDATEDEFAULT=.*/UPDATEDEFAULT=no/g' /etc/sysconfig/kernel > /dev/null 2>&1
     
         echo "${red} "
         read -n1 -s -r -p $"Press ANY KEY to REBOOT (to assure this update takes effect)..." key
         echo "${reset} "
                  
                  
                 if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
                      
                 echo " "
                 echo "${green}Rebooting...${reset}"
                 echo " "
                      
                 sudo shutdown -r now
                      
                 exit
                      
                 fi
                  
                  
         echo " "
          
         else
     
         echo " "
         echo "${green}Skipping...${reset}"
         echo " "
         
         fi
     
     
     fi


echo -e "ran" > ${HOME}/.redhat_kernel_alert.dat

fi
              

######################################


# Armbian freeze kernel updates
if [ -f "/usr/bin/armbian-config" ] && [ ! -f "${HOME}/.armbian_kernel_alert.dat" ]; then
echo "${red}YOU MAY NEED TO *DISABLE* KERNEL UPDATES ON YOUR ARMBIAN DEVICE (IF YOU HAVE NOT ALREADY), SO YOUR DEVICE ALWAYS BOOTS UP PROPERLY."
echo " "
echo "${green}Run this command, and then choose 'System > Updates > Disable Armbian firmware upgrades':"
echo " "
echo "sudo armbian-config${reset}"
echo " "
echo "${red}This will assure you always use a kernel compatible with your device."
echo " "

echo "${yellow} "
read -n1 -s -r -p $"PRESS F to run armbian-config and fix this NOW, OR any other key to skip fixing..." key
echo "${reset} "

    if [ "$key" = 'f' ] || [ "$key" = 'F' ]; then

    sudo armbian-config
    
    sleep 1

    echo " "
    echo "${cyan}Resuming auto-installer..."
    echo " "
    echo "${red}DON'T FORGET TO REBOOT BEFORE ALLOWING ANY SYSTEM UPGRADES!${reset}"
    echo " "
	   
    else

    echo " "
    echo "${green}Skipping...${reset}"
    echo " "
    
    fi


echo -e "ran" > ${HOME}/.armbian_kernel_alert.dat

fi


######################################


# ON DEBIAN-BASED SYSTEMS ONLY:
# Do we have less than 900MB PHYSICAL RAM (IN KILOBYTES),
# AND no swap / less swap virtual memory than 900MB (IN BYTES)?
if [ -f "/etc/debian_version" ] && [ "$(awk '/MemTotal/ {print $2}' /proc/meminfo)" -lt 900000 ] && (
[ "$(free | awk '/^Swap:/ { print $2 }')" = "0" ] || [ "$(free --bytes | awk '/^Swap:/ { print $2 }')" -lt 900000000 ]
); then

echo "${red}YOU HAVE LESS THAN 900MB *PHYSICAL* MEMORY, AND ALSO HAVE LESS THAN 900MB SWAP *VIRTUAL* MEMORY. This MAY cause your system to FREEZE, *IF* you have a desktop display attached!${reset}"

echo "${yellow} "
read -n1 -s -r -p $"PRESS F to fix this (sets swap virtual memory to 1GB), OR any other key to skip fixing..." key
echo "${reset} "

    if [ "$key" = 'f' ] || [ "$key" = 'F' ]; then

    echo " "
    echo "${cyan}Changing Swap Virtual Memory size to 1GB, please wait (THIS MAY TAKE AWHILE ON SMALLER SYSTEMS)...${reset}"
    echo " "
    
    # Required components check...
    
    # dphys-swapfile
    DPHYS_PATH=$(get_app_path "dphys-swapfile")

    # sed
    SED_PATH=$(get_app_path "sed")
    
    sudo $DPHYS_PATH swapoff
    
    sleep 5
         
        if [ -f /etc/dphys-swapfile ]; then
			    
	   DETECT_SWAP_CONF=$(sudo sed -n '/CONF_SWAPSIZE=/p' /etc/dphys-swapfile)
			
		   if [ "$DETECT_SWAP_CONF" != "" ]; then 
             sudo sed -i "s/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=1024/g" /etc/dphys-swapfile
             elif [ "$DETECT_SWAP_CONF" == "" ]; then 
             sudo bash -c "echo 'CONF_SWAPSIZE=1024' >> /etc/dphys-swapfile"
	        fi
	        
	   sudo $DPHYS_PATH setup
	   
	   sleep 5
	   
	   sudo $DPHYS_PATH swapon
	   
	   sleep 5
	   
        echo " "
        echo "${green}Swap Memory size has been updated to 1GB.${reset}"
        echo " "
        
        else
	   
        echo " "
        echo "${red}Swap Memory config file could NOT be located, skipping update of Swap Memory size!${reset}"
        echo " "
	        
	   fi
	   
    else

    echo " "
    echo "${green}Skipping...${reset}"
    echo " "
    
    fi

fi


######################################


# clean_system_update function START
clean_system_update () {


     if [ -z "$ALLOW_FULL_UPGRADE" ]; then
     
     echo " "
     echo "${yellow}Does the Operating System on this device update using the \"Rolling Release\" model (Kali, Manjaro, Ubuntu Rolling Rhino, Debian Unstable, Fedora Rawhide, etc), or the \"Long-Term Release\" model (Debian, Ubuntu, Raspberry Pi OS, Armbian Stable, Diet Pi, Fedora, etc)?"
     echo "${reset} "
     
     
          if [ ! -f /usr/bin/raspi-config ] && [ "$IS_ARM" != "" ]; then
          
          echo "${red}(You can SEVERELY MESS UP an ${yellow}ARM-based / NOT-RASPI-OS \"Rolling Release\" Operating System${red}, IF YOU DO NOT CHOOSE CORRECTLY HERE! In that case, you can SAFELY choose \"I don't know\".)${reset}"
          echo " "
     
          echo "${red}(Your ${yellow}ARM-based / NOT-RASPI-OS Operating System${red} MAY NOT BOOT IF YOU RUN SYSTEM UPGRADES [if you have NOT frozen kernel firmware updating / rebooted FIRST]. To avoid this potential issue (IF you have NOT frozen kernel firmware updating), you can SAFELY choose \"NOT Raspberry Pi OS Software\", OR \"I don't know\")${reset}"
          echo " "
     
          echo "Enter the NUMBER next to your chosen option.${reset}"
     
          echo " "
          
          OPTIONS="rolling long_term i_dont_know not_raspberrypi_os_software"
          
          else
     
          echo "Enter the NUMBER next to your chosen option.${reset}"
     
          echo " "
          
          OPTIONS="rolling long_term i_dont_know"
          
          fi
     
          
          select opt in $OPTIONS; do
                  if [ "$opt" = "long_term" ]; then
                  ALLOW_FULL_UPGRADE="yes"
                  echo " "
                  echo "${green}Allowing system-wide updates before installs.${reset}"
                  break
                 else
                  ALLOW_FULL_UPGRADE="no"
                  echo " "
                  echo "${green}Disabling system-wide updates before installs.${reset}"
                  break
                 fi
          done
            
     echo " "
     
     fi


     if [ -z "$PACKAGE_CACHE_REFRESHED" ]; then


          if [ -f "/etc/debian_version" ]; then

          echo "${cyan}Making sure your APT sources list is updated before installations, please wait...${reset}"
          
          echo " "
          
          # In case package list was ever corrupted (since we are about to rebuild it anyway...avoids possible errors)
          sudo rm -rf /var/lib/apt/lists/* -vf > /dev/null 2>&1
          
          sleep 2
          
          sudo apt-get update
          
          echo " "
     
          echo "${cyan}APT sources list update complete.${reset}"
          
          echo " "
     
          fi
          
     
          if [ "$ALLOW_FULL_UPGRADE" == "yes" ]; then

          echo "${cyan}Making sure your system is updated before installations, please wait...${reset}"
          
          echo " "
          
          
               if [ -f "/etc/debian_version" ]; then
               #DO NOT RUN dist-upgrade, bad things can happen, lol
               sudo apt-get upgrade -y
               elif [ -f "/etc/redhat-release" ]; then
               sudo yum upgrade -y
               fi
          
          
          sleep 2
          
          echo " "
          				
          echo "${cyan}System updated.${reset}"
          				
          echo " "
          
          fi
     
     
     PACKAGE_CACHE_REFRESHED=1
     
     fi

}
# clean_system_update function END

# Clears / updates cache, then upgrades (if NOT a rolling release)
clean_system_update


######################################


# Get PRIMARY dependency lib's paths (for bash scripting commands...auto-install is attempted, if not found on system)
# (our usual standard library prerequisites [ordered alphabetically], for 99% of advanced bash scripting needs)

# avahi-daemon
AVAHID_PATH=$(get_app_path "avahi-daemon")

# bc
BC_PATH=$(get_app_path "bc")

# bsdtar
BSDTAR_PATH=$(get_app_path "bsdtar")

# curl
CURL_PATH=$(get_app_path "curl")

# expect
EXPECT_PATH=$(get_app_path "expect")
    
# git
GIT_PATH=$(get_app_path "git")

# jq
JQ_PATH=$(get_app_path "jq")

# less
LESS_PATH=$(get_app_path "less")

# sed
SED_PATH=$(get_app_path "sed")

# wget
WGET_PATH=$(get_app_path "wget")

# xorg (NEEDED TO BE USED AS THE WINDOW SYSTEM, FOR LXDE / AUTOBOOT)
XORG_PATH=$(get_app_path "xorg")

# PRIMARY dependency lib's paths END


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
echo "${red}Directory /home/$APP_USER/ DOES NOT exist, cannot install Slideshow Crypto Ticker. Please create user $APP_USER's home directory before running this installation.${reset}"
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
read -n1 -s -r -p $"Press Y to continue (or press N to exit)..." key
echo "${reset} "

    if [ "$key" = 'y' ] || [ "$key" = 'Y' ]; then
    
    echo " "
    echo "${green}Continuing...${reset}"
         
    # If all clear for takeoff, make sure a group exists with same name as user,
    # AND user is a member of it (believe it or not, I've seen this not always hold true!)
    groupadd -f $APP_USER > /dev/null 2>&1
    sleep 3
    usermod -a -G $APP_USER $APP_USER > /dev/null 2>&1

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
echo "This script was designed to install on popular Debian-based ${green}(STABLE / POLISHED)${yellow} / RedHat-based ${green}(STABLE / POLISHED)${yellow} operating systems (Debian, Ubuntu, Raspberry Pi OS [Raspbian], Armbian, DietPi, Fedora, CentOS, RedHat Enterprise, etc), for small single-board computers WITH SMALL LCD SCREENS TO RUN THE TICKER 24/7 (ALL THE TIME)."
echo " "

echo "It is ONLY recommended to install this ticker app IF your device has an LCD screen installed.${reset}"
echo " "

echo "${yellow}This script MAY NOT work on ALL Debian-based / RedHat-based system setups.${reset}"
echo " "

echo "${cyan}Your system has been detected as:"
echo " "
echo "$OS v$VER (display: ${DISPLAY_TYPE})${reset}"
echo " "

echo "${red}Chromium, Epiphany, and Firefox are supported (chromium is recommended for reliability, all these browsers will be installed if available). IF A BROWSER DOES NOT WORK, PLEASE CHECK MANUALLY THAT IT IS INSTALLED PROPERLY, AND MAKE SURE IT IS NOT CRASHING ON STARTUP!${reset}"
echo " "

     
echo "${yellow} "
read -n1 -s -r -p $"PRESS ANY KEY to continue..." key
echo "${reset} "
     
    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
    echo " "
    echo "${green}Continuing...${reset}"
    echo " "
    fi
     
echo " "
  				
				
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

echo "${red}IF ANYTHING STOPS WORKING AFTER UPGRADING, CLEAR YOUR BROWSER CACHE (temporary files), AND RELOAD OR RESTART THE APP. This will load the latest Javascript / Style Sheet upgrades properly.${reset}"
echo " "

fi


echo "${red}PLEASE REPORT ANY ISSUES HERE: $ISSUES_URL${reset}"
echo " "

echo "${yellow} "
read -n1 -s -r -p $"PRESS ANY KEY to continue..." key
echo "${reset} "
     
    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
    echo " "
    echo "${green}Continuing...${reset}"
    echo " "
    fi
     
echo " "
              

######################################

		
if [ -f "/usr/bin/raspi-config" ]; then
echo "${red}YOU MAY NEED TO *DISABLE* SCREEN BLANKING ON YOUR RASPBERRY PI DEVICE, SO THE TICKER SHOWS ON YOUR SCREEN 24 HOURS A DAY."
echo " "
echo "${green}Run this command, and then choose 'Display Options -> Screen Blanking -> NO':"
echo " "
echo "sudo raspi-config${reset}"
echo " "
echo "${red}This will keep your screen turned on."
echo " "

echo "${yellow} "
read -n1 -s -r -p $"PRESS F to run raspi-config and fix this NOW, OR any other key to skip fixing..." key
echo "${reset} "

    if [ "$key" = 'f' ] || [ "$key" = 'F' ]; then

    sudo raspi-config
    
    sleep 1

    echo " "
    echo "${cyan}Resuming auto-installer...${reset}"
    echo " "
	   
    else

    echo " "
    echo "${green}Skipping...${reset}"
    echo " "
    
    fi


fi


######################################


if [ -f "/etc/redhat-release" ]; then

# Install cron / fire it up (will persist between reboots)
$PACKAGE_INSTALL -y cronie

sleep 3

sudo systemctl start crond.service

fi


######################################


# If we are NOT already running wayland/labwc
if [ "$RUNNING_LABWC" == "" ]; then

# lightdm CHECK
LIGHTDM_CHECK=$(which lightdm)
LIGHTDM_CHECK=$(echo "${LIGHTDM_CHECK}" | xargs) # trim whitespace

     
     # If lightdm OR lxde desktop session IS NOT INSTALLED,
     # then we offer the option to install LXDE, AND WE SET THE DISPLAY MANAGER TO LIGHTDM (IF NOT ALREADY SET)
     if [ "$LIGHTDM_CHECK" == "" ] || [ ! -d /etc/xdg/lxsession ]; then
     
     echo "${red}WE NEED TO MAKE SURE LXDE #AND# LIGHTDM ARE SETUP, IF YOU WANT THE TICKER TO #AUTOMATICALLY RUN ON SYSTEM STARTUP# / REBOOT."
     echo " "
     echo "CHOOSE \"LIGHTDM\" IF ASKED, FOR \"AUTO-LOGIN AT BOOT\" CAPABILITIES."
     echo "(THIS SCRIPT WILL ALSO AUTO-SETUP LIGHTDM, EVEN IF YOU DO NOT GET A PROMPT)${reset}"
     echo " "
     echo "${yellow}Select 1 or 2 to choose whether to install LXDE Desktop, or skip.${reset}"
     echo " "
         
         OPTIONS="setup_lxde skip"
         
         select opt in $OPTIONS; do
                 if [ "$opt" = "setup_lxde" ]; then
                 
                 echo " "
                 echo "${cyan}Installing LXDE desktop and required components, please wait...${reset}"
                 echo " "
     
                 
                     if [ -f "/etc/debian_version" ]; then
                     
                     $PACKAGE_INSTALL lightdm lxde -y
     
                     elif [ -f "/etc/redhat-release" ]; then
     
                     $PACKAGE_INSTALL lightdm -y
                     
                     sleep 3
     
                     # GROUP install REQUIRED for LXDE install command
                     sudo dnf group install -y lxde-desktop
                     
                     fi
     	   
     	   
                 sleep 3
     
                 # lightdm (NEEDED TO BE USED AS THE DISPLAY MANAGER, FOR LXDE / AUTOBOOT)
                 LIGHTDM_PATH=$(get_app_path "lightdm")
     
                 
                 echo " "
                 echo "${cyan}LXDE desktop has been installed.${reset}"
                 echo " "
                 
                 sleep 3
                 
                 
                 # CROSS-PLATFORM LIGHTDM SETUP COMMANDS...
                 
                 echo " "
                 echo "${cyan}Configuring LIGHTDM display manager, please wait...${reset}"
                 echo " "
                 
                 # Enable GUI on boot
                 systemctl set-default graphical
                 echo " "
                 
                 sleep 3
     		  
     		  
          		  # Assure lightdm is being used on debian
          		  if [ -f "/etc/debian_version" ]; then
          		  
          		  dpkg-reconfigure lightdm

                      echo " "

                      sleep 3

                      fi
                 
                     
                 # Assure a graphical TARGET is set, or system MAY hang on boot
                 # https://askubuntu.com/questions/74551/lightdm-not-starting-on-boot/939995#939995
                 rm /etc/systemd/system/default.target
                 
                 sleep 3
                 
                 systemctl set-default graphical.target
                 echo " "
                 
                 sleep 3
                             
                 # DISABLE gdm at boot
                 sudo systemctl disable gdm.service
                 echo " "
                 
                 sleep 3
                 
                 echo " "
                 echo "${cyan}Configuring LIGHTDM display manager is complete.${reset}"
                 echo " "
               
                 # ENABLE lightdm at boot
                 # DEBUG: sudo lightdm –-test-mode --debug
                 # DEBUG: journalctl -b -u lightdm.service
                 sudo systemctl enable lightdm.service
                 
                 sleep 3
          
                 break
                elif [ "$opt" = "skip" ]; then
                 echo " "
                 echo "${green}Skipping LXDE desktop installation...${reset}"
                 break
                fi
         done
     
     
     fi


fi


sleep 5

# lightdm (NEEDED TO BE USED AS THE DISPLAY MANAGER, FOR LXDE / AUTOBOOT)
LIGHTDM_PATH=$(get_app_path "lightdm")


# IF we are NOT running wayland/labwc (who knows if raspi wayland/labwc will continue using lightdm?)
if [ "$LIGHTDM_PATH" == "" ] && [ "$RUNNING_LABWC" == "" ]; then
                
                echo "${red}'lightdm' (display manager) could NOT be found or installed. PLEASE INSTALL MANUALLY, OR TRY A DIFFERENT OPERATING SYSTEM (Ubuntu, Debian, RaspberryPi OS, Armbian, etc)."
               
                echo "${yellow} "
                read -n1 -s -r -p $"PRESS ANY KEY to exit..." key
                echo "${reset} "
               
                    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
                    echo " "
                    echo "${green}Exiting...${reset}"
                    echo " "
                    exit
                    fi
                    
fi


######################################

              
# SET EARLY (IMMEADIATELY #AFTER# ANY LXDE INSTALL ABOVE), AS WE USE THIS IN A FEW PLACES
# KNOWN raspi LXDE profile, IF we are NOT running wayland/labwc
if [ -d /etc/xdg/lxsession/LXDE-pi ] && [ "$RUNNING_LABWC" == "" ]; then

LXDE_PROFILE="LXDE-pi"

# UNKNOWN generic LXDE profile, IF we are NOT running wayland/labwc
elif [ -d /etc/xdg/lxsession/LXDE ] && [ "$RUNNING_LABWC" == "" ]; then
      
LXDE_PROFILE="LXDE"

elif [ "$RUNNING_LABWC" == "" ]; then

echo " "
echo "${red}LXDE Desktop NOT detected (please install it, as it is REQUIRED to continue).${reset}"

echo "${yellow} "
read -n1 -s -r -p $"PRESS ANY KEY to exit..." key
echo "${reset} "

    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
    echo " "
    echo "${green}Exiting...${reset}"
    echo " "
    exit
    fi

fi


######################################


# Set autostart file path
if [ "$LXDE_PROFILE" != "" ]; then
AUTOSTART_LOCATION="/home/$APP_USER/.config/lxsession/$LXDE_PROFILE/autostart"
elif [ "$RUNNING_LABWC" != "" ]; then
AUTOSTART_LOCATION="/home/$APP_USER/.config/labwc/autostart"
fi


######################################


# Get lightdm's config file location to activate LXDE Desktop, IF we are not running wayland/labwc
if [ "$LXDE_PROFILE" != "" ] && [ "$RUNNING_LABWC" == "" ]; then


# https://wiki.debian.org/LightDM

  
     # FIRST LOCATION CHECK, FOR MULTI-FILE CONFIG DIRECTORY SETUP
     if [ -d /etc/lightdm/lightdm.conf.d ]; then
     
     # Find the PROPER config file in the checked config directory
     LIGHTDM_CONF_DIR="/etc/lightdm/lightdm.conf.d"
     
     LIGHTDM_CONFIG_FILE=$(grep -r 'user-session' $LIGHTDM_CONF_DIR | awk -F: '{print $1}')
     LIGHTDM_CONFIG_FILE=$(echo "${LIGHTDM_CONFIG_FILE}" | xargs) # trim whitespace
     
     fi
     
     
     # SECONDARY POSSIBLE LOCATION (IF NOT FOUND), FOR MULTI-FILE CONFIG DIRECTORY SETUP
     if [ -z "$LIGHTDM_CONFIG_FILE" ] && [ -d /usr/share/lightdm/lightdm.conf.d ]; then
     
     
     # Find the PROPER config file in the checked config directory
     LIGHTDM_CONF_DIR="/usr/share/lightdm/lightdm.conf.d"
     
     LIGHTDM_CONFIG_FILE=$(grep -r 'user-session' $LIGHTDM_CONF_DIR | awk -F: '{print $1}')
     LIGHTDM_CONFIG_FILE=$(echo "${LIGHTDM_CONFIG_FILE}" | xargs) # trim whitespace
     
     fi
     
     
     # DEFAULT LOCATION, IF NO MULTI-FILE CONFIG DIRECTORY SETUP DETECTED
     if [ -z "$LIGHTDM_CONFIG_FILE" ]; then
     LIGHTDM_CONFIG_FILE="/etc/lightdm/lightdm.conf"
     fi

     
     # Register the LXDE profile to lightdm's config file
     if [ ! -f "$LIGHTDM_CONFIG_FILE" ]; then
                     
     echo "${cyan}LIGHTDM config NOT detected, CREATING DEFAULT CONFIG at: ${LIGHTDM_CONFIG_FILE}${reset}"
                     
# Don't nest / indent, or it could malform the settings            
read -r -d '' LXDE_LOGIN <<- EOF
\r
user-session=$LXDE_PROFILE
\r
EOF

     # Setup LXDE config
     touch $LIGHTDM_CONFIG_FILE
     
     echo -e "$LXDE_LOGIN" > $LIGHTDM_CONFIG_FILE

     else
     
     sed -i "s/user-session=.*/user-session=${LXDE_PROFILE}/g" $LIGHTDM_CONFIG_FILE
     
     sleep 1
     
     # Make sure the modded setup config params are uncommented (active [redhat setups])
     sed -i "s/^#greeter-session/greeter-session/g" $LIGHTDM_CONFIG_FILE
     sed -i "s/^#user-session/user-session/g" $LIGHTDM_CONFIG_FILE
     
     fi	    
     			        

fi


######################################

       
# If LXDE is installed, AND WE ARE *NOT* RUNNING WAYLAND/LABWC
# (INDICATING RASPI'S NEW WAYLAND/LABWC DESKTOP IS *NOT* RUNNING)
if [ -d /etc/xdg/lxsession ] && [ "$RUNNING_LABWC" == "" ]; then

echo "${red}WE NEED TO MAKE SURE LXDE #AND# LIGHTDM AUTO-LOGIN AT STARTUP, AS THE USER '${APP_USER}', IF YOU WANT THE TICKER TO #AUTOMATICALLY RUN ON SYSTEM STARTUP# / REBOOT."
echo " "
echo "CHOOSE \"LIGHTDM\" IF ASKED, FOR \"AUTO-LOGIN AT BOOT\" CAPABILITIES.${reset}"
echo " "
echo "${yellow}Select 1 or 2 to choose whether to setup LXDE Desktop auto-login, or skip.${reset}"
echo " "
    
    OPTIONS="autologin_lxde skip"
    
    select opt in $OPTIONS; do
            if [ "$opt" = "autologin_lxde" ]; then

                if [ -f "/usr/bin/raspi-config" ]; then
                 
                echo " "
                echo "${red}Raspberry Pi OS should already have auto-login enabled, skipping auto-login setup...${reset}"
                echo " "
                
                else
                 
                echo " "
                echo "${cyan}Configuring lightdm auto-login at boot for user '${APP_USER}', please wait...${reset}"
                echo " "
                     
                # Auto-login lightdm / LXDE CONFIG logic...
                     
                echo "${cyan}LIGHTDM config detected at: $LIGHTDM_CONFIG_FILE${reset}"
     			    
     		 DETECT_AUTOLOGIN=$(sudo sed -n '/autologin-user=/p' $LIGHTDM_CONFIG_FILE)
     			    
     		 DETECT_AUTOLOGIN_SESSION=$(sudo sed -n '/autologin-session=/p' $LIGHTDM_CONFIG_FILE)
     			    
     			    
     			 if [ "$DETECT_AUTOLOGIN" != "" ]; then 
                     sed -i "s/autologin-user=.*/autologin-user=${APP_USER}/g" $LIGHTDM_CONFIG_FILE
                     else
                     sudo bash -c "echo 'autologin-user=${APP_USER}' >> ${LIGHTDM_CONFIG_FILE}"
     			 fi
     			        
                     
                sleep 1
     			    
     			    
     			 if [ "$DETECT_AUTOLOGIN_SESSION" != "" ]; then 
                     sed -i "s/autologin-session=.*/autologin-session=${LXDE_PROFILE}/g" $LIGHTDM_CONFIG_FILE
                     else
                     sudo bash -c "echo 'autologin-session=${LXDE_PROFILE}' >> ${LIGHTDM_CONFIG_FILE}"
     			 fi
     			 
                 
                sleep 1
                
                # Assure autologin timeout is DISABLED (WITH A ZERO)
                sed -i "s/autologin-user-timeout=.*/autologin-user-timeout=0/g" $LIGHTDM_CONFIG_FILE
                
                sleep 1
                 
                # On NEW LXDE installs (usually Fedora, but this SHOULD be safe to run on ANY),
                # just make sure the setup config params are uncommented (active)
                sed -i "s/^#autologin-user/autologin-user/g" $LIGHTDM_CONFIG_FILE
                sed -i "s/^#autologin-session/autologin-session/g" $LIGHTDM_CONFIG_FILE
                sed -i "s/^#autologin-user-timeout/autologin-user-timeout/g" $LIGHTDM_CONFIG_FILE
                 
                echo " "
                echo "${green}LXDE desktop auto-login has been configured.${reset}"
                echo " "
                 
                 
                     # If we are running dietpi OS, WARN USER AN ADDITIONAL STEP #MAY# BE NEEDED
                     if [ -f /boot/dietpi/.version ]; then
                     echo "${red}DietPi #SHOULD NOT REQUIRE# USING THE dietpi-autostart UTILITY TO SET LXDE TO AUTO-LOGIN AS THE USER '${APP_USER}', SINCE #WE JUST SETUP LXDE AUTO-LOGIN ALREADY#.${reset}"
                     fi
            
            
                fi
                
            
            break
           elif [ "$opt" = "skip" ]; then
            echo " "
            echo "${green}Skipping LXDE desktop setup...${reset}"
            break
           fi
           
    done
    

elif [ "$RUNNING_LABWC" == "" ]; then

echo "${red}THIS TICKER #REQUIRES# RUNNING #LIGHTDM# AND THE DESKTOP INTERFACE #LXDE# IN AUTO-LOGIN MODE AT STARTUP, AS THE USER '${APP_USER}', IF YOU WANT THE TICKER TO #AUTOMATICALLY RUN ON SYSTEM STARTUP# / REBOOT.${reset}"

fi

echo " "


######################################


echo "Do you want this script to automatically download the latest version of Slideshow Crypto Ticker from Github.com, and install it?"
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
				
				
				# FORCE UBUNTU SNAP INSTALLS
				# (included snaps can be messed up, especially on Ubuntu Armbian)
				if [ "$IS_UBUNTU" != "" ]; then
				     
				$UBUNTU_SNAP_INSTALL firefox
				     
				$UBUNTU_SNAP_INSTALL chromium
				     
				# SEEMS to throw error that BREAKS this script, due to not existing?
				#$UBUNTU_SNAP_INSTALL epiphany 
				     
				fi
				     
				     
			 # Firefox on raspbian
			 $PACKAGE_INSTALL firefox-esr -y
				
			 sleep 1
				
			 # epiphany on raspbian
			 $PACKAGE_INSTALL epiphany-browser -y
				
			 sleep 1
				
			 # Chromium on raspbian
			 $PACKAGE_INSTALL chromium-browser -y
				
		      sleep 5

                # Look for 'firefox-esr'
                FIREFOX_PATH=$(get_app_path "firefox-esr")

                    # If 'firefox-esr' NOT found, install epiphany
                    if [ -z "$FIREFOX_PATH" ]; then
    
    				# epiphany on ubuntu, etc
    				$PACKAGE_INSTALL firefox -y
    				
    				sleep 1
    				
                    fi

                # Look for 'epiphany-browser'
                EPIPHANY_PATH=$(get_app_path "epiphany-browser")

                    # If 'epiphany-browser' NOT found, install epiphany
                    if [ -z "$EPIPHANY_PATH" ]; then
    
    				# epiphany on ubuntu, etc
    				$PACKAGE_INSTALL epiphany -y
    				
    				sleep 1
    				
                    fi

                # Look for 'chromium-browser'
                CHROMIUM_PATH=$(get_app_path "chromium-browser")

                    # If 'chromium-browser' NOT found, install chromium
                    # ('chromium-browser' IS DEFAULT ON RASPI OS, AND THIS WOULD TRIGGER REPLACING IT WITH A #DOWNGRADED# VERSION)
                    if [ -z "$CHROMIUM_PATH" ]; then
    
    				# Chromium on ubuntu, etc
    				$PACKAGE_INSTALL chromium -y
    				
    				sleep 1
    				
                    fi
                    
                    
				
                    if [ -f "/etc/debian_version" ]; then
                        
				# Safely install other packages separately, so they aren't cancelled by 'package missing' errors
                        
     			# Grapics card detection support for firefox (for browser GPU acceleration)
     			$PACKAGE_INSTALL libpci-dev -y
     				
     			sleep 1
     				
     			# Not sure we need this Mesa 3D Graphics Library / OpenGL stuff, but leave for
     			# now until we determine why firefox is having issues enabling GPU acceleration
     			$PACKAGE_INSTALL freeglut3-dev -y
     				
     			sleep 1
     				
     			$PACKAGE_INSTALL libglu1-mesa-dev -y
     				
     			sleep 1
     				
     			$PACKAGE_INSTALL mesa-utils -y
     				
     			sleep 1
     				
     			$PACKAGE_INSTALL mesa-common-dev -y
     				
     			sleep 1
     				
     			$PACKAGE_INSTALL mesa-vulkan-drivers -y
     				
     			sleep 1
     				
     			$PACKAGE_INSTALL vulkan-icd -y
     				
     			sleep 1
				
				$PACKAGE_INSTALL x11-xserver-utils -y
     				
     			sleep 1
                        
                    elif [ -f "/etc/redhat-release" ]; then
                        
                    # Install generic graphics card libraries, and other interface-related libraries
                    $PACKAGE_INSTALL -y --skip-broken --skip-unavailable libglvnd-glx libglvnd-opengl libglvnd-devel qt5-qtx11extras xorg-x11-server-utils
                        
                    fi
	   
	          
	          # X11 TOOLS
	          # (DON'T RUN AN X11 CHECK, JUST INSTALL REGARDLESS, AS WE MAY BE SETTING UP HEADLESS INITIALLY!)     
			$PACKAGE_INSTALL xdotool -y

			sleep 1

			$PACKAGE_INSTALL xautomation -y
				
			sleep 3
				
    			# FIX FOR 2022-1-28 RASPI OS CHROMIUM BUG (DOES #NOT# FIX SAME ISSUE ON ARMBIAN)
    			# https://github.com/RPi-Distro/chromium-browser/issues/28
    			# /etc/chromium.d/ticker-fix-egl CAN BE NAMED ANYTHING, AS LONG AS IT'S IN /etc/chromium.d/
    			
			mkdir -p /etc/chromium.d/ > /dev/null 2>&1
				
			sleep 2	
				
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
			rm /home/$APP_USER/slideshow-crypto-ticker/bash/lxde-auto-start.bash > /dev/null 2>&1
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
		
	   # Remove ticker autostart line in any autostart file
        sed -i "/slideshow-crypto-ticker/d" $AUTOSTART_LOCATION > /dev/null 2>&1
        
        # Remove any #OLD# ticker autostart systemd service (which we no longer use)
        rm /lib/systemd/system/ticker.service > /dev/null 2>&1
        
        rm /etc/cron.d/ticker > /dev/null 2>&1
        
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
        echo "${yellow}Select the NUMBER next to the browser you want to use to render the ticker (chromium is recommended for long term reliability).${reset}"
        echo " "

                
        USER_BROWSER="chromium epiphany firefox"
                
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
				
	   # Scan for any existing autostart file data
	   AUTOSTART_NEW=$(sed -n '/bootup-auto-start.bash/p' $AUTOSTART_LOCATION)
    	   AUTOSTART_BROWSER=$(sed -n "/bootup-auto-start.bash ${SET_BROWSER}/p" $AUTOSTART_LOCATION)
    			
		      
		      # Setup if running labwc (wayland compositor)
                if [ "$RUNNING_LABWC" != "" ]; then

# Don't nest / indent, or it could malform the settings            
read -r -d '' TICKER_STARTUP <<- EOF
bash /home/$APP_USER/slideshow-crypto-ticker/bash/bootup-auto-start.bash $SET_BROWSER 2>&1 &
\r
EOF
			 
		      # Setup to run at LXDE login (with x11)
                elif [ -d /etc/xdg/lxsession ]; then
                
			 mkdir -p /home/$APP_USER/.config/lxsession/$LXDE_PROFILE > /dev/null 2>&1
				
			 sleep 2

# Don't nest / indent, or it could malform the settings            
read -r -d '' TICKER_STARTUP <<- EOF
@/home/$APP_USER/slideshow-crypto-ticker/bash/bootup-auto-start.bash $SET_BROWSER
\r
EOF
				
		      fi
						
						
			 # https://forums.raspberrypi.com/viewtopic.php?t=294014
				
     		 # If autostart file doesn't exist yet, create it, and append the ticker autostart code
                if [ ! -f $AUTOSTART_LOCATION ]; then 
                         
                echo " "
                echo "${cyan}Enabling USER-defined autostart (${AUTOSTART_LOCATION}), AND adding ticker autostart, please wait...${reset}"
                echo " "

                         
                      if [ "$LXDE_PROFILE" != "" ]; then
                      \cp /etc/xdg/lxsession/$LXDE_PROFILE/autostart /home/$APP_USER/.config/lxsession/$LXDE_PROFILE/
                      else
                      touch $AUTOSTART_LOCATION
                      fi
                         
                         
                sleep 2
                         
                echo -e "$TICKER_STARTUP" >> $AUTOSTART_LOCATION
                         
                # OR if we have not appended our ticker to an EXISTING autostart yet
                elif [ "$AUTOSTART_NEW" == "" ]; then 
                         
                echo " "
                echo "${cyan}Adding ticker autostart to USER-defined autostart (${AUTOSTART_LOCATION}), please wait...${reset}"
                echo " "
                         
                echo -e "$TICKER_STARTUP" >> $AUTOSTART_LOCATION
                         
                # OR if we just changed to a different browser
                elif [ "$AUTOSTART_BROWSER" == "" ]; then
                         
                echo " "
                echo "${cyan}Updating ticker autostart browser to ${SET_BROWSER}, in USER-defined autostart (${AUTOSTART_LOCATION}), please wait...${reset}"
                echo " "
                         
                sed -i "s/bootup-auto-start.bash .*/bootup-auto-start.bash ${SET_BROWSER}/g" $AUTOSTART_LOCATION
     				    
                fi    
				
				
	   AUTOSTART_ALERT=1
						
	   # Make sure any new files / folders have user permissions
	   chown -R $APP_USER:$APP_USER /home/$APP_USER/.config > /dev/null 2>&1
					
	   # Setup cron (to check logs after install: tail -f /var/log/syslog | grep cron -i)
	   
        # REMOVE ANY EXISTING #OLD WAY# THIS SCRIPT USED TO DO IT
        rm /lib/systemd/system/ticker.service > /dev/null 2>&1

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


echo "Enabling the built-in SSH server on your system allows easy remote management via SSH / SFTP (from another computer on your home / internal network), with Putty / Filezilla or any other SSH / SFTP enabled client software."
echo " "

echo "If you choose to NOT enable SSH on your system, you'll need to install / update your web site files directly on the device itself (not recommended)."
echo " "

echo "If you do use SSH, ---make sure the password for username '$APP_USER' is strong---, because anybody on your home / internal network will have access if they know the username/password!"
echo " "

if [ -f "/usr/bin/raspi-config" ]; then
echo "${yellow}Select 1 or 2 to choose whether to setup SSH (under 'Interfacing Options' in raspi-config), or skip it.${reset}"
echo " "
echo "${red}IF YOU CHOOSE OPTION 1, AND IT ASKS IF YOU WANT TO REBOOT AFTER CONFIGURATION, CHOOSE 'NO' OTHERWISE #THIS AUTO-INSTALL WILL ABORT PREMATURELY#! ONLY REBOOT #AFTER# AUTO-INSTALL WITH: sudo reboot${reset}"
else
echo "${yellow}Select 1 or 2 to choose whether to setup SSH, or skip it.${reset}"
fi

echo " "

OPTIONS="setup_ssh skip"

select opt in $OPTIONS; do
        if [ "$opt" = "setup_ssh" ]; then
        

				if [ -f "/usr/bin/raspi-config" ]; then
				echo " "
				echo "${cyan}Initiating raspi-config, please wait...${reset}"
				# WE NEED SUDO HERE, or raspi-config fails in bash
				sudo raspi-config
				elif [ -f /boot/dietpi/.version ]; then
				echo " "
				echo "${cyan}Initiating dietpi-software, please wait...${reset}"
				dietpi-software
				else
				
				echo " "
				echo "${green}Proceeding with openssh-server installation, please wait...${reset}"
				echo " "
				
				$PACKAGE_INSTALL openssh-server -y
				
				sleep 3
				
				echo " "
				echo "${green}openssh-server installation completed.${reset}"
				
				fi
        
        
        SSH_SETUP=1
        break
       elif [ "$opt" = "skip" ]; then
        echo " "
        echo "${green}Skipping SSH setup.${reset}"
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

echo "${green}The PREVIOUSLY-installed Slideshow Crypto Ticker configuration file /home/$APP_USER/slideshow-crypto-ticker/config.js has been backed up to:"
echo " "
echo "/home/$APP_USER/slideshow-crypto-ticker/config.js.BACKUP.$DATE${reset}"
echo " "
echo "${yellow}You will need to manually move any custom settings in this backup file to the new config.js file with a text editor.${reset}"
echo " "

echo "${red}IF ANYTHING STOPS WORKING AFTER UPGRADING, CLEAR YOUR BROWSER CACHE (temporary files), AND RELOAD OR RESTART THE APP. This will load the latest Javascript / Style Sheet upgrades properly.${reset}"
echo " "

fi


if [ "$AUTOSTART_ALERT" = "1" ]; then

echo "${green}Ticker autostart at login has been configured at:"
echo " "

echo "${AUTOSTART_LOCATION}${reset}"
     
echo " "
echo "${yellow}(the ticker should now start at boot/login with the $SET_BROWSER browser)${reset}"
echo " "

fi


if [ "$CRON_SETUP" = "1" ]; then

echo "${green}A cron job has been setup for user '$APP_USER', as a command in /etc/cron.d/ticker:"
echo " "
echo "$CRONJOB"
echo "${reset} "

fi


if [ "$AUTOSTART_ALERT" = "1" ]; then

echo "${yellow}If autostart does not work, you can run this command MANUALLY, #AFTER BOOTING INTO THE DESKTOP INTERFACE#, to start Slideshow Crypto Ticker:"
echo " "
echo "~/ticker-start"
echo " "
echo "If you prefer chromium, epiphany, or firefox (you set $SET_BROWSER as the default):"
echo " "
echo "~/ticker-start chromium"
echo " "
echo "~/ticker-start epiphany"
echo " "
echo "~/ticker-start firefox"
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
echo "If you prefer chromium, epiphany, or firefox (chromium is recommended for long term reliability):"
echo " "
echo "~/ticker-start chromium"
echo " "
echo "~/ticker-start epiphany"
echo " "
echo "~/ticker-start firefox"
echo " "
echo "To stop Slideshow Crypto Ticker:"
echo " "
echo "~/ticker-stop"
echo "${reset} "

fi


echo "${yellow}Edit the following file in a text editor to activate different exchanges / crypto assets / base pairings, and to configure settings for slideshow speed / font sizes and colors / background color / vertical position / screen orientation / google font used / monospace emulation / activated pairings / etc / etc:"
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
echo " "
echo "If NOT using x11 as a DISPLAY MANAGER, you can OPTIONALLY include which browser to reload with:"
echo " "
echo "~/ticker-restart chromium"
echo "${reset} "

echo "${cyan}Ticker installation / setup should be complete (if you chose those options), unless you saw any error messages on your screen during setup."
echo "${reset} "


if [ "$GOODTFT_SETUP" = "1" ]; then

echo "${yellow}TO COMPLETE THE 'goodtft LCD-show' LCD DRIVERS SETUP, run this command below to configure / activate your 'goodtft LCD-show' LCD screen:"
echo " "
echo "~/goodtft-only"
echo " "

echo "(your device will restart automatically afterwards)"
echo "${reset} "

elif [ "$AUTOSTART_ALERT" = "1" ]; then

echo "${red}You MUST RESTART YOUR DEVICE to auto-start the ticker, by running this command:"
echo " "
echo "sudo reboot"
echo "${reset} "

fi


if [ "$AUTOSTART_ALERT" = "1" ]; then

echo " "
echo "${red}TICKER AUTO-START #REQUIRES# RUNNING EITHER THE LXDE DESKTOP OR RASPBERRY PI OS DESKTOP AT STARTUP, AS THE USER: '${APP_USER}'${reset}"
echo " "

else

echo " "
echo "${red}TICKER #REQUIRES# RUNNING A DESKTOP INTERFACE AT STARTUP, AS THE USER: '${APP_USER}'${reset}"
echo " "

fi


if [ "$SSH_SETUP" = "1" ]; then

echo "${yellow}SFTP login details are..."
echo " "

echo "${green}INTERNAL NETWORK SFTP host (port 22, on home / internal network):"
echo " "
echo "IP ADDRESS (may change, unless set as static for this device within the router):"
echo "$IP"
echo " "
echo "HOST ADDRESS (ONLY works on linux / mac / windows, NOT android as of 2020):"
echo "${yellow}(IF YOU JUST CHANGED '${HOSTNAME}' in raspi / dietpi config, USE THAT INSTEAD)"
echo "${green} "
echo "${HOSTNAME}.local"

echo "SFTP username: $APP_USER"
echo " "
echo "SFTP password: (password for system user $APP_USER)"
echo "${reset} "

fi


echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " "

echo " "
echo "${red}!!!!!BE SURE TO SCROLL UP, TO SAVE #ALL THE APP USAGE DOCUMENTATION# PRINTED OUT ABOVE, BEFORE YOU SIGN OFF FROM THIS TERMINAL SESSION!!!!!${reset}"

     
echo "${yellow} "
read -n1 -s -r -p $"PRESS ANY KEY to continue..." key
echo "${reset} "
     
    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
    echo " "
    echo "${green}Continuing...${reset}"
    echo " "
    fi
     
echo " "


######################################

echo "${red} "
echo "============================================================="
echo "============================================================="
echo "=======  E N D   O F   I N S T A L L A T I O N !  ==========="
echo "============================================================="
echo "============================================================="
echo "${reset} "

echo "${yellow}ANY DONATIONS (LARGE OR SMALL) HELP SUPPORT DEVELOPMENT OF MY APPS..."
echo " "
echo "${cyan}Bitcoin: ${green}3Nw6cvSgnLEFmQ1V4e8RSBG23G7pDjF3hW"
echo " "
echo "${cyan}Ethereum: ${green}0x644343e8D0A4cF33eee3E54fE5d5B8BFD0285EF8"
echo " "
echo "${cyan}Solana: ${green}GvX4AU4V9atTBof9dT9oBnLPmPiz3mhoXBdqcxyRuQnU"
echo " "


######################################


# Mark the ticker install as having run already, to avoid showing
# the OPTIONAL ticker install options at end of the portfolio install
export TICKER_INSTALL_RAN=1

                    
if [ -z "$FOLIO_INSTALL_RAN" ]; then


echo " "
echo "Also check out my 100% FREE open source PRIVATE cryptocurrency investment portfolio tracker, with email / text / Alexa / Telegram alerts, charts, mining calculators, leverage / gain / loss / balance stats, news feeds and more:"
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
echo "${red}!!!!!BE SURE TO SCROLL UP, TO SAVE #ALL THE APP USAGE DOCUMENTATION# PRINTED OUT ABOVE, BEFORE YOU SIGN OFF FROM THIS TERMINAL SESSION!!!!!${reset}"
echo " "

echo "${yellow} "
read -n1 -s -r -p $"Installation / setup has finished, PRESS ANY KEY to exit..." key
echo "${reset} "

    if [ "$key" = 'y' ] || [ "$key" != 'y' ]; then
    echo " "
    echo "${green}Exiting...${reset}"
    echo " "
    exit
    fi

fi


######################################

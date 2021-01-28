#!/bin/bash

version="2"
#some variables
DEFAULT_ROUTE=$(ip route show default | awk '/default/ {print $3}')
IFACE=$(ip route show | awk '(NR == 2) {print $3}')
JAVA_VERSION=`java -version 2>&1 |awk 'NR==1{ gsub(/"/,""); print $3 }'`
MYIP=$(ip route show | awk '(NR == 2) {print $9}')

if [ $UID -ne 0 ]; then
    echo -e "\033[31This program must be run as root.This will probably fail.\033[m"
    sleep 3
    fi

###### Install script if not installed
if [ ! -e "/usr/bin/lazy" ];then
  echo "Script is not installed. Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
		cp -v $0 /usr/bin/lazy
		chmod +x /usr/bin/lazy
		#rm $0
		echo "Script should now be installed. Launching it !"
		sleep 3
		lazy
		exit 1
	else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
else
	echo "Script is installed"
	sleep 1
fi
### End of install process

### Check for updates !
if [[ "$silent" = "2" ]];then
	echo "Not checking for a new version : silent mode."
else
	changelog=$(curl --silent -q https://www.dropbox.com/s/3873zkaljg237ws/changelog?dl=0)
	last_version=$(curl --silent -q https://www.dropbox.com/s/w4cvxb4fmze2mov/version?dl=0) #store last version number to variable
	if [[ $last_version > $version ]];then # Comparing to current version
		echo -e "You are running version \033[31m$version\033[m, do you want to update to \033[32m$last_version\033[m? (Y/N)
Last changes are :
$changelog"
		read update
		if [[ $update = Y || $update = y ]];then
			echo "[+] Updating script..."
			wget -q https://www.dropbox.com/s/wznkb30ownkzpm3/lazy.sh?dl=0 -O $0
			chmod +x $0
			echo "[-] Script updated !"
			if [[ $0 != '/usr/bin/yamas' && $ask_for_install = 'y' ]];then
				echo -e "Do you want to install it so that you can launch it with \"lazy\" ?"
				read install
				if [[ $install = Y || $install = y ]];then #do not proceed to install if using installed version : updating it already "installed" it over.
					cp $0 /usr/bin/lazy
					chmod +x /usr/bin/lazy
					echo "Script should now be installed, launching lazy !"
					sleep 3
					lazy
					exit 1
				else
					echo "Ok, continuing with updated version..."
					sleep 3
					$0
					exit 1
				fi
			fi
		
		sleep 2
		$0
		exit 1
		else
			echo "Ok, continuing with current version..."
		fi
	else
		echo "No update available"
	fi
fi
### End of update process

#### pause function
function pause(){
   read -sn 1 -p "Press any key to continue..."
}

#### credits
function credits {
clear
echo -e "
\033[31m#######################################################\033[m
                       Credits To
\033[31m#######################################################\033[m"
echo -e "\033[36m
Special thanks to:
\033[m"
}

#### Screwup function
function screwup {
	echo "You Screwed up somewhere, try again."
	pause 
	clear
}


######## Update 
function update {
clear
echo -e "
\033[31m#######################################################\033[m
                Let's Update
\033[31m#######################################################\033[m"
select menusel in "Update" "Update and Clean" "Back to Main"; do
case $menusel in
	"Update")
		clear
		echo -e "\033[32mUpdating \033[m"
		#apt-get update && apt-get -y dist-upgrade
		apt-get update && apt-get -y upgrade 
		echo -e "\033[32mDone updating \033[m"
		pause
		clear ;;
	
	"Update and Clean")
		clear
		echo -e "\033[32mUpdating and Cleaning \033[m"
		apt-get update && apt-get -y dist-upgrade && apt-get autoremove -y && apt-get -y autoclean
		echo -e "\033[32mDone updating and cleaning \033[m" ;;
		
	"Back to Main")
		clear
		mainmenu ;;
		
	*)
		screwup
		updat ;;

esac

break

done
}

######## wifi
function wifi {
clear
echo -e "
\033[31m#######################################################\033[m
                  WiFi Tools
                  	Kismet - Wireless sniffing and monitoring
                  	Wavemon is a worelesse device monitoring application allows you to watch signal and noise levels and more
                  	Easy wifi is a phyton script to help with connect more easily
                  	 Linssid - A graphicaø WiFi scanner
\033[31m#######################################################\033[m"
select menusel in "Signal info" "install kismet" "start kismet" "start easy wifi" "install wavemon" "install linssid" "start linssid" "Back to Main"; do
case $menusel in
	"Signal info")
		nmcli
		pause
		wifi;;
		
	"install kismet")
		instkismet
		pause
		wifi;;
		
	"start kismet")
		opkismet
		pause
		wifi;;

	"start easy wifi")
		easywifi
		pause
		wifi;;
		
	"install wavemon")
		instwavemon
		pause
		wifi;;

	"start wavemon")
		opwavemon
		pause
		wifi;;
		
	"install linssid")
		instlinssid
		pause
		wifi;;
		
	"start linssd")
		oplinssid
		pause
		wifi;;
		
	"Back to Main")
		clear
		mainmenu ;;
		
	*)
		screwup
		OpenVas ;;
	
		
esac

break

done
}

######## install kismet
function instkismet {
	echo "This will install kismet. Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
		apt-get install kismet
	else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
	
}

######## start kismet
function opkismet {
	kismet
}

####### start easy wifi
function easywifi {
	python3 easywifi.py
}	

######## install wavemon
function instwavemon {
	echo "This will install wavemon. Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
		apt-get install wavemon
	else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
	
}
######## start wavemon
function opwavemon {
	wavemon
}
######## start nmcli
function nmcli {
	nmcli -F ALL dev wifi
}

######## install linssid
function instlinssid {
	echo "This will install kismet. Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
		apt-get install linssid
	else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
	
}
######## start wavemon
function oplinssid {
	linssid
}

######## nmap
function nmap {
clear
echo -e "
\033[31m#######################################################\033[m
                  nmap
\033[31m#######################################################\033[m"
select menusel in "install nmap" "nmap port scan" "install nmap bar" "nmap bar scan" "Back to Main"; do
case $menusel in
	"install nmap")
		instnmap
		pause 
		network;;

	"nmap port scan")
		portscannmap
		pause
		network;;


	"install nmap bar")
		instnmapbar
		pause
		network;;
		
	"nmap bar scan")
		nmapbar
		pause
		network;;
		
	"Back to Main")
		clear
		mainmenu ;;
		
	*)
		screwup
		network ;;
	
		
esac

break

done
}

######## install nmap
function instnmap {
	echo "This will install nmap. Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
		apt-get install nmap -y
	else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
	
}
######## port scan nmap
function portscannmap {
	echo "Do you want to save it in a file ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
	echo -en "Enter ip range?"
	read name
	echo -en "port?"
	read port
	echo -e "\e[93mScanning...\e[0m"
		sudo nmap -sV -Pn $name -p$port >> ipscan.txt
	else
	
	echo -en "Enter ip range?"
	read name
	echo -en "port?"
	read port
	echo -e "\e[93mScanning...\e[0m"
		sudo nmap -sV -Pn $name -p$port >> ipscan.txt
		
	fi
}

###### nmap with status bar
function instnmapbar {
	echo -e "\e[1;31minstall nmap bar\e[0m"
	echo "Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
				echo -e "\e[1;31m[+] Installing nmap bar\e[0m"
				echo -e ""
				sudo gem install tty-progressbar &&
				sudo gem install pastel &&
				sudo apt install git &&
				git clone https://github.com/Mr-P4p3r/nmapbar.git &&
				cd nmapbar &&
				mv ../nmapbar.rb &&
				rm -r nmbar
		else
			echo -e "\e[32m[-] Ok,maybe later !\e[0m"
		fi

}

######## nmap use
function nmapbar {
	echo "Do you want to start nmap scan? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
	echo -en "Enter ip range?"
	read name
	echo -e "\e[93mScanning...\e[0m"
		sudo ruby nmapbar.rb -s $name 
	else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
	
}

######## Open Vas Services
function OpenVas {
clear
echo -e "
\033[31m#######################################################\033[m
                  OpenVas Services
\033[31m#######################################################\033[m"
select menusel in "Start OpenVas Services" "Stop OpenVas Services" "Rollback V5" "Back to Main"; do
case $menusel in
	"Start OpenVas Services")
		openvasstart
		pause 
		OpenVas;;
	
	"Stop OpenVas Services")
		openvasstop
		pause
		OpenVas ;;
		
	"Rollback V5")
		rollbackopenvas
		pause
		OpenVas ;;

	"Back to Main")
		clear
		mainmenu ;;
		
	*)
		screwup
		OpenVas ;;
	
		
esac

break

done
}


#################################################################################
# JAVA JDK Update
#################################################################################
function installjava {
	echo -e "\e[1;31mThis option will update your JDK version to jdk1.7.0\e[0m"
	echo -e "\e[1;31mUse this only if java not installed or your version is older than this one!\e[0m"
	echo -e "\e[1;31mYour current Version is : $JAVA_VERSION\e[0m"
	echo "Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
			read -p "Are you using a 32bit or 64bit operating system [ENTER: 32 or 64]? " operatingsys
			if [ "$operatingsys" == "32" ]; then 
				echo -e "\e[1;31m[+] Downloading and Updating to jdk1.7.0\e[0m"
				echo -e ""
				wget --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" "http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-i586.tar.gz"
				tar zxvf jdk-7-linux-i586.tar.gz
				mv jdk1.7.0 /usr/lib/jvm
				update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0/jre/bin/java 2
				echo -e "\e[1;34mWhen prompted, select option 2\e[0m"
				sleep 2
				echo -e ""
				update-alternatives --config java
				rm jdk-7-linux-i586.tar.gz
				echo -e ""
				echo -e "\e[1;34mYour new JDk version is...\e[0m"
				echo ""
				java -version
				sleep 3
				echo ""
			else
				echo -e "\e[1;31m[+] Downloading and Updating to jdk1.7.0\e[0m"
				echo -e ""
				wget --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" "http://download.oracle.com/otn-pub/java/jdk/7u17-b02/jdk-7u17-linux-x64.tar.gz"
				tar zxvf jdk-7u17-linux-x64.tar.gz
				mv jdk1.7.0_17/ /usr/lib/jvm
				update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.7.0_17/jre/bin/java 2
				echo -e "\e[1;34mWhen prompted, select option 2\e[0m"
				sleep 2
				echo -e ""
				update-alternatives --config java
				rm jdk-7u17-linux-x64.tar.gz
				echo -e ""
				echo -e "\e[1;34mYour new JDk version is...\e[0m"
				echo ""
				java -version
				sleep 3
				echo ""
			fi
		else
			echo -e "\e[32m[-] Ok,maybe later !\e[0m"
		fi

}

#################################################################################
# Install Google Chrome
#################################################################################
function installgooglechrome {
	echo -e "\e[1;31mThis option will install Google Chrome Latest Version!\e[0m"
	echo "Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
			read -p "Are you using a 32bit or 64bit operating system [ENTER: 32 or 64]? " operatingsys
			if [ "$operatingsys" == "32" ]; then 
				echo -e "\e[1;31m[+] Downloading google-chrome-stable_current_i386\e[0m"
				wget wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
				echo -e "\e[32m[-] Done with download!\e[0m"
				echo -e "\e[1;31m[+] Installing google-chrome\e[0m"
				dpkg -i google-chrome-stable_current_i386.deb
				cp /opt/google/chrome/google-chrome.desktop /usr/share/applications/google-chrome.desktop
				echo -e "\e[1;31m[+] Patching to run as root!\e[0m"
				head -n -1 /opt/google/chrome/google-chrome > temp.txt ; mv temp.txt /opt/google/chrome/google-chrome
				echo 'exec -a "$0" "$HERE/chrome"  "$@" --user-data-dir' >> /opt/google/chrome/google-chrome
				chmod +x /opt/google/chrome/google-chrome
				echo -e "\e[32m[-] Done patching!\e[0m"
				rm google-chrome-stable_current_i386.deb
				echo -e "\e[32m[-] Done installing enjoy chrome!\e[0m"
			else
				echo -e "\e[1;31m[+] Downloading google-chrome-stable_current_amd64\e[0m"
				wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
				echo -e "\e[32m[-] Done with download!\e[0m"
				echo -e "\e[1;31m[+] Installing google-chrome\e[0m"
				dpkg -i google-chrome-stable_current_amd64.deb
				cp /opt/google/chrome/google-chrome.desktop /usr/share/applications/google-chrome.desktop
				echo -e "\e[1;31m[+] Patching to run as root!\e[0m"
				head -n -1 /opt/google/chrome/google-chrome > temp.txt ; mv temp.txt /opt/google/chrome/google-chrome
				echo 'exec -a "$0" "$HERE/chrome"  "$@" --user-data-dir' >> /opt/google/chrome/google-chrome
				chmod +x /opt/google/chrome/google-chrome
				echo -e "\e[32m[-] Done patching!\e[0m"
				rm google-chrome-stable_current_amd64.deb
				echo -e "\e[32m[-] Done installing enjoy chrome!\e[0m"
			fi
		else
			echo -e "\e[32m[-] Ok,maybe later !\e[0m"
		fi

}

#####openvasstart
function openvasstart {
# style variables
execstyle="[\e[01;32mx\e[00m]" # execute msgs style
warnstyle="[\e[01;31m!\e[00m]" # warning msgs stylee
infostyle="[\e[01;34mi\e[00m]" # informational msgs style

#fun little banner
clear
echo -e "\e[01;32m 
####### ######  ####### #     # #     #    #     #####  
#     # #     # #       ##    # #     #   # #   #     # 
#     # #     # #       # #   # #     #  #   #  #       
#     # ######  #####   #  #  # #     # #     #  #####  
#     # #       #       #   # #  #   #  #######       # 
#     # #       #       #    ##   # #   #     # #     # 
####### #       ####### #     #    #    #     #  #####  
                                                        
\e[0m"
echo -e "\e[1;1m   ..----=====*****(( Startup Script ))*******=====----..\e[0m"
echo -e "\e[31m *************************************************************\e[0m"
echo -e "\e[31m *                                                           *\e[0m"
echo -e "\e[31m *              \e[1;37mStarting All OpenVas Services \e[0;31m               *\e[0m"
echo -e "\e[31m *                      By Reaperz73                         *\e[0m"
echo -e "\e[31m *************************************************************\e[0m"

echo
echo -e "\e[31mKilling all Openvas for fresh start.\e[0m"
#kill openvas scanner
echo -e "$execstyle Checking OpenVas Scanner is running..."
ps -ef | grep -v grep | grep openvassd
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Scanner not running!" 
 else
	echo -e "$execstyle Stopping OpenVas Scanner..."
	killall openvassd
fi

#kill openvas administrator
echo -e "$execstyle Checking if OpenVas Administrator is running..."
ps -ef | grep -v grep | grep openvasad
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Administrator not running!" 
 else
	echo -e "$execstyle Stopping OpenVas Administrator..."
	killall openvasad
fi

#kill openvas manager
echo -e "$execstyle Checking if OpenVas Manager is running..."
ps -ef | grep -v grep | grep openvasmd
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Manager not running!" 
 else
	echo -e "$execstyle Stopping OpenVas Manager..."
	killall openvasmd
fi

#kill Greenbone Security Assistant
echo -e "$execstyle Checking if Greenbone Security Assistant is running..."
ps -ef | grep -v grep | grep gsad
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle Greenbone Security Assistant not running!" 
 else
	echo -e "$execstyle Stopping Greenbone Security Assistant..."
	killall gsad
fi

#### all done! now start services
echo
echo -e "\033[31mAll Done!! :\033[m
Now starting OpenVas services..."

echo -e "\033[31mSyncing updates.......\033[m
This may take a while!!!!"
openvas-nvt-sync
echo ok!

echo -e "\e[31mStarting OpenVas Scanner.\e[0m"
openvassd
echo ok!

echo -e "\033[31mRebuilding database......\033[m
This may take a while!!!!"
openvasmd --migrate
openvasmd --rebuild
echo ok!

echo -e "\e[31mStarting OpenVas Manager.\e[0m"
openvasmd -p 9390 -a 127.0.0.1
echo ok!

echo -e "\e[31mStarting OpenVas Administrator.\e[0m"
openvasad -a 127.0.0.1 -p 9393
echo ok!

echo -e "\e[31mStarting Greenbone Security Assistant.\e[0m"
gsad --http-only --listen=127.0.0.1 -p 9392
echo ok! All should be good!

#is it up openvas scanner
echo -e "$execstyle Checking if OpenVas Scanner is running..."
ps -ef | grep -v grep | grep openvassd
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Scanner not running!" 
 else
	echo -e "$infostyle OpenVas Scanner is running!!"
fi

#is it up openvas administrator
echo -e "$execstyle Checking if OpenVas Administrator is running..."
ps -ef | grep -v grep | grep openvasad
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Administrator not running!" 
 else
	echo -e "$infostyle OpenVas Administrator is running!!"
fi

#is it up openvas manager
echo -e "$execstyle Checking if OpenVas Manager is running..."
ps -ef | grep -v grep | grep openvasmd
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Manager not running!" 
 else
	echo -e "$infostyle OpenVas Manager is running!!"
fi

#is it up Greenbone Security Assistant
echo -e "$execstyle Checking if Greenbone Security Assistant is running..."
ps -ef | grep -v grep | grep gsad
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle Greenbone Security Assistant not running!" 
 else
	echo -e "$infostyle Greenbone Security Assistant is running"
fi

#### all done!
echo
echo -e "\033[01;32mOK!!\033[m"
echo -e "\033[31mAll Done!! :) \033[m
OpenVas is running!! Open browser to 127.0.0.1:9392 or open Green Bone Security Desktop."
}

########openvasstop
function openvasstop {
# style variables
execstyle="[\e[01;32mx\e[00m]" # execute msgs style
warnstyle="[\e[01;31m!\e[00m]" # warning msgs style
infostyle="[\e[01;34mi\e[00m]" # informational msgs style

#fun little banner
clear
echo -e "\e[01;32m
####### ######  ####### #     # #     #    #     #####  
#     # #     # #       ##    # #     #   # #   #     # 
#     # #     # #       # #   # #     #  #   #  #       
#     # ######  #####   #  #  # #     # #     #  #####  
#     # #       #       #   # #  #   #  #######       # 
#     # #       #       #    ##   # #   #     # #     # 
####### #       ####### #     #    #    #     #  #####  
                                                        
\e[0m"
echo -e "\e[1;1m   ..----=====*****(( Shutdown Script ))*******=====----..\e[0m"
echo -e "\e[31m *************************************************************\e[0m"
echo -e "\e[31m *                                                           *\e[0m"
echo -e "\e[31m *              \e[1;37mStopping All OpenVas Services \e[0;31m               *\e[0m"
echo -e "\e[31m *                                                           *\e[0m"
echo -e "\e[31m *************************************************************\e[0m"

#kill openvas scanner
echo -e "$execstyle Checking OpenVas Scanner is running..."
ps -ef | grep -v grep | grep openvassd
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Scanner not running!" 
 else
	echo -e "$execstyle Stopping OpenVas Scanner..."
	killall openvassd
	echo -e "$infostyle OpenVas Scanner is dead!!"
fi

#kill openvas administrator
echo -e "$execstyle Checking if OpenVas Administrator is running..."
ps -ef | grep -v grep | grep openvasad
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Administrator not running!" 
 else
	echo -e "$execstyle Stopping OpenVas Administrator..."
	killall openvasad
	echo -e "$infostyle OpenVas Administrator is dead!!"
fi

#kill openvas manager
echo -e "$execstyle Checking if OpenVas Manager is running..."
ps -ef | grep -v grep | grep openvasmd
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle OpenVas Manager not running!" 
 else
	echo -e "$execstyle Stopping OpenVas Manager..."
	killall openvasmd
	echo -e "$infostyle OpenVas Manager is dead!!"
fi

#kill Greenbone Security Assistant
echo -e "$execstyle Checking if Greenbone Security Assistant is running..."
ps -ef | grep -v grep | grep gsad
if [ $? -eq 1 ]
 then
	echo -e "$warnstyle Greenbone Security Assistant not running!" 
 else
	echo -e "$execstyle Stopping Greenbone Security Assistant..."
	killall gsad
	echo -e "$infostyle Greenbone Security Assistant is dead!!"

fi

#### all done!
echo
echo -e "\033[01;32m All Done!! :) \033[m"
}

######## Rollback Openvas to Version 5
function rollbackopenvas {
echo -e "\033[31mThis script will roll OpenVas back to Version 5\033[m"
echo -e "\033[31myou may need this if you broke Openvas with apt-get dist-upgrade\033[m"
echo "Do you want to rollback ? (Y/N)"
read install
if [[ $install = Y || $install = y ]] ; then	
		echo -e "\033[31m====== Rolling OpenVas back to V5 ======\033[m"
		apt-get remove --purge greenbone-security-assistant libopenvas6 openvas-administrator openvas-manager openvas-cli openvas-scanner
		mkdir openvasfix
		cd openvasfix
		if [ $(uname -m) == "x86_64" ] ; then
			#64 bit system
			wget http://repo.kali.org/kali/pool/main/o/openvas-manager/openvas-manager_3.0.4-1kali0_amd64.deb
			wget http://repo.kali.org/kali/pool/main/o/openvas-administrator/openvas-administrator_1.2.1-1kali0_amd64.deb
			wget http://repo.kali.org/kali/pool/main/o/openvas-cli/openvas-cli_1.1.5-1kali0_amd64.deb
			wget http://repo.kali.org/kali/pool/main/o/openvas-scanner/openvas-scanner_3.3.1-1kali1_amd64.deb
			wget http://repo.kali.org/kali/pool/main/o/openvas/openvas_1.1_amd64.deb
			wget http://repo.kali.org/kali/pool/main/g/greenbone-security-assistant/greenbone-security-assistant_3.0.3-1kali0_amd64.deb
			wget http://repo.kali.org/kali/pool/main/libo/libopenvas/libopenvas5_5.0.4-1kali0_amd64.deb
		else
			#32 bit system
			wget http://repo.kali.org/kali/pool/main/o/openvas-manager/openvas-manager_3.0.4-1kali0_i386.deb
			wget http://repo.kali.org/kali/pool/main/o/openvas-administrator/openvas-administrator_1.2.1-1kali0_i386.deb
			wget http://repo.kali.org/kali/pool/main/o/openvas-cli/openvas-cli_1.1.5-1kali0_i386.deb
			wget http://repo.kali.org/kali/pool/main/o/openvas-scanner/openvas-scanner_3.3.1-1kali1_i386.deb
			wget http://repo.kali.org/kali/pool/main/o/openvas/openvas_1.1_i386.deb
			wget http://repo.kali.org/kali/pool/main/g/greenbone-security-assistant/greenbone-security-assistant_3.0.3-1kali0_i386.deb
			wget http://repo.kali.org/kali/pool/main/libo/libopenvas/libopenvas5_5.0.4-1kali0_i386.deb
		fi
		dpkg -i *
		apt-get install gsd kali-linux kali-linux-full
		wget --no-check-certificate https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup
		chmod +x openvas-check-setup
		./openvas-check-setup --v5
		else
			echo -e "\e[32m[-] Ok,maybe later !\e[0m"
		fi
		echo -e "\e[32m[-] Done!\e[0m"	
}


######### Install extras
function extras {
clear
echo -e "
\033[31m#######################################################\033[m
                Install Extras
\033[31m#######################################################\033[m"

select menusel in "Google Chrome" "Java" "Install All" "Back to Main"; do
case $menusel in


		
	"Google Chrome")
		installgooglechrome
		pause 
		extras;;	
		
	"Java")
		installjava
		pause
		extras ;;

	"Back to Main")
		clear
		mainmenu ;;
		
	*)
		screwup
		extras ;;
	
		
esac

break

done
}
########################################################
##             Main Menu Section
########################################################
function mainmenu {
echo -e "
\033[31m################################################################\033[m
\033[1;36m
.____                          
|    |   _____  ___________.__.
|    |   \__  \ \___   <   |  |
|    |___ / __ \_/    / \___  |
|_______ (____  /_____ \/ ____|
        \/    \/      \/\/     
\033[m                                        
                    version : \033[32m$version\033[m
Script Location : \033[32m$0\033[m
Connection Info :-----------------------------------------------
  Gateway: \033[32m$DEFAULT_ROUTE\033[m Interface: \033[32m$IFACE\033[m My LAN Ip: \033[32m$MYIP\033[m
\033[31m################################################################\033[m"

select menusel in "Update" "WiFi tools" "nmap" "OpenVas Services" "Install Extras"  "HELP!" "Credits" "EXIT PROGRAM"; do
case $menusel in
	"Update")
		update
		clear ;;

	"WiFi tools")
		wifi
		clear ;;
	
	"nmap")
		nmap
		clear;;
		
	"OpenVas Services")
		OpenVas
		clear ;;

	"Install Extras")
		extras 
		clear ;;

	"Payload Gen")
		payloadgen
		clear ;;
	
	"HELP!")
		echo "What do you need help for, seems pretty simple!"
		pause
		clear ;;
		
	"Credits")
		credits
		pause
		clear ;;

	"EXIT PROGRAM")
		clear && exit 0 ;;
		
	* )
		screwup
		clear ;;
esac

break

done
}

while true; do mainmenu; done

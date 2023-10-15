#!/usr/bin/env bash
#
# This script randomizes your Mac Address, HostName, 
# LocalHostName, and ComputerName

sudo printf ""

clear

#Title
echo "===Mac Address and Name Randomizer==="

echo -e

#Query

printf "Randomize Name?(y/n):"

read char

clear

echo "===Mac Address and Name Randomizer==="

echo -e

#---Config File-------------------------------

FILE=~/Documents/Mac_Address_Randomizer/macaddress.conf

if test -f "$FILE"
then
    printf ""
else

    # Get the active network interface name
    active_interface=$(ip -o -4 route show to default | awk '{print $5}')

    # Extract the number from the interface name
	# int=$(echo "$active_interface" | grep -oE '[0-9]+')

	sudo mkdir ~/Documents/Mac_Address_Randomizer/

	sudo touch ~/Documents/Mac_Address_Randomizer/macaddress.conf

    originalAddress=$(ip link show $active_interface | awk '/link\/ether/ {print $2}')

    #originalAddressTrunc=${originalAddress:7}

	echo $active_interface | sudo tee -a ~/Documents/Mac_Address_Randomizer/macaddress.conf

    echo $(hostname) | sudo tee -a /~/Documents/Mac_Address_Randomizer/macaddress.conf

    echo $originalAddress | sudo tee -a ~/Documents/Mac_Address_Randomizer/macaddress.conf
fi

int=$(sed -n '1p' ~/Documents/Mac_Address_Randomizer/macaddress.conf)

#----------------------------------------------------


#---Name Randomization-------------------------------

if [[ $char == y ]]
then

RandomName=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

sudo hostnamectl set-hostname $RandomName

echo $active_interface | sudo tee -a ~/Documents/hosts

sudo sed -i "2s/.*/127.0.1.1       $RandomName/" /etc/hosts

echo "Name Changed Successfully"

echo -e

else
	echo ""
fi

#----------------------------------------------------


#---Mac Address Randomization------------------------

OldAddress=$(ip link show $active_interface | awk '/link\/ether/ {print $2}')

#echo -e

echo "+-------------------------------+"

echo "| 		Old Mac Address |" 

echo "|${OldAddress:17:35}|"

echo "+-------------------------------+"

echo -e

sudo ifconfig wlan0 down

while [[ $(ip link show $active_interface | awk '/link\/ether/ {print $2}') == $OldAddress ]]
do

	NewAddress=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

	sudo ifconfig wlan0 hw ether $NewAddress

done

# restart network interface

 sudo ifconfig wlan0 up

clear

echo "===Mac Address and Name Changer==="

echo -e

if [[ $char == y ]]
then
echo "Name Changed Successfully"
else 
	printf ""
fi

echo -e

echo "+-------------------------------+"

echo "| 		Old Mac Address |" 

echo "|${OldAddress:17:35}|"

echo "+-------------------------------+"

echo -e

#----------------------------------------------------



#---Checks-------------------------------------------

if [[ $(ip link show $active_interface | awk '/link\/ether/ {print $2}') != $OldAddress ]]
then
#	dscacheutil -flushcache

echo -e

echo "+-------------------------------+"

echo "| 		New Mac Address |" 

temp=$(ip link show $active_interface | awk '/link\/ether/ {print $2}')

echo "|${temp:17:35}|"

echo "+-------------------------------+"

echo -e

echo "Success!"

echo -e

else

	echo "Failed"

fi

#----------------------------------------------------

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

FILE=/Library/Mac_Address_Randomizer/macaddress.conf

if test -f "$FILE"
then
    printf ""
else

#	echo "Number after 'en' in Interface Name:"

#	read int

    # Get the active network interface name
    active_interface=$(route get default | awk '/interface: /{print $2}')

    # Extract the number from the interface name
    int=$(echo "$active_interface" | grep -oE '[0-9]+')

	sudo mkdir /Library/Mac_Address_Randomizer/

	sudo touch /Library/Mac_Address_Randomizer/macaddress.conf

    originalAddress=$(ifconfig en$int | grep ether)

    originalAddressTrunc=${originalAddress:7}

	echo $int | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

    echo $(sudo scutil --get HostName) | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

    echo $(sudo scutil --get LocalHostName) | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

    echo $(sudo scutil --get ComputerName) | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

    echo $originalAddressTrunc | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf
fi

int=$(sed -n '1p' /Library/Mac_Address_Randomizer/macaddress.conf)

#----------------------------------------------------


#---Name Randomization-------------------------------

if [[ $char == y ]]
then

RandomName=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

sudo scutil --set HostName $RandomName

sudo scutil --set LocalHostName $RandomName

sudo scutil --set ComputerName $RandomName

echo "Name Changed Successfully"

echo -e

else
	echo ""
fi

#----------------------------------------------------


#---Mac Address Randomization------------------------

OldAddress=$(Ifconfig en$int |grep ether)

#echo -e

echo "+-------------------------------+"

echo "| 		Old Mac Address |" 

echo "|$OldAddress|"

echo "+-------------------------------+"

echo -e

while [[ $(ifconfig en$int |grep ether) == $OldAddress ]]
do

	NewAddress=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

	sudo ifconfig en$int ether $NewAddress

done

# restart network interface

sudo networksetup -setnetworkserviceenabled Wi-Fi off && sudo networksetup -setnetworkserviceenabled Wi-Fi off && sudo networksetup -setnetworkserviceenabled Wi-Fi on

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

echo "|$OldAddress|"

echo "+-------------------------------+"

echo -e

#----------------------------------------------------



#---Checks-------------------------------------------

if [[ $(ifconfig en$int |grep ether) != $OldAddress ]]
then
	dscacheutil -flushcache

echo -e

echo "+-------------------------------+"

echo "| 		New Mac Address |" 

echo "|$(ifconfig en$int |grep ether)|"

echo "+-------------------------------+"

echo -e

echo "Success!"

echo -e

else

	echo "Failed"

fi

#----------------------------------------------------

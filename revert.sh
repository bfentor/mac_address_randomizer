#!/usr/bin/env bash

FILE=~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf

if test -f "$FILE"
then
	interfaceNumber=$(sed -n '1p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)
	originalHostName=$(sed -n '2p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)
	originalLocalHostName=$(sed -n '3p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)
	originalComputerName=$(sed -n '4p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)
	originalAddress=$(sed -n '5p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)
else

	echo "Number after 'en' in Interface Name:"

	read interfaceNumber

	echo $interfaceNumber >> macaddress.conf

	originalAddress=$(ifconfig en1 | grep ether)

	originalAddressTrunc=${originalAddress:7}

	echo -e $(sudo scutil --get HostName) >> ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf

	echo -e $(sudo scutil --get LocalHostName) >> ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf

	echo -e $(sudo scutil --get ComputerName) >> ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf

	echo $originalAddress >> ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf

	originalHostName=$(sed -n '2p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)
	originalLocalHostName=$(sed -n '3p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)
	originalComputerName=$(sed -n '4p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)
	originalAddress=$(sed -n '5p' ~/Documents/Networking/Mac_Address_Randomizer/macaddress.conf)

fi

previousAddress=$(ifconfig en$interfaceNumber |grep ether)

previousAddressTrunc=${previousAddress:7}

#while [[ $(ifconfig en$interfaceNumber |grep ether) == $previousAddress ]]
#do
#	
#	sudo networksetup -setnetworkserviceenabled Wi-Fi off
#
	NewAddress=$originalAddress
#
#	sudo networksetup -setnetworkserviceenabled Wi-Fi on
#
#Obligatory spinner
#
#	sleep 0.5
#
#	printf "\b${sp:i++%${#sp}:1}"
#
#	sleep 0.5
#
#	printf "\b${sp:i++%${#sp}:1}"
#
#	sleep 0.5
#
#	printf "\b${sp:i++%${#sp}:1}"
#
#	sleep 0.5
#
#	printf "\b${sp:i++%${#sp}:1}"
#
#	sleep 0.5
#
#	printf "\b${sp:i++%${#sp}:1}"

sudo ifconfig en$interfaceNumber ether $originalAddress

#done

sudo scutil --set HostName $originalHostName

sudo scutil --set LocalHostName $originalLocalHostName

sudo scutil --set ComputerName $originalComputerName

echo "Success"
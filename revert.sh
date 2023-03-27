#!/usr/bin/env bash

FILE=macaddress.conf

if test -f "$FILE"
then
	interfaceNumber=$(sed -n '1p' macaddress.conf)
	originalHostName=$(sed -n '2p' macaddress.conf)
	originalLocalHostName=$(sed -n '3p' macaddress.conf)
	originalComputerName=$(sed -n '4p' macaddress.conf)
	originalAddress=$(sed -n '5p' macaddress.conf)
else

	echo "Number after 'en' in Interface Name:"

	read interfaceNumber

	echo $interfaceNumber >> macaddress.conf

	originalAddress=$(ifconfig en1 | grep ether)

	originalAddressTrunc=${originalAddress:7}

	echo $originalAddressTrunc >> macaddress.conf

	echo -e $(sudo scutil --get HostName) >> macaddress.conf

	echo -e $(sudo scutil --get LocalHostName) >> macaddress.conf

	echo -e $(sudo scutil --get ComputerName) >> macaddress.conf

	originalHostName=$(sed -n '2p' macaddress.conf)
	originalLocalHostName=$(sed -n '3p' macaddress.conf)
	originalComputerName=$(sed -n '4p' macaddress.conf)
	originalAddress=$(sed -n '5p' macaddress.conf)

fi

OldAddress= $(ifconfig en$interfaceNumber |grep ether)

while [[ $(ifconfig en$interfaceNumber |grep ether) == $OldAddress ]]
do
	
	sudo networksetup -setnetworkserviceenabled Wi-Fi off

	NewAddress=$originalAddress

	sudo networksetup -setnetworkserviceenabled Wi-Fi on

#Oligatory spinner

	sleep 0.5

	printf "\b${sp:i++%${#sp}:1}"

	sleep 0.5

	printf "\b${sp:i++%${#sp}:1}"

	sleep 0.5

	printf "\b${sp:i++%${#sp}:1}"

	sleep 0.5

	printf "\b${sp:i++%${#sp}:1}"

	sleep 0.5

	printf "\b${sp:i++%${#sp}:1}"

	sudo ifconfig en$interfaceNumberTrunc ether $NewAddress

done

sudo scutil --set HostName $originalHostName

sudo scutil --set LocalHostName $originalLocalHostName

sudo scutil --set ComputerName $originalComputerName

echo "Success"

#echo $interfaceNumber
#echo $originalHostName
#echo $originalLocalHostName
#echo $originalComputerName
#echo $originalAddress

#if test -f "$FILE"
#then
#    echo ""
#else
#
#	echo "Revert to original name?(y/n)"
#
#	read int
#
#	touch macaddress.conf
#
#	echo $int > macaddress.conf

#	echo $(cat macaddress.conf)
#fi
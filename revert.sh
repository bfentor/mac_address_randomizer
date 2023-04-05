#!/usr/bin/env bash

FILE=/Library/Mac_Address_Randomizer/macaddress.conf

sudo printf ""

if test -f "$FILE"
then
	interfaceNumber=$(sed -n '1p' /Library/Mac_Address_Randomizer/macaddress.conf)
	originalHostName=$(sed -n '2p' /Library/Mac_Address_Randomizer/macaddress.conf)
	originalLocalHostName=$(sed -n '3p' /Library/Mac_Address_Randomizer/macaddress.conf)
	originalComputerName=$(sed -n '4p' /Library/Mac_Address_Randomizer/macaddress.conf)
	originalAddress=$(sed -n '5p' /Library/Mac_Address_Randomizer/macaddress.conf)
else

	echo "Number after 'en' in Interface Name:"

	read interfaceNumber

	sudo mkdir /Library/Mac_Address_Randomizer

	echo $interfaceNumber | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

#	echo $interfaceNumber >> /Library/Mac_Address_Randomizer/macaddress.conf

	originalAddress=$(ifconfig en$interfaceNumber | grep ether)

	originalAddressTrunc=${originalAddress:7}

	echo $(sudo scutil --get HostName) | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

	echo $(sudo scutil --get LocalHostName) | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

	echo $(sudo scutil --get ComputerName) | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

	echo $originalAddressTrunc | sudo tee -a /Library/Mac_Address_Randomizer/macaddress.conf

#	echo -e $(sudo scutil --get HostName) >> /Library/Mac_Address_Randomizer/macaddress.conf
#
#	echo -e $(sudo scutil --get LocalHostName) >> /Library/Mac_Address_Randomizer/macaddress.conf
#
#	echo -e $(sudo scutil --get ComputerName) >> /Library/Mac_Address_Randomizer/macaddress.conf
#
#	echo $originalAddress >> /Library/Mac_Address_Randomizer/macaddress.conf

	originalHostName=$(sed -n '2p' /Library/Mac_Address_Randomizer/macaddress.conf)
	originalLocalHostName=$(sed -n '3p' /Library/Mac_Address_Randomizer/macaddress.conf)
	originalComputerName=$(sed -n '4p' /Library/Mac_Address_Randomizer/macaddress.conf)
	originalAddressTrunc=$(sed -n '5p' /Library/Mac_Address_Randomizer/macaddress.conf)

fi

previousAddress=$(ifconfig en$interfaceNumber |grep ether)

previousAddressTrunc=${previousAddress:7}

sudo scutil --set HostName $originalHostName

sudo scutil --set LocalHostName $originalLocalHostName

sudo scutil --set ComputerName $originalComputerName

i=1

#while [[ i == 5 ]]
#do
#	
#	sudo ifconfig en$interfaceNumber ether $originalAddress
#	
#	echo $previousAddress
#	echo $previousAddressTrunc
#	echo $originalAddress
#
#	i=$(expr i + 1)
#
#done

until [ $i -gt 3 ]
do
  
	sudo ifconfig en$interfaceNumber ether $originalAddress

#	echo $previousAddress
#	echo $previousAddressTrunc
#	echo $originalAddress

  ((i=i+1))
done

sudo networksetup -setnetworkserviceenabled Wi-Fi off && sudo networksetup -setnetworkserviceenabled Wi-Fi off && sudo networksetup -setnetworkserviceenabled Wi-Fi on

dscacheutil -flushcache

echo "Success"

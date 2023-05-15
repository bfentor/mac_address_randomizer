#!/usr/bin/env bash
#
# This script reverts all changes made by
# macaddress.sh

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

echo "Nothing to revert to. Run macaddress.sh first."

exit 0

fi

previousAddress=$(ifconfig en$interfaceNumber |grep ether)

previousAddressTrunc=${previousAddress:7}

sudo scutil --set HostName $originalHostName

sudo scutil --set LocalHostName $originalLocalHostName

sudo scutil --set ComputerName $originalComputerName

i=1

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

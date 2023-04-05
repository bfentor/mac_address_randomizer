#!/usr/bin/env bash
#
# This script randomizes your Mac Address, HostName, 
# LocalHostName, and ComputerName

#---Config File-------------------------------

FILE=/Library/Mac_Address_Randomizer/macaddress.conf

if test -f "$FILE"
then
    printf ""
else

	exit 0

fi

int=$(sed -n '1p' /Library/Mac_Address_Randomizer/macaddress.conf)

#----------------------------------------------------


#---Name Randomization-------------------------------

RandomName=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

sudo scutil --set HostName $RandomName

sudo scutil --set LocalHostName $RandomName

sudo scutil --set ComputerName $RandomName

#----------------------------------------------------


#---Mac Address Randomization------------------------

OldAddress=$(Ifconfig en$int |grep ether)

while [[ $(ifconfig en$int |grep ether) == $OldAddress ]]
do

	NewAddress=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

	sudo ifconfig en$int ether $NewAddress

done

# restart network interface

sudo networksetup -setnetworkserviceenabled Wi-Fi off && sudo networksetup -setnetworkserviceenabled Wi-Fi off && sudo networksetup -setnetworkserviceenabled Wi-Fi on

clear

#----------------------------------------------------

dscacheutil -flushcache
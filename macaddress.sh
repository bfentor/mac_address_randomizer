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

FILE=macaddress.conf

if test -f "$FILE"
then
    printf ""
else

	echo "Number after 'en' in Interface Name:"

	read int

	touch macaddress.conf

	echo $int > macaddress.conf

#	echo $(cat macaddress.conf)
fi

int=$(cat macaddress.conf)

#Counting Var for Spinner
i=1
sp="/-\|"

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
	
	sudo networksetup -setnetworkserviceenabled Wi-Fi off

	NewAddress=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

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

	sudo ifconfig en$int ether $NewAddress

done

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

#!/usr/bin/env bash
#
# This script reverts all changes made by
# macaddress.sh

FILE=~/Documents/Mac_Address_Randomizer/macaddress.conf

sudo printf ""

if test -f "$FILE"
then
	interface=$(sed -n '1p' $FILE)
	originalHostName=$(sed -n '2p' $FILE)
	originalAddress=$(sed -n '3p' $FILE)
else

echo "Config file not found. Run macaddressLinux.sh first."

exit 0

fi

previousAddress=$(ip link show $interface | awk '/link\/ether/ {print $2}')

sudo hostnamectl set-hostname $originalHostName

i=1

until [ $i -gt 3 ]
do
  
	sudo ifconfig $interface hw ether $originalAddress

#	echo $previousAddress
#	echo $previousAddressTrunc
#	echo $originalAddress

  ((i=i+1))
done

sudo ip route flush cache

sudo ip -s -s neigh flush all

sleep 2

sudo systemctl restart NetworkManager

sleep 2

echo "Success"

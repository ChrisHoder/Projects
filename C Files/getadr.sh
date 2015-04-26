#
# File: getadr.sh
#
# Description: takes the filename "address.dat" as an input parameter.
#              Uses ifconfig to get the actual full IP address and subnet mask.
#             Assumed that host is ona LInux machine which uses Ethernet.
#
# Input: filename
#
#
# Output: full IP address and subnet mask saved to filename
#

#check to make sure only one input
if [ $# != 1 ]
    then
       echo "input a filename"
       exit 1
fi

#getts the line with the ip address and the mask address
Addresses=`ifconfig eth0 | grep -i "inet addr"`
#gets the ip address
IP=`echo $Addresses | cut -d':' -f2 | cut -d' ' -f1`
#gets the mask address
MASK=`echo $Addresses | cut -d':' -f4`

#creates the file
> $1
#adds the ip and the mask separated by a space
echo -ne "$IP\n$MASK" >> $1

exit 0
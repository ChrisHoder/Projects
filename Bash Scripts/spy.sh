#!/bin/bash
# Script name: spy.sh
#
# Description: Monitors when users log in and out of a machine and sends e-mail on
# each time a user logs in and out to the user. It also sends a summary and the end of
# the day to all users informing them of their usage patterns including how many times
# they logged in and out and the duration. The script also computes which user logged
# in the most often, and for the longest and shortest periods of time.
# In addition. At 10pm Monday Jan 17 the users will get an email about all times
# they logged on while the program was running detailing each account and which 
# User was on the longest, shortest period and most time overall.
#
#
# Input: List of users to monitor in terms of their full names such as ‘‘Andrew Campbell’’
#
# Output: E-mails the user each time they log out. And sends a e-mail summary of activity
# at the end of the day to all users monitored.

#check to see if name was input
if [ $# -eq 0 ]
 then
    echo "Input a person to spy on"
    exit 1
fi


i=0
#loops through and adds all of the input names
#also checks to make sure that each user exists
for arg
do
# Finds the Username for the input person

    USER[$i]=`less /etc/passwd | grep -i "$arg" | cut -d':' -f1`
    if [ ! ${USER[$i]} ]
    then
	echo "All users must exist"
	exit 1
    fi
    USERON[$i]=0
    Usertotal[$i]=0
    UserTimes[$i]=0
# Creates file to save user log in info in.
    > ${USER[$i]}.txt
    let i=$i+1
done

# Outputs that the given users were found and added to the spy list
let Len=${#USER[*]}
let k=0
while [ $k -lt $Len ]
do
    echo "${USER[$k]} added to spy list"
    Long[$k]=0
    #arbitrary large number so that all logins will be a shorter time period
    Short[$k]=999999999999999999999
    let k=$k+1
done

# Unit conversion for finding out how long people have
# been on for.

let hours=3600
let days=216000
let min=60

# This while loop will run forever.
while [ true ]
do

# Check if users are on
j=0
while [ $j -lt $Len ]

do
    #status
    status=`who | cut -d' ' -f1 | grep -ix ${USER[$j]} | sort -u`
    
# If the user was on last time the loop ran
    if [ ${USERON[$j]} == 1 ]
	then
       #Case where user was on before and now has logged off.
	  if [ ! $status ]
            then
	       
	       USERON[$j]=0
	       UserSignOff[$j]=`date`
	       
	       #Find out the length of time the user was on
	       d1=`date +%s`
	       d2=${UserSec[$j]}
	       #difference in seconds between sign on and sign off
	       let diff=$d1-$d2
	       let numDays=$diff/$days
	       let numHours=$diff/$hours
	       let numHours2=$numHours%24
	       let numMinutes=$diff/$min
	       let numMinutes2=numMinutes%60
	       let seconds=$diff%60
	       
	       #rounds the seconds up.
	       if [ $seconds -ge 30 ]
	       then
		   let numMinutes2=$numMinutes2+1
	       fi

	       # sets initial one minute if the user was on for less than
	       # a minute
	       if [ $numMinutes2 == 0 ]
		   then
		   numMinutes2=1
	       fi
	       #sets the time to the array of times on
	       UserTimeOn[$j]="$numDays Days, $numHours2 Hours, and $numMinutes2 minutes" 
	       echo "You logged onto wildcat as ${USER[$j]} at ${UserSignOn[$j]}. You were logged on for ${UserTimeOn[$j]} and logged off at ${UserSignOff[$j]}." | mail -s "Gotcha ${USER[$j]}" ${USER[$j]}
	       
	       #saves the information to file for logging
	       echo -n "logged in at ${UserSignOn[$j]}; Logged off at ${UserSignOff[$j]}." >> ${USER[$j]}.txt

	       # Add to totals for the user
	       let Usertotal[$j]=${Usertotal[$j]}+$diff
	       let UserTimes[$j]=${UserTimes[$j]}+1

	       #longest time for the user
	       if [ $diff -gt ${Long[$j]} ]
	       then
		   Long[$j]=$diff
	       fi
	       
	       # Checks to see if it is the shortest time
	       if [ $diff -lt ${Short[$j]} ]
	       then
		       Short[$j]=$diff
	       fi
	      
	  fi
    #user initially off in the last loop run
    else
	#user was off but has now logged on
	if [ $status ]
	 then
	   #gets two dates. The full date, and date in seconds from a
	   #point in time
	    USERON[$j]=1
	    UserSignOn[$j]=`date`
	    UserSec[$j]=`date +%s`
	fi
    
    fi
let j=$j+1
done


# Email section for update

#date for comparison to set email time
d=`date '+%m/%d/%y'`
#time-hour
let t=`date '+%H'`
#minutes
let m=`date '+%M'`

# Checks the time to the 11/17/2011 date at 10pm
if [ "$d" == "01/17/11" ] && [ $t == 22 ] && [ $m == 00 ]
then
    #create message file
    > MailMessage.txt
    
    # Input the begining sentences
    echo -e "Dear Sneaky cs23 Guys: \n\n Caugt you sneaking\
on wildcat today. Here's a summary of my surveillance:" >> MailMessage.txt

    #shortest overall. Set to zero.
    shortOverall=0
    #initial shortest person statment. Needed so that if nobody signs on
    #there is not an error
    statement=''

    #longest overall. Set to zero.
    longOverall=0
    #initial longest person statment.
    statement2=''

    #most time
    mostTime=0
    statement3=''

    let p=0
    #loops through all users
    while [ $p -lt $Len ]
    do
	#change the total to minutes
	let TotalTime=${Usertotal[$p]}/60
	echo -e "${USER[$p]} you logged on ${UserTimes[$p]} times for a total\
 period of $TotalTime minutes.\n\n  Here is the breakdown: \n" >> MailMessage.txt
	
	w=0
	let ti=${UserTimes[$p]}
	while [ $w -lt $ti ]
	do
	    let w=$w+1
	    #info about session
	    info=`less ${USER[$p]}.txt | cut -d'.' -f$w`
	    echo "$w) $info" >> MailMessage.txt
	done
	echo "" >> MailMessage.txt
	
	# Finds the shortest log on time
	let shortest=${Short[$p]}
	if [ $shortest -lt $shortOverall ]
	then
	    shortOverall=$shortest
	    statement="Looks like ${USER[$p]} was on for the shortest session for a period of $shortOverall,\
 and therefore the most sneaky"
	fi
	
	# Finds the longest log on time and writes the email part
	let longest=${Long[$p]}
	if [ $longest -gt $longOverall ]
	then
	    longOverall=$longest
	    #convert to minutes
	    let longMin=$longest/60
	    statement2="and, ${USER[$p]} logged on for the longest session of $longMin minutes."
	fi
	
	# Finds the person who spent the most time on wildcat
	let ttotal=${Usertotal[$p]}
	if [ $ttotal -gt $mostTime ]
	then
	    mostTime=$ttotal
	    #convert seconds to minutes
	    let mostMinutes=$mostTime/60
	    statement3="Looks like ${USER[$p]} spent the most\
 time on wildcat today - $mostMinutes mins in total for all his sessions;"
	fi
	let p=$p+1
    done
    
    echo "$statement3 $statement $statement2" >> MailMessage.txt
    echo -e "\n Three variables are maintained and reported: \n \n \
Thought you could sneak by my code hey - nailed you.\
\n \n Best, \n\n Chris Hoder" >> MailMessage.txt
    
    e=0
    #sends the email to all users
    while [ $e -lt $Len ]
    do
	mail -s "Gotcha" ${USER[$e]} < MailMessage.txt
	let e=$e+1
        done

    fi

#sleeps the loop for 60 seconds
sleep 60
done
exit 0
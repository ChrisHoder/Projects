#!/bin/bash
#
#
#
#
# File: leap_year.sh
#
#
# Description: script has a year as its input and determines if it is a leap year. If the year is not a leap year,
#              the next leap year after the date entered will be given.
#
# Input: year
#
# Output: if the year is a leapyear it will indicate so. If not it will output
#         the next leap year after the year given
#


# check to make sure there is only one input
if [ $# != 1 ]
    then
          echo "Input a year"
	  exit 1
fi

#divides the input year by 400,100 and 4 to see if the number is divisble by either
let fourHund=$1%400
let oneHund=$1%100
let four=$1%4

#variable to know when their is leap year
IsLeap=0

#if the year is divisible by 400 it is a leap year
if [ "$fourHund" == 0 ] 
    then 
    echo "$1 is a leap year"
    exit 0
#if the year is divisible by 100 but not 400 it is not
#a leap year
elif [ "$oneHund" == 0 ]
    then
    IsLeap=1
#If the year is divisible 4 and not 400,not 100 it is a leap year
elif [ "$four" == 0 ]
    then
    echo "$1 is a leap year"
    exit 0
#the year is not divisible by 4,400 or 100
else
   IsLeap=1
fi

# Finds the next leap year after the year given
# While loop will repeat checking each next
# year until a leap year is found
let year=$1+1
 while [ "$IsLeap" == 1 ]
    do
     # repeats the previous process to see if the new year
     # is the leap year
       let b=$year%4
       let c=$year%100
       let d=$year%400
      
       if [ "$b" == 0 ] && [ "$c" != 0 ]
	 then
	   IsLeap=0
       elif [ "$b" == 0 ] && [ "$d" == 0 ]
	 then
	   IsLeap=0
       else
	 let year=$year+1
       fi
 done

echo "$1 is not a leap year."
echo "The closest leap year after that year is $year"  

    
#!/bin/bash
#
# File: birthday_match.sh
#
# Description: takes two birthdays (or dates) of the form MM/DD/YYYY and returns whether
#              the two people were born on the same day of the week.
#
#
#
# Input:       Two dates of the form MM/DD/YYYY
#
#
# Output: Tells you the day of the week for each date, and whether or not they were born
#              on the same day of the week.
#
#

#if/then statement checks to make sure there are only 2 inputs. If there are not it exits 1.
if [ $# != 2 ]
  then
    echo "Input needs to be of two forms of the format MM/DD/YYYY"
    exit 1
fi

#These two lines find the day of the week for the two birthdates
DATE1=`date -d $1 | cut -d' ' -f1`
DATE2=`date -d $2 | cut -d' ' -f1`

#these are the statements read out for the day the people were born.
statement="The first person was born on: "
statement2="The second person was born on: "

#This if/then looks to see if they were born on the same date.
if [ $DATE1 == $DATE2 ]

then
    echo $statement $DATE1
    echo $statement2 $DATE2
    echo Jackpot: you were both born on the same day!

else
    echo $statement $DATE1
    echo $statement2 $DATE2
    echo Therefore, you are not born on the same day
fi

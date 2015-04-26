#!/bin/bash
#
#
# File: count_linesinfiles.sh
#
# Description: This counts the number of ordinary files (not directories 
#              in the current working directory and its sub-directories.
#              For each ordinary file found the script counts the number 
#              of lines int eh file and prints the total number of lines 
#              in all the files.
#
#
#
# Input:       no inputs
#
#
# Output:      list of files and the number of lines in the files. 
#              Also pritns the total number of files found
#

# gets all of the ordinary files in the current directory and its sub
# directories
Files=`find -type f -name '*'`

# Check to make sure there are no inputs to the script
if [ $# != 0 ]
    then
       echo "There are no inputs to this script"
       exit 1
fi


echo "Counting lines of all files..."

# Counting variables. total 
# the number of files found.
let total=0
let fileNumber=0
for file in $Files
  do

# this finds the number of lines in the given file
    lines=`wc -l $file`
    echo $lines
    let number=`echo $lines |  cut -d' ' -f1`
    let total=$total+$number
    let fileNumber=$fileNumber+1
  done

echo "$total Total"


echo "****************************"
echo "Number of files found: $fileNumber"
echo "****************************"


exit 0
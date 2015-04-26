#!/bin/bash
#
#
# File: wget_search.sh
#
# Description: takes a text file containing a list of URLs and a sequence
#              of words as input. The script then searches the web pages 
#              for the occurences of the words in teh webpages.
#
#
# Input:       text file containing a list of URLs and a sequence of words
#
#
# Output:      number of occurances of the input words on each of the 
#              webpages
#
#

# Checks to make sure there is at least 2 inputs. First would be a text
# file with the URLs and the second would be a word
if [ $# == 0 ] || [ $# == 1 ]
    then
       echo "Input a text file with URLS and words to be searched for"
       exit 1
fi

# Checks to see if the first file is actually a file
file=$1
if [ ! -r $file ]
then
    echo "First input must be a text file with the URLS in it"
    exit 1

fi


#download the pages
URLS=`more $1`
let counter=1
for url in $URLS
   do
    wget -qO $counter.html $url
    let counter=$counter+1
   done

#shifts so the $1 is the first word not the url file
shift
#loops through all the arguments and will
#search all the websites and count the times the
#word goes through
for arg
do
    echo $1
    let i=1
    while [ $i -lt $counter ]
    do
	# counts the words by searching for them
	# and print on a new line and then counting
	# the number of lines
	wordsCount=`more $i.html | grep -io $1 | wc -l`
	loc=`echo $URLS | cut -d' ' -f$i`
	echo -n $loc "   "
	echo $wordsCount
	let i=$i+1
	done
    echo 
    shift
    let counter2=$counter2+1
done
exit 0


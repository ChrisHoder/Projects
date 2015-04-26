#!/bin/bash



if [ $# != 0 ]
    then
    echo "this script takes no inputs"
    exit 1
fi


dateFile=`date`

> "crawler_testlog.$dateFile"
make clean

echo -e "\n\n\n" >> "crawler_testlog.$dateFile"
echo "output of make command" >> "crawler_testlog.$dateFile"
make >> "crawler_testlog.$dateFile"
if [ $? -ne 0 ]
    then
    echo "Return value wrong!" >> "crawler_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "crawler_testlog.$dateFile"
echo "Test with bad SEED_URL" >> "crawler_testlog.$dateFile"
echo "crawler http://ajdfaskdlfja ./pages 2" >> "crawler_testlog.$dateFile"
crawler http://ajdfaskdlfja ../pages 2 >> "crawler_testlog.$dateFile"
if [ $? -ne 1 ]
    then
    echo "Return value wrong!" >> "crawler_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "crawler_testlog.$dateFile"
echo "Test with bad directory" >> "crawler_testlog.$dateFile"
echo "crawler http://www.cs.dartmouth.edu /afds 2" >> "crawler_testlog.$dateFile"
crawler http://www.cs.dartmouth.edu /afds 2 >> "crawler_testlog.$dateFile"
if [ $? -ne 1 ]
    then
    echo "Return value wrong!" >> "crawler_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "crawler_testlog.$dateFile"
echo "Test with bad depth" >> "crawler_testlog.$dateFile"
echo "crawler http://www.cs.dartmouth.edu ./pages asdf" >> "crawler_testlog.$dateFile"
crawler http://www.cs.dartmouth.edu ../pages asdf >> "crawler_testlog.$dateFile"
if [ $? -ne 1 ]
    then
    echo "Return value wrong!" >> "crawler_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "crawler_testlog.$dateFile"
echo "Test with too few inputs" >> "crawler_testlog.$dateFile"
echo "crawler http://www.cs.dartmouth.edu ./pages" >> "crawler_testlog.$dateFile"
crawler http://www.cs.dartmouth.edu ../pages >> "crawler_testlog.$dateFile"
if [ $? -ne 1 ]
    then
    echo "Return value wrong!" >> "crawler_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "crawler_testlog.$dateFile"
echo "Test of the crawler at depth 3 on http://www.cs.dartmouth.edu" >> "crawler_testlog.$dateFile"
echo "crawler http://www.cs.dartmouth.edu ./pages 3" >> "crawler_testlog.$dateFile"
crawler http://www.cs.dartmouth.edu ../pages 3 >> "crawler_testlog.$dateFile"
if [ $? -ne 0 ]
    then
    echo "Return value wrong!" >> "crawler_testlog.$dateFile"
    exit 1
fi
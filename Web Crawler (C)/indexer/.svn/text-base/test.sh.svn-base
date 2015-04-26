#!/bin/bash

if [ $# != 0 ]
    then
    echo "this script  takes no inputs"
    exit 1
fi

dateFile=`date`
>"indexer_testlog.$dateFile"
make clean

echo -e "\n\n\n" >> "indexer_testlog.$dateFile"
echo "output of make command" >> "indexer_testlog.$dateFile"
make >> "indexer_testlog.$dateFile"
if [ $? -ne 0 ]
    then
    echo "Return value wrong!" >> "indexer_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "indexer_testlog.$dateFile"
echo "Test with no Inputs" >> "indexer_testlog.$dateFile"
echo "indexer" >> "indexer_testlog.$dateFile"
indexer >> "indexer_testlog.$dateFile"
if [ $? -ne 255 ]
    then
    echo "Return value wrong!" >> "indexer_testlog.$dateFile"
    exit 1
fi

echo -e "\n\n\n" >> "indexer_testlog.$dateFile"
echo "Test with one input" >> "indexer_testlog.$dateFile"
echo "indexer ../pages" >> "indexer_testlog.$dateFile"
indexer ../pages >>  "indexer_testlog.$dateFile"
if [ $? -ne 255 ]
    then
    echo "Return value wrong!" >> "indexer_testlog.$dateFile"
    exit 1
fi


echo -e  "\n\n\n" >> "indexer_testlog.$dateFile"
echo "Test with 3 inputs" >> "indexer_testlog.$dateFile"
echo "indexer ../pages index.dat index.dat" >> "indexer_testlog.$dateFile"
indexer ../pages index.dat index.dat >> "indexer_testlog.$dateFile"
if [ $? -ne 255 ]
    then
    echo "Return value wrong!" >> "indexer_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "indexer_testlog.$dateFile"
echo "Test with bad directory" >> "indexer_testlog.$dateFile"
echo "indexer ./asdfkjasf index.dat" >> "indexer_testlog.$dateFile"
indexer ../asdfkjasf index.dat >> "indexer_testlog.$dateFile"
if [ $? -ne 255 ]
    then
    echo "Return value wrong!" >> "indexer_testlog.$dateFile"
    exit 1
fi



echo -e "\n\n\n" >> "indexer_testlog.$dateFile"
echo "Test of indexer in regular mode" >> "indexer_testlog.$dateFile"
echo "indexer ../pages index.dat" >> "indexer_testlog.$dateFile"
indexer ../pages index.dat >> "indexer_testlog.$dateFile"
if [ $? -ne 0 ]
    then
    echo "Return value wrong!" >> "indexer_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "indexer_testlog.$dateFile"
echo "Test of indexer in test mode" >> "indexer_testlog.$dateFile"
echo "indexer ../pages index.dat index.dat new_index.dat" >> "indexer_testlog.$dateFile"
indexer ../pages index.dat index.dat new_index.dat >> "indexer_testlog.$dateFile"
if [ $? -ne 0 ]
    then
    echo "Return value wrong!" >> "indexer_testlog.$dateFile"
    exit 1
fi


echo -e "\n\n\n" >> "indexer_testlog.$dateFile"
echo "Test of the difference" >> "indexer_testlog.$dateFile"
echo "diff index.dat new_index.dat" >> "indexer_testlog.$dateFile"
diff index.dat new_index.dat >> "indexer_testlog.$dateFile"
if [ $? -ne 0 ]
    then
    echo "Return value wrong!" >> "indexer_testlog.$dateFile"
    exit 1
fi
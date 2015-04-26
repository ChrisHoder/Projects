#!/bin/bash

# FILE: make_test_run_tinysearch.sh

if [ $# != 0 ]
    then
    echo "this script  takes no inputs"
    exit 1
fi

cd ../crawler
./test.sh

cd ../indexer
./test.sh

cd ../query

make clean
make

./query_test
if [ $? -ne 0 ]
    then
    echo "Return value wrong!"
    exit 1
fi

./Query_Engine ../indexer/index.dat ../pages
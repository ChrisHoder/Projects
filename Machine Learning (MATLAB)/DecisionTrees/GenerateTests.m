% FILE: GenerateTests.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/5/2013
% COSC 74 Final Project
% 
% This script can be used for generating decision tests for our random
% decision forest. Beware that this take a long time to run since it will
% find some 11+ million splits and involves sorting over 2400 times. 
%
% To find decision tests we take all of our data and then for every
% variable we sort our examples on that variable. we then look at each
% point and if the y output value switches between the point and the next
% we take the mid-point between them to be a decision test. 

close all; clear all; clc
AddPaths;
load('All_Train_Test.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% USER CAN MAKE A CHOICE OF ONE OF THE FOLLOWING DATA SETS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataChoices = [6, 12,18,24];
dataSet = 18;

if( dataSet == 6),
    dataX = x6train;
    dataY = y6train;
    testX = x6test;
    testY = y6test;
elseif( dataSet == 12),
    dataX = x12train;
    dataY = y12train;
    testX = x12test;
    testY = y12test;
elseif( dataSet == 18 )
    dataX = x18train;
    dataY = y18train;
    testX = x18test;
    testY = y18test;
elseif( dataSet == 24)
    dataX = x24train;
    dataY = y24train;
    testX = x24test;
    testY = y24test;
end


variables = size(dataX,2);
examples = size(dataX,1);

%tests will be stored
%  [idx value]
tests = zeros((2000*examples),2);
testCount = 1;
dataX = [dataX dataY];
for i =1:variables,
    sortedVals = sortrows(dataX,i);
    for j=2:examples,
        %if no change inoutput value
        if( sortedVals(j,end) == sortedVals(j-1,end))
            continue
        %change in the output value. add the midpoint as a decision split
        else
            value1 = sortedVals(j,i);
            value2 = sortedVals(j-1,i);
            value = (value1+value2)/2;
            tests(testCount,:) = [i, value];
            testCount = testCount + 1;
            %updates on the number of counts
            if(mod(testCount,20000) == 0),
                fprintf('reached %d testCounts',testCount);

            end
        end
    end    
end
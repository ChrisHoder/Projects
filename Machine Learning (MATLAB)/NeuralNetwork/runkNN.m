% FILE: runkNN.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/5/2013
% COSC 74 Final Project
%
%
% This script will run a k nearest neighbor classifier on the test set. the
% user must choose the data set to use by setting the dataSet line below.
clear all; close all; clc
run('AddPaths.m');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%      SET THESE PARAMETERS       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataSet = 12; % timeframe you are training
kChoice = 5; % number of neighbors to get

% LOADS DATA
load('All_Train_Test.mat');

%CHOOSES THE CORRECT DATA SET
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

%SETS THE DATA TO BOOLEAN
dataX = dataX(dataY(:) >= 0,:);
dataY = dataY(dataY(:) >= 0);
dataY(dataY(:) >= 0.1) = 1;
dataY(dataY(:) < 0.1) = 0;
examples = length(dataY);


testX = testX(testY(:) >= 0,:);
testY = testY(testY(:) >= 0);
testY(testY(:) >= 0.1) = 1;
testY(testY(:) < 0.1 ) = 0;

nonPrecipWrong = 0;
precipWrong = 0;
fprintf(['----------------------------------------------------------\n',...
         '              Begining kNN classification                 \n',...
         '----------------------------------------------------------\n']);
% For each example, find the predicted value
for i = 1:length(testY),
    prediction = classify_kNN(testX(i,:),dataX,dataY,kChoice);
    % see if the prediction is correct, if not find out which type was
    % classified wrong.
    if( prediction == 1 && testY(i) == 0),
        nonPrecipWrong = nonPrecipWrong + 1;
    elseif( prediction == 0 && testY(i) == 1),
        precipWrong = precipWrong + 1;
    end
    % print updates for the user
    if( mod(i,floor(length(testY)/16)) == 0),
        fprintf('On iteration %d out of %d\n', i, length(testY));
        fprintf('Precip events classified wrong, %d out of %d\n', precipWrong, sum(testY(1:i) == 1));
        fprintf('Non precip classified wrong, %d out of %d\n', nonPrecipWrong, sum(testY(1:i) == 0));
    end
end

% Print status update
fprintf('Precip Wrong %d out of %d\n',precipWrong, sum(testY(:) == 1));
fprintf('Non precip wrong %d out of %d \n',nonPrecipWrong, sum(testY(:) == 0));
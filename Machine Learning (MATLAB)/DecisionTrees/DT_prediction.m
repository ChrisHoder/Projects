% FILE: DT_prediction.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
% This script will train a decision tree forest for our project.
%
close all; clear all; clc
AddPaths;
load('All_Train_Test.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  USER SETTINGS  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

dataSet = 6; % chose timeframe from 6, 12, 18 or 24
C = 0.05; %max leaf size
numTrees = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% LOAD DATA CORRECTLY %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
dataX = dataX(dataY(:) >= 0,:);
dataY = dataY(dataY(:) >= 0);
dataY(dataY(:) >= 0.1) = 1;
dataY(dataY(:) < 0.1) = 0;
examples = length(dataY);

%[testX, testY] = pickYears(trainX,trainY,21,23);

testX = testX(testY(:) >= 0,:);
testY = testY(testY(:) >= 0);
testY(testY(:) >= 0.1) = 1;
testY(testY(:) < 0.1 ) = 0;

trees = DecisionTreeForest(dataX,dataY,C,numTrees); %generate trees
errorTest = 0;
precipBad = 0;
otherBad = 0;

% test to see the accuracy of this method on the test set
for j = 1:length(testY),
    y = pDF_posterior(trees,testX(j,:));
    if( y ~= testY(j)),
        if( y == 0),
            precipBad = precipBad +1 ;
        else
            otherBad = otherBad + 1;
        end
        %fprintf('Predicted %d. Actual %d \n',y,testY(j));
        errorTest = errorTest + 1;
    end
end

%test to see the accuracy on the training set
errorTrain = 0;
for j = 1:length(dataY),
    y = pDF_posterior(trees,dataX(j,:));
    if( y ~= dataY(j)),
        %fprintf('Predicted %d. Actual %d \n',y,dataY(j));
        errorTrain = errorTrain + 1;
    end
end

fprintf('\nDecision Tree Results \n');
fprintf('Miss-classified %d out of %d precipitation events\n',precipBad,sum(testY(:) == 1));
fprintf('Miss-classified %d out of %d non-precip events \n',otherBad,sum(testY(:) == 0));


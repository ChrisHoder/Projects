% FILE: RunClassifier.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%clc;clear all; close all;
clc
load('All_Train_Test.mat');
f = @sigmoid;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SET THE dataSet VARIABLE TO CHOOSE WHICH DATA SET YOU WANT %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataSet = 6;

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

%%% Normalize output data
maxY = max(dataY);
maxY2 = max(testY);
minY = min(dataY);
minY2 = min(testY);
if( maxY2 > maxY )
    maxY = maxY2;
end
if( minY2 < minY)
    minY = minY2;
end

dataY = (dataY-minY)/(maxY-minY);
testY = (testY-minY)/(maxY-minY);

addpath('../')
AddPaths
[FileName,PathName,~] = uigetfile('./','Select Classification Data');

load([PathName,FileName]);
W_class = W_best;
b_class = b_best;
clear W_best b_best
[FileName,PathName,~] = uigetfile('./','Select Regression Data');
load([PathName,FileName]);
W_reg = W_best;
b_reg = b_best;


fprintf(['\n-----------------------------------------------------------\n',...
    '-------------------------------------------------------------\n',...
    '        CASCADE CLASSIFICATION RESULTS FOR LOADED WEIGHTS\n',...
    '-----------------------------------------------------------\n',...
    '-------------------------------------------------------------\n']);

% Run the casscade error rate on the training set %
[errorRate, missClassPrecip,missClassPrecipError, nonPrecipError,...
 nonprecipCount] = ...
        getCascadeErrorRate(dataX,dataY,W_class,b_class,W_reg,b_reg,f);

% Print the result
fprintf(['\n\nTrain Set \n\tError rate: %0.4f,\n\tmiss-classified Precip',...
        'events, %d of %d, \n\tfor  avgerage sum squared error: %0.4f\n\tNon Precip Events ',...
        'miss-classified, %d,\n\t for average sum squared error: %0.4f\n'],...
        errorRate, missClassPrecip,sum(dataY(:) >=0.1), missClassPrecipError/missClassPrecip, nonprecipCount,...
        nonPrecipError/nonprecipCount);
fprintf(['\n-----------------------------------------------------------\n',...
    '-------------------------------------------------------------\n']);

% Run the casscade error rate on the training set %
[errorRate, missClassPrecip, missClassPrecipError,nonPrecipError,...
 nonprecipCount,] = ...
        getCascadeErrorRate(testX,testY,W_class,b_class,W_reg,b_reg,f);
  
% print the result
fprintf(['\n\nTest Set \n\tError rate: %0.4f,\n\tmiss-classified Precip',...
        'events, %d of %d, for sum squared error: %0.4f\n\tNon Precip Events ',...
        'miss-classified, %d, out of %d, for average sum squared error: %0.4f\n'],...
        errorRate, missClassPrecip,sum(testY(:)>=0.1), missClassPrecipError/missClassPrecip, nonprecipCount,...
        sum(testY(:) <0.2),nonPrecipError/nonprecipCount);
fprintf(['\n-----------------------------------------------------------\n',...
    '-------------------------------------------------------------\n']);
% FILE: train_NN_case_regression.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
%
% This script allows the user train a generic neural network. They simply 
% need to set the parameters in teh user set options section below. This 
% script is for a regression neural network. 
% The caseInfo structure matches the inputs needed for the ANNTrain method 
% and the inputs for the settingsStruct input are repeated below:
%
%  settingsStruc: This structure contains all of the settings for training
%                 neural network. The expected settings are the following:
%                   
%    settingsStruc.hiddenLayers:       Number of hidden layer (including
%                                      ouputs)
% 
%    settingsStruc.Nodes:              Number of Nodes in each layer as 
%                                      vector
%
%    settingsStruc.inputs:             Number of input variables
%
%    settingsStruc.momentumParam:      Amount of the previous trial step
%                                      direction to add to the next trial
%                                      step. This is optional. Default = 0
%
%    settingsStruc.alpha:              This is the initaial learning 
%                                      parameter (step size).
%
%    settingsStruc.f:                  Node activation function handle
%
%    settingsStruc.fprime:             Derivative of node activation
%                                      function f
%
%    settingsStruc.InfoRange:          This specifies the number of
%                                      evaluations of the gradient there
%                                      will be for each value of alpha
%                                      during the line search. This is an
%                                      optional parameter. Default is 1/2
%                                      the length of the training set
%
%    settingsStruc.alphaMax:           This sepcifies the maximum allowable
%                                      value of alpha. If the alpha value
%                                      goes above this value the
%                                      optimization will exit and the
%                                      solution will not have convereged.
%                                      This is an optional parameter.
%                                      Default is 10
%
%    settingsStruc.alphaMin:           This is the minimum allowable alpha
%                                      value. Once alpha gets below this
%                                      value the training will exit. This
%                                      is an optional parameter. Default is
%                                      0.01
%
%    settingsStruc.type:               This is the training type for the
%                                      Neural Network. The user can specify
%                                      either 'b' for classification or 'r'
%                                      for regression. This will change the
%                                      way that the error evaluation is
%                                      evaluated
%
%    settingsStruc.maxSweepCount:      This is the maximum number of
%                                      that will be trained. An epoch is
%                                      one evaluation of all 3 different
%                                      step sizes. This option is optional
%                                      and the default is 30.
clc;clear all;close all;
%%% ADD FILE PATSH 

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% USER SET OPTIONS  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
AddPaths
dataChoices = [6, 12,18,24]; % possible time frames
dataSet = 6;


caseInfo.hiddenLayers      = 2;
caseInfo.Nodes             = [5 1];
caseInfo.inputs            = 2470;
caseInfo.momentumParam     = 0.02;
caseInfo.alphaAdjust       = 0.5;
caseInfo.alphaMin          = 0.01;
caseInfo.alphaMax          = 10;
caseInfo.f                 = @sigmoid;
caseInfo.fprime            = @dsigmoid;
caseInfo.alpha             = .6;
caseInfo.maxSweepCount     = 30;
caseInfo.type              = 'r';




%%% END USER OPTIONS %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%



%LOAD DATA, GET CORRECT DATA SET
load('All_Train_Test.mat');
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
dataX = dataX(dataY(:) >= 0.1 ,:);
dataY = (dataY(dataY(:) >= 0.1 ))';

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

%normalize data to be between 0 and 1
dataY = (dataY-minY)/(maxY-minY);
testY = (testY-minY)/(maxY-minY);

%change variable names
dsetX = dataX;
dsetY = dataY;
tsetX = testX;
tsetY = testY;
    
% set  info Range
caseInfo.InfoRange = length(dataX/2);
caseInfo.maxSweepCount = 50;
    
fprintf(['----------------------------------------------------------\n',...
         '              Begining NN classification                  \n',...
         '----------------------------------------------------------\n']);
     
[W, b,W_best,b_best,last_best, errorValues, epochCount] =...
                                   ANNTrain(dsetX,dsetY,tsetX,tsetY,caseInfo);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% VALIDATION ERROR %%%
%%%%%%%%%%%%%%%%%%%%%%%%
[errorRate, dataX_wrong,dataY_wrong] = getErrorRate(tsetX,tsetY,W,b,caseInfo.f,caseInfo.type);
validationError = errorRate;

%%%%%%%%%%%%%%%%%%%%%%
%%% TRAINING ERROR %%%
%%%%%%%%%%%%%%%%%%%%%%
[errorRate, dataX_wrongTrain, dataY_wrongTrain] = getErrorRate(dsetX,dsetY,W,b,caseInfo.f,caseInfo.type);
trainError = errorRate;
%%%%%%%%%%%%%%%%%%%%%%
%%% TEST SET ERROR %%%
%%%%%%%%%%%%%%%%%%%%%%
[errorRate, dataX_wrongTest, dataY_wrongTest] = ...
            getErrorRate(testX,testY,W,b,caseInfo.f,caseInfo.type);




%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PRINT FINAL UPDATE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(['\n----\nFinished final results on training set.',...
         ' Training error rate = %f\n',...
         ],trainError);
fprintf('----\nTest set error rate: %.04f\n',errorRate);
fprintf('------\n');
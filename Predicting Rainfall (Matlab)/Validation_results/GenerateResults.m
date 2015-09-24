% FILE: GenerateResults.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
% This file contains code for creating plots and performing analysis on the
% completed Neural Networks that have been trained. Some of these scripts
% are slightly different which demonstrates the progression of our training
% algorithm and the varying output types that were created throughout this
% project. There are also separate sections for boolean and regression
% analysis.
%
% Several different analysis scripts are contained within this file. They
% can be run by running the individual cell. For most you will be prompted
% to choose the data file you wish to run the analysis on. This code relies
% on the user to understand which data mataches for the given analysis
% which will be performed.
%
%% Validation results Regression
% PLOT THE AVERAGE VALIDATION SCRORES FOR THE 10-FOLD CROSS VALIDATION
% SELECT A CASE FILE THAT IS THE LAST VALIDATION RUN OF THE LAST CASE.
% This does not take into account the varying complexity of the algorith
% and is simply in terms of the case number.
%
% This can be done for either classification or boolean problems
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);


tsetLength = 2918;
caseNumbers = 1:10;
caseValues = zeros(1,10);
for i = 1:10,
    caseValues(i) = sum(validationError(i,:))/(10); 
end

semilogy(caseNumbers,caseValues)
xlabel('Case Number');
ylabel('Average Validation Error');


%% THIS WILL RUN THE RESTULTS ON DATA (TEST SET DATA is years 21-23 throughout)
%%% OUR TEST SET YEARS 21-23. Boolean
% This is a 3 cell analysis. load W,b's for this cell, choose data in the
% 2nd and then in the 3rd perform the analysis.
clc
AddPaths
load('All_Train_Test.mat');




%% Choose data type between a classification problem and a regression problem. (next cell)
%%%Boolean
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);
dataX = x6train;
dataY = y6train;


dataY(dataY(:) >=0.1) = 1;
dataY(dataY(:) < 0.1) = 0;


tX = x6test;
tY = y6test;
tY(tY(:) >=0.1) = 1;
tY(tY(:) < 0.1) = 0;


[errorRate, ~ , wrongY] = getErrorRate(dataX,dataY,W_best,b_best,@sigmoid,'b');
precipWrongTr = sum(wrongY(:) == 1);
nonprecipWrongTr = sum(wrongY(:) == 0);

[errorRateTest, ~, wrongY]  = getErrorRate(tX, tY, W_best, b_best, @sigmoid, 'b');
precipWrongT = sum(wrongY(:) == 1);
nonprecipWrongT = sum(wrongY(:) == 0);


fprintf('Error Rate for training values: %0.04f\n',errorRate);
fprintf('Precipitation events miss classified: %d out of %d\n',precipWrongTr,sum(dataY(:) == 1));
fprintf('Non precipitation events miss classified: %d out of %d\n',nonprecipWrongTr,sum(dataY(:) == 0));

fprintf('Error Rate for test values: %0.04f\n',errorRateTest);
fprintf('Precipitation events miss classified: %d out of %d\n',precipWrongT,sum(tY(:) == 1));
fprintf('Non precipitation events miss classified: %d out of %d\n',nonprecipWrongT,sum(tY(:) == 0));


%% Regression problem data analysis
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);
dataX = x6train;
dataY = y6train;
tX = x6test;
tY = y6test;


dataX = dataX(dataY(:) >= 0.1,:);
dataY = dataY(dataY(:) >=0.1);



tX =  tX(tY(:) >= 0.1,:);
tY = tY(tY(:) >=0.1);

maxY1 = max(dataY);
maxY2 = max(tY);
minY1 = min(dataY);
minY2 = min(tY);
minY = min([minY1, minY2]);
maxY = max([maxY1, maxY2]);
dataY = (dataY-minY)/(maxY-minY);
tY = (tY-minY)/(maxY-minY);


[errorRate, ~ , ~,predictionsTrain] = getErrorRate(dataX,dataY,W,b,@sigmoid,'r');
[errorRateTest, ~, ~,predictionsTest]  = getErrorRate(tX, tY, W, b, @sigmoid, 'r');
fprintf('Error Rate for training values: %0.04f\n',errorRate);
fprintf('Error Rate for test values: %0.04f\n',errorRateTest);

%% RUN THE DATA ON THE TRAINING SET YEARS 1-20 %%
%%% CLASSIFICATION
clc
AddPaths
load('All_Train_Test.mat');
dataX = x6train;
dataY = y6train;

[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);

%load('./resultsBool/output_Boolean_case1_val10.mat')

dataX = dataX(dataY(:) >= 0 ,:);
dataY = dataY(dataY(:) >= 0 );
%set to boolean
dataY(dataY(:) >= 0.1) = 1;
dataY(dataY(:) < 0.1) = 0;

[errorRate, dataX_wrong, dataY_wrong] = getErrorRate(dataX,dataY,W,b,@sigmoid,'b');
fprintf('Error Rate for values: %0.02f\n',errorRate/examples);


%% RUN THE RESULT ON BOTH TEST AND TRAIN SETS %%
%%% CLASSIFICATION
clc
AddPaths
load('All_Train_Test.mat');


%%% CHANGE THIS TO DO A DIFFERENT TIME FRAME %%%
trainX = x6train;
trainY = y6train;

[FileName,PathName,FilterIndex] = uigetfile();
load([PathName,FileName]);
[dataX,dataY] = pickYears(trainX,trainY,1,20);
dataX = dataX(dataY(:) >= 0 ,:);
dataY = dataY(dataY(:) >= 0 );
dataY(dataY(:) >= 0.1) = 1;
dataY(dataY(:) < 0.1) = 0;
[tX,tY] = pickYears(trainX,trainY,21,23);
tY(tY(:) >= 0.1) = 1;
tY(tY(:) < 0.1 ) = 0;

%set to boolean
dataY(dataY(:) >= 0.1) = 1;
dataY(dataY(:) < 0.1) = 0;
[errorRate, dataX_wrong, dataY_wrong] = getErrorRate(dataX,dataY,W,b,@sigmoid,'b');
[errorRateTest,dataX_wrongTest,dataY_wrongTest] = getErrorRate(tX,tY,W,b,@sigmoid,'b');
fprintf('Error Rate for training values: %0.04f\n',errorRate);
fprintf('Error Rate for test values: %0.04f\n',errorRateTest);



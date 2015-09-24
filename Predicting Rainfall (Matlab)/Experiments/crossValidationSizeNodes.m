% FILE: crossValidationSizeNodes.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
%
% This script is used to run cross validation on our data sets. The
% different network parameters are set in structure called AllCases that
% is created in loadCases.m and called in the script. This will run the
% boolean/classification case first where we simply try to predict if there
% will be a precipitation event. Then it will run crossvalidation on the
% same network cases but with regression data of only examples where it did
% precip.
%
%
clear all; close all; clc
AddPaths
load('All_Train_Test.mat');
%% USER CHOICES





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    USER MUST SET THE FOLLOWING CHOICES FOR THE SCRIPT    %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%PATH TO PARENT FOLDER %%%
pathFolder = './results/';
dataChoices = [6, 12,18,24]; % possible time frames
dataSet = 6;
k = 10;
%%% To run boolean training
runBoolean = true;
%%% To run regression training
runRegression = true;
%%%%%%%%%%%%%%%%%%%%%%
%%% LOAD CASE FILE %%%
%%%%%%%%%%%%%%%%%%%%%%
loadCases3;


%% PATH VALIDATION

% this code will make sure that all the saving paths exist, if they do not
% exist then the path will be made.
value = exist(pathFolder,'dir');
if( value == 0),
    mkdir(pathFolder);
    innerPath = sprintf('%sresults_%dhr/',pathFolder,dataSet); 
    mkdir(innerPath);
    mkdir([innerPath,'resultsBool']);
    mkdir([innerPath,'results']);  
else
    innerPath = sprintf('%sresults_%dhr/',pathFolder,dataSet); 
    value = exist(innerPath,'dir');
    if( value == 0),
        mkdir(innerPath);
        mkdir([innerPath,'resultsBool']);
        mkdir([innerPath,'results']);  
    else
        if( exist([innerPath,'resultsBool'],'dir') == 0),
            mkdir([innerPath,'resultsBool']);
        end
        if( exist([innerPath,'results'],'dir') == 0)
            mkdir([innerPath,'results']);
        end          
    end
end

if( dataSet == 6),
   pathFolder = [pathFolder,'results_6hr/']; 
elseif( dataSet == 12),
   pathFolder = [pathFolder,'results_12hr/'];  
elseif( dataSet == 18),
   pathFolder = [pathFolder,'results_18hr/'];  
elseif( dataSet == 24),
   pathFolder = [pathFolder,'results_24hr/'];  
end


%% LOAD FOR BOOLEAN DATA
if( runBoolean == true ),
    addpath('../');
    %AllCases = 0;

    

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

    %% Cross Validations for boolean

    diary([pathFolder,'resultsBool/output.txt']);
    diary on

   % k = 1;
    subsetSize = floor(examples/k);
    caseNum = length(fieldnames(AllCases));
    validationError = zeros(caseNum,k);
    trainError = zeros(caseNum,k);
    testSetError = zeros(caseNum,k);
    for j = 1:1:caseNum,
        caseStr = sprintf('case%d',j);
        fprintf(['\n\n\n---------------------------------------------\n',...
        '----------------------' ,...
        '-----------------------\n Begining Boolean Cross Validation on case ',...
        '%d\n---------------------------------------------\n-------------',...
        '--------------------------------\n'],j);

        %%%%%%%%%%%%%%%%%%%%%
        %%% SET CASE INFO %%%
        %%%%%%%%%%%%%%%%%%%%%

        caseInfo = AllCases.(caseStr);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% GET VALIDATION DATA %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i = 1:k,
            if( k == 1),
                dsetX = dataX;
                dsetY = dataY;
                tsetX = testX;
                tsetY = testY;
            else
                tsetX = dataX(subsetSize*(i-1)+1:subsetSize*i,:);
                tsetY = dataY(subsetSize*(i-1)+1:subsetSize*i,:);
                dsetX = [dataX(1:(i-1)*subsetSize,:); ...
                                         dataX(subsetSize*i+1:subsetSize*k,:)];
                dsetY = [dataY(1:(i-1)*subsetSize,:);...
                                         dataY(subsetSize*i+1:subsetSize*k,:)];
            end

            % SET TYPE
            caseInfo.type = 'b';
            caseInfo.InfoRange = length(dsetX)/2;


            %%%%%%%%%%%%%%%%%%%%
            %%% RUN TRAINING %%%
            %%%%%%%%%%%%%%%%%%%%
            [W, b,W_best,b_best,last_best, errorValues, epochCount] =...
                                   ANNTrain(dsetX,dsetY,tsetX,tsetY, caseInfo);



            %%%%%%%%%%%%%%%%%%%%%%%%
            %%% VALIDATION ERROR %%%
            %%%%%%%%%%%%%%%%%%%%%%%%
            [errorRate, dataX_wrong,dataY_wrong] = getErrorRate(tsetX,tsetY,W,b,caseInfo.f,caseInfo.type);
            validationError(j,i) = errorRate;
            precipEventsMisClassified = sum(dataY_wrong(:) == 1);
            nonPrecipMisClassified = sum(dataY_wrong(:) == 0);
            %%%%%%%%%%%%%%%%%%%%%%
            %%% TRAINING ERROR %%%
            %%%%%%%%%%%%%%%%%%%%%%
            [errorRate, dataX_wrongTrain, dataY_wrongTrain] = getErrorRate(dsetX,dsetY,W,b,caseInfo.f,caseInfo.type);
            trainError(j,i) = errorRate;
            precipEventsMisClassifiedTrain = sum(dataY_wrongTrain(:) == 1);
            nonPrecipMisClassifiedTrain = sum(dataY_wrongTrain(:) == 0);
            %%%%%%%%%%%%%%%%%%%%%%
            %%% TEST SET ERROR %%%
            %%%%%%%%%%%%%%%%%%%%%%
            testSetError(j,i) = 0;
            [errorRate, dataX_wrongTest, dataY_wrongTest] = ...
                        getErrorRate(testX,testY,W,b,caseInfo.f,caseInfo.type);
            testSetError(j,i) = errorRate;

            %%%%%%%%%%%%%%%%%%%
            %%%% SAVE DATA %%%%
            %%%%%%%%%%%%%%%%%%%
            pathBool= sprintf([pathFolder,'resultsBool/output_Boolean_case%d_val%d'],j,i);
            save(pathBool,'W','b','W_best','b_best','last_best',...
                     'errorValues','testSetError','validationError', ...
                     'trainError', 'epochCount','caseInfo');

            %%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% PRINT FINAL UPDATE %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%
            fprintf(['\n----\nFinished cross validation set, %d, for case,',...
                     '%d. Validation Error: %f\n-----\n'],i,j,...
                                                         validationError(j,i));
            fprintf(['\n----\nTrain set Precip events missclassified: %d out'...
                     'of %d\n'],precipEventsMisClassifiedTrain,...
                                                           sum(dsetY(:) == 1));
            fprintf(['\n----\nTrain set non-Precip events missclassified:',...
                     '%d out of %d\n'],nonPrecipMisClassifiedTrain,...
                                                           sum(dsetY(:) == 0));
            fprintf(['\n----\nValidation set Precipitation',...
                     'Events missclassified: %d out of %d'],...
                                  precipEventsMisClassified, sum(tsetY(:)==1));
            fprintf(['\n----\nValidation setNon-Precip events missclassified:',...
                     '%d out of %d'],nonPrecipMisClassified, sum(tsetY(:)==0));
            fprintf(['\n----\nFinished final results on training set for',...
                     'case %d, validation set, %d. Training error rate = %f',...
                     ],j,i,trainError(j,i));
            fprintf('----\nTest set error rate: %.04f\n',errorRate);
            fprintf('----\nTest set precip events missclassified %d out of %d\n',...
                              sum(dataY_wrongTest(:) == 1),sum(testY(:) == 1));
            fprintf(['----\nTest set non-precip events missclassified %d out',...
                   'of %d\n'],sum(dataY_wrongTest(:) == 0),sum(testY(:) == 0));
            fprintf('------\n');
            clear W b errorValues epochCount
        end

    end
    pathBool = sprintf([pathFolder,'resultsBool/finalResults']);
    save(pathBool,'testSetError','validationError','trainError');
    diary off
end

if( runRegression == true ),
    %% CHANGE TO REGRESSION DATA %%
    clc;
    clear dataX dataY testX testY
    %[dataX,dataY] = pickYears(trainX,trainY,1,20);
    % dataX = x6train;
    % dataY = y6train;
    % testX = x6test;
    % testY = y6test;
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
%normalize the data to be between 0 and 1
    dataY = (dataY-minY)/(maxY-minY);
    testY = (testY-minY)/(maxY-minY);
    examples = length(dataY);


    save([pathFolder,'results/RandomizedData'],'dataX','dataY');


    %% Cross Validations

    diary([pathFolder,'results/output.txt']);
    diary on
    subsetSize = floor(examples/k);

    caseNum = length(fieldnames(AllCases));
    validationError = zeros(caseNum,k);
    trainError = zeros(caseNum,k);
    testSetError = zeros(caseNum,k);
    for j = 1:caseNum,
        caseStr = sprintf('case%d',j);
        fprintf(['\n\n\n------------------------------------------------\n ',...
        '-----------------------------------------------\n Begining Regression',...
        ' Cross Validation on case %d\n-----------------------------------------',...
        '------\n-----------------------------------------------\n'],j);

        %%%%%%%%%%%%%%%%%%%%%
        %%% SET CASE INFO %%%
        %%%%%%%%%%%%%%%%%%%%%

        caseInfo = AllCases.(caseStr);
        if( k == 1)
            caseInfo.maxThresholdCount = length(dataY); 
        else
            caseInfo.maxThresholdCount  = subsetSize*(k-1); % every datapoint;
        end

        caseInfo.type = 'r';
        caseInfo.InfoRange = length(dataY);

        %%% GET SUBSET OF DATA FOR CROSS VALIDATION %%%
        for i = 1:k,
            if( k == 1),
                dsetX = dataX;
                dsetY = dataY;
                tsetX = testX;
                tsetY = testY;
            else
                tsetX = dataX(subsetSize*(i-1)+1:subsetSize*i,:);
                tsetY = dataY(subsetSize*(i-1)+1:subsetSize*i,:);
                dsetX = [dataX(1:(i-1)*subsetSize,:);...
                                         dataX(subsetSize*i+1:subsetSize*k,:)];
                dsetY = [dataY(1:(i-1)*subsetSize,:);...
                                         dataY(subsetSize*i+1:subsetSize*k,:)];
            end

            %%%%%%%%%%%%%%%%%%%%%
            %%% TRAIN NETWORK %%%
            %%%%%%%%%%%%%%%%%%%%%
            [W, b,W_best,b_best,last_best, errorValues, epochCount ] = ...
                                    ANNTrain(dsetX,dsetY,tsetX,tsetY,caseInfo);


            %%%%%%%%%%%%%%%%%%%%%%%%
            %%% VALIDATION ERROR %%%
            %%%%%%%%%%%%%%%%%%%%%%%%
            validationError(j,i) = 0;
            for q=1:length(tsetY),
                testPoint = tsetX(q,:);
                y_pred = ANNGeneric(testPoint,W,b,caseInfo.f);
                validationError(j,i) = validationError(j,i) + ...
                                                          (tsetY(q)-y_pred)^2;
            end
            validationError(j,i) = validationError(j,i)/length(tsetY);


            %%%%%%%%%%%%%%%%%%%
            %%% TRAIN ERROR %%%
            %%%%%%%%%%%%%%%%%%%

            trainError(j,i) = 0;
            for q=1:length(dsetY),
               testPoint = dsetX(q,:);
               y_pred = ANNGeneric(testPoint,W,b,caseInfo.f);
               trainError(j,i) = trainError(j,i) + (y_pred-dsetY(q))^2;
            end
            trainError(j,i) = trainError(j,i)/length(dsetY);

            %%%%%%%%%%%%%%%%%%%%%%
            %%% TEST SET ERROR %%%
            %%%%%%%%%%%%%%%%%%%%%%

            testSetError(j,i) = 0;
            [errorRate, ~, ~] = ...
                        getErrorRate(testX,testY,W,b,caseInfo.f,caseInfo.type);
            testSetError(j,i) = errorRate;

            %%%%%%%%%%%%%%%%%
            %%% SAVE DATA %%%
            %%%%%%%%%%%%%%%%%
            pathFolderSave= sprintf('%soutput_case%d_val%d',pathFolder,j,i);
            save(pathFolderSave,'W','b','W_best','b_best','last_best',...
                     'errorValues','testSetError',...
                     'validationError', 'trainError','epochCount');
            fprintf(['\n----\nFinished cross validation set, %d, for case,',...
                '%d. Validation Error: %f\n-----\n'],i,j,validationError(j,i));
            fprintf('\n----\nTraining set error: %f\n----\n',trainError(j,i));
            clear W b errorValues epochCount
        end

    end
    pathFolderSave = sprintf('%sfinalResults',pathFolder);
    save(pathFolderSave,'testSetError','validationError','trainError');
    diary off
end
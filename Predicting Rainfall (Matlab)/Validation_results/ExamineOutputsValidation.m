% FILE: ExamineOutputsValidation.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
% This script contains a series of cells that can be evaluated separately.
% they are designed to do the analysis on the results that have been output
% by the cross validation script. This will allow us to plot the plots
% generated for the poster and final. These are specific to the loadCases
% file used. 

AddPaths


%% This Cell will plot the 10-Fold cross validation across the 9 different
%  network structures used in loadCases.m 


%prompt use for file
%
% The user should select the last validation file save. i.e. case 9
% validation set 10.
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);


sumVal = zeros(10,1);
for i = 1:9,
    sumVal(i) = sum(validationError(i,:))/9;
end


values = ...
[2 5  sumVal(1);
 2 10 sumVal(2);
 2 20 sumVal(3);
 3 5  sumVal(4);
 3 10 sumVal(5);
 3 20 sumVal(6);
 4 5 sumVal(7);
 4 10 sumVal(8);
 4 20 sumVal(9)];


plot3(values(1:3,1),values(1:3,2),values(1:3,3),'-r');
hold on;
plot3(values(4:6,1),values(4:6,2),values(4:6,3),'-b');
plot3(values(7:9,1),values(7:9,2),values(7:9,3),'-k');
plot3(values([1,4,7],1),values([1,4,7],2),values([1,4,7],3),'-.r');
plot3(values([2,5,8],1),values([2,5,8],2),values([2,5,8],3),'-.b');
plot3(values([3,6,9],1),values([3,6,9],2),values([3,6,9],3),'-.k');
%scatter3(4,10,sumVal(10,1))
scatter3(values(:,1),values(:,2),values(:,3));
hold off;
grid on
xlabel('Number of Hidden Layers','FontSize',16);
ylabel('Number of Nodes per Hidden Layer','FontSize',16);
zlabel('Average Validation Score','FontSize',16);
legend('2 Hidden Layers','3 Hidden Layers','4 Hidden Layers','5 Nodes per Layer','10 Nodes per Layer','20 Nodes per Layer');
set(gca,'FontSize',16)

%% THIS WILL PLOT THE ErrorValues on the file that you choose. These
% are the training set error and test set error as a function of
% epoch for a given training (set prompted by user to be loaded).
% This value, errorValues is saved by the crossValidaiton file.

% prompt use for information
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);


plot(errorValues(1:end-1,1),errorValues(1:end-1,2),errorValues(1:end-1,1),...
                                   errorValues(1:end-1,3),'LineWidth',1.5);
set(gca,'FontSize',16)
xlabel('Epoch Number','FontSize',16);
ylabel('Average Sum Squared Error','FontSize',16);
legend('Training Set','Validation Set');


%% This cell will allow you to choose a given result and test it on the
%%% actual training set. it will use the W_best and b_best in the set.
%
% These are assuming that you use the output saved by the cross validation
% file.

%prompt use for the information 
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);
load('All_Train_Test.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% USER MUST CHANGE THESE FOR DIFFFERENT TIME FRAME CHOICE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataX = x6train;
dataY = y6train;
tX = x6test;
tY = y6test;

dataY(dataY(:) >=0.1) = 1;
dataY(dataY(:) < 0.1) = 0;



tY(tY(:) >=0.1) = 1;
tY(tY(:) < 0.1) = 0;


for i = 1:length(Y),
    y_pred = ANNGeneric(X(i,:),W_best,b_best,@sigmoid);
    fprintf('predicted %f, actual %f \n',y_pred, Y(i));
end

%% For LoadCases3 data This will plot the errors as a function of nodes
% in the hidden layer

%load the last case. this is expected to be the last case that was run.
% i.e case 10, validation 10
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);


sumVal = zeros(10,1);
for i = 1:10,
    sumVal(i,1) = sum(validationError(i,:))/size(validationError,2);
    sumVal(i,2) = sum(trainError(i,:))/size(trainError,2);
end
%sumVal/2922;
%scatter(1:10,sumVal)

values = ...
[ 2  sumVal(2,:);
  3  sumVal(3,:);
  4  sumVal(4,:);
  5  sumVal(5,:);
  6  sumVal(6,:);
  7  sumVal(7,:);
  8  sumVal(8,:);
  9  sumVal(9,:);
  10 sumVal(10,:)
];


plot(values(:,1),values(:,2),values(:,1),values(:,3),'LineWidth',1.5);
set(gca,'FontSize',16)
%scatter3(4,10,sumVal(10,1))
xlabel('Number of Nodes','FontSize',16);
ylabel('Average Error','FontSize',16);
legend('Average Validation Score','Training Error')


%% on the old format with the output of the errors being called
% trainSetErrors
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);

plot(testSetErrors(1:end-1,1),testSetErrors(1:end-1,2),...
        testSetErrors(1:end-1,1),testSetErrors(1:end-1,3),'LineWidth',1.5);
set(gca,'FontSize',16)
xlabel('Epoch Number','FontSize',16);
ylabel('Average Sum Squared Error','FontSize',16);
legend('Training Set','Validation Set');



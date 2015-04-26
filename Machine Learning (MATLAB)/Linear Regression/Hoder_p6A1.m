% FILE: q5a.m
% AUTHOR: Chris Hoder
% COSC 74
% 1/30/2013

close all; clear all;
type = 'l';
load('autompg.mat')
dataSetX = trainsetX;
dataSetY = trainsetY;
y = trainsetY;
taus = [10^2, 10^3, 10^5, 10^6];

% cross validation

%number of folds
k = 10;


%generate a random permutation of the indices for the data
[m, n] = size(dataSetX);
indx = randperm(m)';
subsetSize = floor(m/k);
remainder = mod(m,k);

avgErrorTest = zeros(size(taus,2),1);
avgErrorTrain = zeros(size(taus,2),1);
% For each value
for j = 1:size(taus,2),
    clear error
    errorTest = zeros(k,1);
    tau = taus(j);
    %for each set generate the training and test sets based on the number of
    %folds givne in k
    for i=1:k,
        tSetX = dataSetX(indx(subsetSize*(i-1)+1:subsetSize*i),:);
        tSetY = dataSetY(indx(subsetSize*(i-1)+1:subsetSize*i));
        %add in the remainder row if needed
        if(i <= remainder && remainder ~= 0),
            tSetX = [tSetX ; dataSetX(k*subsetSize+i,:)];
            tSetY = [tSety ; dataSetY(k*subsetSize+i,:)];
        end
        %data before validation set
        dSettemp1 = dataSetX(indx(1:(i-1)*subsetSize),:);
        dSettempY1 = dataSetY(indx(1:(i-1)*subsetSize));
        %data after validation set (includes first part of remainder
        dSettemp2 = dataSetX(indx((subsetSize*i)+1:subsetSize*k),:);
        dSettempY2 = dataSetY(indx((subsetSize*i)+1:subsetSize*k));
        % we have remainder data to add
        if( i < remainder),
            %remainderdata
            dSettemp3 = dataSetX(indx(subsetSize*k+1 :subsetSize*k+(i-1)),:);
            dSettempY3 =dataSetY(indx(subsetSize*k+1: subsetSize*k+(i-1)),:);
            dSettemp4 = dataSetX(indx(subsetSize*k+i+1:end),:);
            dSettempY4 = dataSetY(indx(subsetSize*k+i+1:end));
            dSetX = [dSettemp1; dSettemp2; dSettemp3; dSettemp4];
            dSetY = [dSettempY1; dSettempY2; dSettempY3; dSettempY4];
        else
            dSetX = [dSettemp1; dSettemp2];
            dSetY = [dSettempY1; dSettempY2];
        end
        errorTrain(i) = LWLRValidation(dSetX,dSetY,dSetX,dSetY,tau);
        %get thetas
        errorTest(i) = LWLRValidation(dSetX,dSetY,tSetX,tSetY,tau);
    end
    avgErrorTest(j) = sum(errorTest)/k;
    avgErrorTrain(j) = sum(errorTrain)/k;
end

semilogx(taus,avgErrorTest,taus, avgErrorTrain)
legend('Test','train')
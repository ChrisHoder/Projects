% FILE: q5e.m
% AUTHOR: Chris Hoder
% COSC 74
% 1/30/2013

% (e) [4 points] Now, plot the test set mean squared error for the same
% set of values of ?. Is the cross-validation score a good 
% predictor of performance on the test set?


close all; clear all;

load('autompg.mat')
dataSetX = trainsetX;
dataSetY = trainsetY;
y = trainsetY;
lambdas = [10^-5 10^-3 10^-1 10 10^3 10^5 10^7];

% cross validation

%number of folds
k = 10;

% method you are choosing to run
types = ['l','q'];


for q = 1:2,
    type = types(q);
    %generate a random permutation of the indices for the data
    [m, n] = size(dataSetX);
    indx = randperm(m)';
    subsetSize = floor(m/k);
    remainder = mod(m,k);

    %avgErrorTest = zeros(size(lambdas,2),1);
    averageTestSet = zeros(size(lambdas,2),1);
    avgErrorValidation = zeros(size(lambdas,2),1);
    
    % For each value of lambda we run the cross-validation
    for j = 1:size(lambdas,2),
        clear error
        errorTest = zeros(k,1);
        lambda = lambdas(j);
        %for each set generate the training and test sets based on the number
        %of folds givne in k
        errorValidation = zeros(k,1);
        errorTestSet = zeros(k,1); 
        
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
                % remainderdata before the test set remainder value
                dSettemp3=dataSetX(indx(subsetSize*k+1 :subsetSize*k+(i-1)),:);
                dSettempY3=dataSetY(indx(subsetSize*k+1: subsetSize*k+(i-1)),:);
                % any values after the test set remainder value
                dSettemp4 = dataSetX(indx(subsetSize*k+i+1:end),:);
                dSettempY4 = dataSetY(indx(subsetSize*k+i+1:end));
                dSetX = [dSettemp1; dSettemp2; dSettemp3; dSettemp4];
                dSetY = [dSettempY1; dSettempY2; dSettempY3; dSettempY4];
            %we do not need to worry about remainders and can simply add
            %them together.
            else
                dSetX = [dSettemp1; dSettemp2];
                dSetY = [dSettempY1; dSettempY2];
            end

            %get theta
            theta = regularizeRegression(dSetX,dSetY,lambda,type);
            %calculate the error on the validation set, training set, and the
            %test set provided
            errorValidation(i) = errorEval(theta,tSetX,tSetY,type);
            %errorTrain(i) = errorEval(theta,dSetX,dSetY,type);
            errorTestSet(i) = errorEval(theta,testsetX,testsetY,type);
        end
        % Calculate the average error for each lambda on the validation set,
        % training set and the test set provided.
        averageTestSet(j) = sum(errorTestSet)/k;
        avgErrorValidation(j) = sum(errorValidation)/k;
        %avgErrorTrain(j) = sum(errorTrain)/k;
    end%

    subplot(2,1,q);
    %plot the data
    semilogx(lambdas,avgErrorValidation, lambdas, averageTestSet)
    %semilogx(lambdas,avgErrorValidation);
    legend('Validation','test')
    %legend('Validation');
    xlabel('Lambda');
    ylabel('Error');
    
    if (type == 'l'),
        title('b^l(x)');
    else
        title('b^q(x)');
    end
end
% FILE: classify_kNN.m
% AUTHORS: Chris Hoder
% DATE: 3/5/2013
%
% This method will make a prediction on the y value given an x example
% based on the k nearest neighbors model. This will find the k nearest
% neighbors to x in the given training set X. Prediciton will be made by
% majority class vote. This is for a boolean s
function prediction = classify_kNN(x,X,Y,k)
    distances = sum( (X - ones(size(X))*diag(x)).^2,2);
    combinedValues = [distances Y];
    %sort the distances.
    sortedDistances = sortrows(combinedValues,1);
    nhbrs = sortedDistances(1:k,2);

    prediction = mode(nhbrs);
    
%     % make prediction based on majority vote
%     if( sum(nhbrs)/length(nhbrs) >= 0.5 ), 
%         prediction = 1;
%     else
%         prediction = 0;
%     end

end

% FILE: predictDecisionTree.m
% AUTHOR: Chris Hoder
% DATE: 3/5/13
%
% This method will make a prediction of the class for the input feature
% vector x. The method uses a decision tree forest, with the decision trees
% provided in the cell trees. The decision is based on the class having the
% majority vote of the leaves reached in each tree.
function [ Y ] = pDF_vote(trees,x)
    vote = zeros(length(trees),1);
    % for each tree find it's prediction
    for i =1:length(trees),
        [vote(i,1), vote(i,2)] = predictDecisionTree(trees{i},x); 
    end
    %take the majority vote
    sumVote = sum(vote(:,1))/length(trees);
    if( sumVote >= 1/2),
        Y = 1;
    else
        Y = 0;
    end


end
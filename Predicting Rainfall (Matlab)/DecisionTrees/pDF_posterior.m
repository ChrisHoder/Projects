% FILE: predictDecisionTree.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
% This method will make a prediction of the class for the input feature
% vector x. The method uses a decision tree forest, with the decision trees
% provided in the cell trees. The decision is based on the class having the
% largest average posterior of the 11 leaves reached for the input

function [ Y ] = pDF_posterior(trees,x)
    vote = zeros(length(trees),1);
    %for each tree find it's prediciton and posterior
    for i =1:length(trees),
        [vote(i,1), vote(i,2)] = predictDecisionTree(trees{i},x); 
    end
    %average the posterior and the largest one is the class
    avgPosterior = sum(vote(:,2))/length(trees);
    if( avgPosterior >= 1/2),
        Y = 1;
    else
        Y = 0;
    end
end
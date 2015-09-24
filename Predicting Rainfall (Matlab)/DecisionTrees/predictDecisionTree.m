% FILE: predictDecisionTree.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
% This method will make a prediction for y for the given input x using the
% input decision tree. The method will also output the conditional
% probability: p(y=1|x is a leaf).

function [y, prob] = predictDecisionTree(tree,x)
    idx = 1;
    %while we are not at a leaf (ie. s1 > 0)
    while(tree(idx,1) > 0),
        % do the conditional test
        if(x(tree(idx,1)) >= tree(idx,4)),
            % go to left child
           idx = tree(idx,2); 
        else
            % go to right child
           idx = tree(idx,3);
        end
        
    end

    %we have found our leaf, output value and prob
    y = tree(idx,2);
    prob = tree(idx,3);
end
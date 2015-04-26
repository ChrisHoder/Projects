% FILE: GenerateResults.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
% Sigmoid Function
function y = sigmoid(x)
    y = (1+exp(-x)).^-1;
end
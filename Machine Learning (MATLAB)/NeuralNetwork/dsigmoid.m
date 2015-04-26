% FILE: dsigmoid.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
% Derivative of the sigmoid
function y = dsigmoid(x)
    y = sigmoid(x).*(1-sigmoid(x));
end
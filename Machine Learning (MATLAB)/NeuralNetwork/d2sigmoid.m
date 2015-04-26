% FILE: d2sigmoid.m
% AUTHOR: Chris Hoder and Ben Southworth
% DATE: 3/5/13
% COSC 74
% Final Project
%
% Second derivative function of the sigmoid

function y = d2sigmoid(x)
    %y = dsigmoid(x)-2*sigmoid(x).*dsigmoid(x);
    y = -(exp(x).*(exp(x)-1))./(exp(x)+1).^3;
end
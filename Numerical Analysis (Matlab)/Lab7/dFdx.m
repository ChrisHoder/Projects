% FILE: dFdx.m
% AUTHOR: Chris Hoder
% DATE: 11/2/2012
% CLASS: ENGS 91
% Problem Set 7, Question 1

% This method is the rate function for the ODE provided in the question
function out = dFdx(y,t)
    out = -7*y;
end
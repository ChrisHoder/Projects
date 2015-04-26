% FILE: cubic.m
% AUTHOR: Chris Hoder
% DATE: 9/27/2012
% ENGS 91
% Laboratory 3

%this method takes in the coefficients for a cubic function and returns the
% value at the given point x. 
function out = cubic(a,b,c,d,xj,x)
    out = a + b*(x-xj)+c*(x-xj)^2+d*(x-xj)^3;
end
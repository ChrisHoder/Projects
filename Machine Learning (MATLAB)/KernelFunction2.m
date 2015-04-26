% FILE: KernelFunciton2.m
% AUTHOR: Chris Hoder
% DATE: 2/28/2013
% COSC 74 
% Question 1 k)

% This method implements the Kernel Function for the part k that is of 
% degree 3. 
function out = KernelFunction2(x_i,x_j)
    out = (x_i*x_j')^3;
end
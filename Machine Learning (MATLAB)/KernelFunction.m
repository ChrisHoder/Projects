% FILE: KernelFunciton.m
% AUTHOR: Chris Hoder
% DATE: 2/28/2013
% COSC 74 
% Question 1 i)/j)
%
% This method will implement the kernel function for parts i and j
function out = KernelFunction(x_i,x_j)
    out = x_i*x_j';
end
% FILE: fMatrix.m
% AUTHOR: Chris Hoder
% DATE: 10/8/2012
% CLASS: ENGS 91
% Laboratory 4 Question 1

%this method evaluates the 2 functions needed to solve the system of
%nonlinear equations in question 1. This is the derivative of the error.
%See handwritten work attached with code

function f = fMatrix(a,b),
    %given points
    x = [ 5 13 21 27 38 48 60 72 92];
    y = [44 29 20 14 8   5  3  2  1];
    f(1,1) = 0;
    f(2,1) = 0;
    %must sum over all of the points that we are fitting to
    for i = 1:9,
     f(1,1) = f(1,1) + 2*b*exp(2*a*x(i))-2*y(i)*exp(a*x(i));
     f(2,1) = f(2,1) + 2*b^2*x(i)*exp(2*a*x(i))-2*x(i)*y(i)*b*exp(a*x(i));
    end
    f;
end
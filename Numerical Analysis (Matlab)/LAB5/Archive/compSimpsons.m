% FILE: compSimpsons.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 4

% This calculates the integral of f from a to b using Composite Simpson's
%rule on n subintervals using the formula presented in the book on page 199
function [value points ypoints] = compSimpsons(a,b,f,n)
    %each small step size
    h = (b-a)/n;
    %end point evaluations
    fa = f(a);
    fb = f(b);
    points(1) = a;
    ypoints(1) = fa;
    sum1 = 0;
    sum2 = 0;
    %for all the interval points
    for i = 1:n-1,
        x = a + i*h;
        %save the values
        points(end+1) = x;
        ypoints(end+1) = f(x);
        %even numbers
        if( mod(i,2) == 0),
            sum1 = sum1 + f(x);
        %odd numbers
        else,
            sum2 = sum2 + f(x);
            
        end
    end
    %compute the equation
    value = (h/3)*(fa + 2*sum1 + 4*sum2);
    points(end+1) = b;
    ypoints(end+1) = f(b);
end
% FILE: q1.m
% AUTHOR: Chris Hoder
% DATE: 10/24/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 1

function [x y] = Eulersmethod(a,b,h,yo,f),
    x(1) = a;
    y(1) = yo;
    i = 1;
    while(x(i) < b),
       i = i+1;
       x(i) = x(i-1)+h;
       y(i) = y(i-1) + h*f(x(i-1));
    end
    
end
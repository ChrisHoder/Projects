% FILE: MidpointRule.m
% AUTHOR: Chris Hoder
% DATE: 10/24/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 1

function [x y] = MidPoint(h,a,b,yo,f)
    x(1) = a;
    y(1) = yo;
    i    = 1;
    while( x(i) < b ),
        i = i + 1;
        x(i) = x(i-1)+h;
        y(i) = y(i-1) + h*f(y(i-1) + (h/2)*f(y(i-1),x(i-1)),x(i-1)+(h/2));
    end
    

end
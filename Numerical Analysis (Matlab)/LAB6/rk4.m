% FILE: rk4.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 1


function [t y] = rk4(h,a,b,yo,f),
    t(1) = a;
    y(1) = yo;
    i = 1;
    while ( t(i) < b),
        i = i + 1;
        t(i) = t(i-1) + h;
        f1 = f(y(i-1),t(i-1));
        f2 = f(y(i-1)+(h/2)*f1,t(i-1)+(h/2));
        f3 = f(y(i-1)+(h/2)*f2,t(i-1)+(h/2));
        f4 = f(y(i-1)+h*f3,t(i));
        y(i) = y(i-1) + (h/6)*(f1 + 2*(f2+f3) + f4);
    end
end
% FILE: ModEuler.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 1

function [t y] = ModEuler(h,a,b,yo,f)
    t(1) = a;
    y(1) = yo;
    i = 1;
    while( t(i) < b ),
        i = i + 1;
        t(i) = t(i-1) + h;
        y(i) = y(i-1) + (h/2)*(f(y(i-1),t(i-1)) + f( y(i-1)+h*f(y(i-1),t(i-1)),t(i)));
    end
end
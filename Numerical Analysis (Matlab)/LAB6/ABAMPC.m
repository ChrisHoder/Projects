% FILE: ABAMPC.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 1

function [t y] = ABAMPC(h,a,b,yo,f),
    y(1) = yo;
    t(1) = a;
    i = 1;
    while( t(i) < b ),
       i = i+1;
       t(i) = t(i-1)+h;
       y_temp = y(i-1) + (h/2)*(3*f(y(i-1),t(i-1)) -f(y(i-2),t(i-2)));
       y(i) = y(i-1) + (h/12)*(5*f(y_temp,t(i)) + 8*f(y(i-1),t(i-1)) - ...
                                                        f(y(i-2),t(i-2)));
        
    end

end
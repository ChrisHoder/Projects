% FILE: ABAMPC.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 1

% REUSED FOR LAB 7

% This method computes the solution to an initial value problem ODE using an
% A-B/A-M Predictor Corrector Scheme with a single correction. The inputs 
% to this method
% are the step size h, the initial time a, the final time b, the intial
% value yo, and
% the derivative function f.
function [t y] = ABAMPC(h,a,b,yo,f),
    y(1) = yo;
    t(1) = a;
    %need to take first step using an rk2 method because the multistep
    %method is not self-starting. choose modified Euler's method
    t(2) = a + h;
    %y(2) = y(1) + (h/2)*( f(y(1),t(1)) + f( y(1) + h*f(y(1),t(1)),t(2)));
    y(2) = y(1) + h*f(y(1)+(h/2)*f(y(1),t(1)),t(1)+(h/2));
    i = 2;
    % While we are not at the last time step, continue stepping forward in time
    while( t(i) < b ),
    	%update time
       i = i+1;
       t(i) = t(i-1)+h;
       %predict the y value using an explicit method
       y_temp = y(i-1) + (h/2)*(3*f(y(i-1),t(i-1)) -f(y(i-2),t(i-2)));
       % correct using the implicit methd and take this value 
       y(i) = y(i-1) + (h/12)*(5*f(y_temp,t(i)) + 8*f(y(i-1),t(i-1)) - ...
                                                        f(y(i-2),t(i-2)));
    end

end
% FILE: MidpointRule.m
% AUTHOR: Chris Hoder
% DATE: 10/24/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 1

% REUSED FOR LAB 7

% This method computes the solution to an initial value ODE problem using
% the MidPoint rule. 
% The inputs to the method are the step size h, the initial time a, the 
% final time b
% the initial value yo and the derivativ function f.
function [t y] = MidpointRule(h,a,b,yo,f)
	%set intitial values
    t(1) = a;
    y(1) = yo;
    i    = 1;
    % while we still have more time left, keep moving forward in time
    while( t(i) < b ),
        i = i + 1;
        t(i) = t(i-1)+h;
        %compute the midpoint rule for the next y value
        y(i) = y(i-1) + h*f(y(i-1) + (h/2)*f(y(i-1),t(i-1)),t(i-1)+(h/2));
    end
    

end
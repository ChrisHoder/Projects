% FILE: linLeastSquares.m
% AUTHOR: Chris Hoder
% DATE: 10/5/12
% ENGS 91
% Laboratory 4

% This method will calculate the linear coefficients for a lienar least
% squares approximation to the given points. Here x and y are the inputs
% where y(i) = f(x(i)) and f(x) is the function we are approximating.
function [a0 a1] = linLeastSquare(x,y)
    %find out the number of points
    m = max(size(x));
    %initialize sums
    xiyi = 0;
    xi   = 0;
    yi   = 0;
    xi2  = 0;
    % calculate the x(i)*y(i), x(i), y(i) and x(i)^2 sums
    for i=1:m,
       xiyi = xiyi + x(i)*y(i);
       xi   = xi   + x(i);
       yi   = yi   + y(i);
       xi2  = xi2   + x(i)^2;
    end
    %determine the sum(x(i))^2 value
    xiSquare = xi^2;
    
    %determine the coefficients using the equation solved by hand. This
    %equation can also be found on page 487 of the textbook
    %intercept
    a0 = (xi2*yi - xiyi*xi)/(m*xi2 - xiSquare);
    %slope
    a1 = (m*xiyi - xi*yi)/(m*xi2 - xiSquare);
end

% FILE: AdapQuad.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 2

% This method computes the composite trapezoidal rule for n subintervals.
% The equation can be found in the text on page 200 under Theorem 4.5. The
% method integrates the function f over the interval a,b with n
% subintervals. The output is the value for the integral.
function value = compTrap(a,b,f,n),
    h = (b-a)/n;
    fa = f(a);
    fb = f(b);
    % sum the inner point evalutations
    sum1 = 0;
    for i = 1:n-1;
        sum1 = sum1 + f(a+h*i);
    end
    % compute the integral using composite trapezoidal rule. return this
    % value
    value = (h/2)*(fa + 2*sum1 + fb);
end
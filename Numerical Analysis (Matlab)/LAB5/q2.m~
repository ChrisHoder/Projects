% FILE: q2.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 2

% Apply Romberg integration to the following integrals until R_n-1,n-1 and
% Rn,n agree to within 10^-9. Report the value of n and the number of
% function evaluations. Also, compare the result to that obtained from the
% trapezoidal rule for the same number, n and the number n and number of
% function evaluations you would need to achieve the same level of accuracy
% using just the composite trapezoidal rule. R(n,0), since we cannot index
% off of 0 this is held by the R(n,1) spot.

clc;clear;
%maximum number of iterations
nMax = 20;
%error tolerance
tol = 10^-9;
%function being integrated. 
f = inline('(x^2)*exp(-x)');
%f = inline('x^(1/3)');
%compute the Romberg Integration
[R count] = RombergInt(0,1,f,nMax,tol);
'Number of function evaluations'
count
'Number of iterations (n number)'
max(size(R))
'Integral Value'
vpa(R(end,end))
'Error'
intf = inline('(-x^2-2*x-2)*exp(-x)');
abs(R(end,end) - (intf(1)-intf(0)))
'Using just the composite trapezoidal rule' %#ok<*NOPTS>
vpa(R(end,1)) 

%c = compTrap(0,1,f,2^(max(size(R)))-1)

%%
clc;clear;
%maximum number of iterations
nMax = 30;
%error tolerance
tol = 10^-9;
%function being integrated
% this method has the function hardcoded into it.
[R2 count] = RombergIntb(0,1,nMax,tol);
'Number of function evaluations'
count
'Number of iterations'
max(size(R2))
'Integral Value'
vpa(R2(end,end))
'Error'
abs(R2(end,end) - 0.75)
'Using just the composite trapezoidal rule'
vpa(R2(end,1))
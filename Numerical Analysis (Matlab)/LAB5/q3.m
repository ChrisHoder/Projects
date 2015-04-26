% FILE: q3.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 3

% Approximate teh integrals in problem 2a and 2b using Gaussian Quadrature
% with at least n = 2,3,4 and 5. Report the number of function evaluations
% and compare the results with those obtained using romberg iteration in
% problem 2.


% below x is the vector of {x_i} for evaluating the function at, w is the
% corresponding set of weights. All of these are defined on the interval
% (-1,1). The method gaussQuad will appropriately tranform the locations to
% be between the given (a,b) interval.

clear;clc;

%uncomment the section that you want to perform the Gaussian Quadrature on.
%This script can handle both part a and part b
%part a)
%f = inline('x^2*exp(-x)');
%part b)
f = inline('x^(1/3)');
initial = 0;
final = 1;


n = 1;
x = [0];
w = [2];
intVal(1) = gaussQuad(initial,final,x,w,f);

n = 2;
x = [-1/sqrt(3) 1/sqrt(3)];
w = [ 1 1];
intVal(2) = gaussQuad(initial,final,x,w,f);

n = 3;
x = [- sqrt(3/5) 0 sqrt(3/5)];
w = [ 5/9 8/9 5/9];
intVal(3) = gaussQuad(initial,final,x,w,f);


n = 4;
a = sqrt((3-2*sqrt(6/5))/7);
c = (18+sqrt(30))/36;
b = sqrt((3+2*sqrt(6/5))/7);
d = (18-sqrt(30))/36;
x = [a -a b -b];
w = [c  c d  d];
intVal(4) = gaussQuad(initial,final,x,w,f);


n = 5;
a = (1/21)*sqrt(245-14*sqrt(70));
b = (1/21)*sqrt(245+14*sqrt(70));
c = (1/900)*(322+13*sqrt(70));
d = (1/900)*(322-13*sqrt(70));
x = [0       a -a b -b];
w = [128/225 c  c d  d];
intVal(5) = gaussQuad(initial,final,x,w,f);

vpa(intVal')

vpa(intVal' -0.75)

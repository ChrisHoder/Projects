% FILE: nonlinNewton.m
% AUTHOR: Chris Hoder
% DATE: 11/2/2012
% CLASS: ENGS 91
% Problem Set 7, Question 2


% The deflection of a uniformly loaded, long rectangular beam under an
% exial tension force can be described by the nonlinear boundary value
% problem:
%
%       [1+(y')^2]^(-1.5)*y" = (S/D)y' + (qx)/(2D)*(x-L)y
%
% for 0<x<L and y(0) = y(L)= 0 where y(x) is the deflection alon gthe beam,
% L is the length of the beam, D is the flexual rigidity, S is the axial
% force, and q is the intensity of the uniform load. Solve this problem
% using a nonlinear shooting method assuming L = 50 in, D = 8.8*10^7 lb in,
% S = 100 lb in^-1, and q = 1000 lb in^-2. Use the 4-step
% predictor-corrector method you developed in problem (1) above and base
% your shoooting on either a secant or Newton type of iteration. Report the
% stepsize you use, any initial guesses of initial values you make, and all
% subsequent initial values that your iteration produces until the final
% answer is reached. Plot your final solution for y and y' as a function of
% x for 0<x<50. Verify the error behavior of this method.


clc;clear
% set initial values
interval = [0 50];
initialCond = [0 0];
n = 5000;
m = 100;
tol = 10^-13;
%initial guess
guess = 1.5;
[y yprime x T zEnd] = nonlinNewton(interval,initialCond,@dF2dt,n,m,tol,...
                                                                    guess);
'completed'
%%

%plot the final solution for y and y' as a function of x for 0<x<50
subplot(2,1,1)
plot(x,y);
xlabel('Position on beam (in)');
ylabel('Deflection');
axis([0 50 -2 16]);
subplot(2,1,2)
plot(x,yprime);
xlabel('Position on beam (in)');
ylabel('y'', the derivative of Deflection wrt position');
axis([0 50 -1 1])

%plot the zend value as a function of initial slope
figure
plot(T,zEnd,'-sr');

figure
loglog(zEnd(1:end-1),zEnd(2:end))

figure
loglog(zEnd(1:

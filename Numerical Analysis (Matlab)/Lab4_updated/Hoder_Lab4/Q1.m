% FILE: Q1.m
% AUTHOR: Chris Hoder
% DATE: 10/5/2012
% CLASS: ENGS 91
% Laboratory 4 Question 1


clear
clc
%points given

x = [ 5 13 21 27 38 48 60 72 92];
y = [44 29 20 14 8   5  3  2  1];

% determine the a0 and a1 coefficients for a linear function of the form
% y = a0 + a1*x. We must first perform a change of variables to bet the
% nonlinear function into a linear function form (see attached handwritten
% work). 
[a0 a1] = linLeastSquare(x,log(y));
% convert back into the a,b for the nonlinear case
a0 = exp(a0);
a1 = a1/(-2*pi);
%graph our non-linear approximation
points = linspace(2, 92,1000);
for i = 1:1000,
    values(i) = a0*exp(points(i)*a1*-2*pi);
end

%plot these on the same figure
hold on
scatter(x,y,'sr');
plot(points,values);
hold off
legend('Points provided','Approximation');
xlabel('x');
ylabel('y');

%% This is a test of my nonlinear solution to the best fit. I minimized the
% squares by applying newton's method for a system of nonlinear equations
result = newtonSys3([a1*(-2*pi),a0],10^-40,100)

%plot the values now that we have a,b
for i = 1:1000,
    values2(i) = result(end,2)*exp(points(i)*result(end,1));
end

%compare the two approximations
plot(points, values2,'-r',points,values,'-b')
hold on
scatter(x,y,'sg');
hold off
xlabel('x');
ylabel('y');
legend('Non-linear solution','learized solution','points given');
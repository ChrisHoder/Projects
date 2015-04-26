% FILE: q4.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 4

% Approximate the integrals in 2a and 2b using an Adaptive Quadrature
% scheme. Choosinga  Newton-Cotes formula and a specified tolernace (tol)
% subdivide the interval in such a way as to distribute the error
% uniformly. Display your sampling and demonstrate that your error is
% uniformaly distributed across the interval. Compare your results to the
% error you achieve using uniform sampling.

%% 
clc;clear;

%Chose question part. 1 == part for a, part == 2 for b
part = 1;

%function being integrated
if( part == 1),
    f = inline('x^2*exp(-x)');
else
    f = inline('x^(1/3)');
end
% interval
a = 0;
b = 1;
%the error check
errorCheck = [];
% points used, first we only use a,b
points = [a,b];
tol = 10^-9;
% max number of subdivisions allowed
maxDepth = 100;
depth = 0;
% Compute the adaptive quadrature
[Value points errorCheck] = AdapQuad(a,b,tol,f,points,depth,maxDepth,...
                                                               errorCheck);

%evalutae the function at the points that were used to compute the
%quadrature to be able to display them on the plot
for i=1:max(size(points)),
   y(i) = f(points(i)); 
end

%calculate the function that we integrated
x = 0:.001:1;
for i=1:max(size(x)),
    fEval(i) = f(x(i));
end

%calculate the error over each integration section to show that it is
%uniform. The matrix that is created has the following infomation int it.
% [a b S(a,b) ActualValue Error]. Where a,b are the integration region,
% S(a,b) is simpson's rule over that region, ActualValue is the exact
% integral over that region and Error is the absolute difference between
% these two.
sections = size(errorCheck);
ErrorMatrix = [];
for i=1:sections(1),
   c = errorCheck(i,1);
   d = errorCheck(i,2);
   if( part == 1),
        %for integral a
        intf = inline('(-x^2-2*x-2)*exp(-x)');
   else
        %for integral b
        intf = inline('(3*x^(4/3))/4');
   end
   
   actVal = intf(d)-intf(c);
   errorVal = abs(errorCheck(i,3)-actVal);
   errorPerLength = errorVal/(d-c);
   ErrorMatrix = [ ErrorMatrix; c d errorCheck(i,3) actVal errorVal ...
                                                          errorPerLength ];
   
end

%compute the result with uniform sampling. We will always have 1 more point
%than intervals
[uniformSamp points2 ypoints] = compSimpsons(a,b,f,max(size(points))-1);
'Integral value using Adaptive quadrature' %#ok<*NOPTS>
vpa(Value)
'Integral value using uniform sampling'
uniformSamp
'Actual integral evaluated analytically'
intf(b)-intf(a)
%%compare to using uniform sampling over the interval. This is done by
%%using the composite simpson's rule which is given with the method
%%compSimpsons. 
'Error with adaptive quadrature'
abs(Value - (intf(b)-intf(a)))
'Error with uniform sampling with same number of points'
abs(uniformSamp-(intf(b)-intf(a)))


ErrorMatrix2 = simpsonsRule(f,points2,part);

%plot the function and the points used for the Adaptive quadrature scheme
subplot(1,2,1);
loglog(points,y,'.r');
xlabel('x');
ylabel('y');
title('Points chosen using adaptive quadrature');
%format axis to show the same thing on both plots
if( part==1)
    axis([10^-4 1 10^-5 1]);
else
    axis([10^-20 1 10^-7 1]);
end

subplot(1,2,2)
loglog(points2,ypoints,'.r');
xlabel('x');
ylabel('y');
title('Points chosen using uniform spacing on the interval (0,1)');
% format the axis to show the same thing on both plots
if( part==1)
    axis([10^-4 1 10^-5 1]);
else
    axis([10^-20 1 10^-7 1]);
end

figure
semilogy(ErrorMatrix(:,1),ErrorMatrix(:,6),'r',ErrorMatrix2(:,1),...
                                                    ErrorMatrix2(:,6),'b');
xlabel('x');
ylabel('Absolute Error');
legend('Adaptive Quadrature','Uniform Spaced Simpson''s Rule');
axis([0 1 10^-5 10^-15])

% if( part == 1),
%     h_legend = legend('f(x) = \int_0^1{x^2e^{-x}}','Points Sampled');
% else
%     h_legend = legend('f(x) = \int_0^1{x^{1/3}}','Points Sampled');
% end
% set(h_legend,'FontSize',14);
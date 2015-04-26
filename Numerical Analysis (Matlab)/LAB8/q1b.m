%part b
close all;
clc;clear all;
L = 1;
a = 0;
b = a+L;
n = 1600;
% n = [5,10,20,40,80,160];
h = (b-a)/n;
Tc = 37;
Ts = 32;
Ta = Tc;
lambda = 2.7;
inits = [(Tc-Ta) (Ts-Ta)];
for i=1:1:n,
    x(i) = a+i*h;
    y(i) = (Ts-Tc)*(sinh(lambda*x(i))/sinh(lambda*L));
end

[A,b] = buildTriDiagonal(n,h,x,inline('0'),inline('2.7^2'),...
                                                        inline('0'),inits);
maxIter = 5000;
tol = 10^-8;
T = GaussSeidelSolve(n,A,b,x,y,maxIter,tol);
plot(x,T(:,end),x,y);

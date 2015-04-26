
clc;clear

interval = [0 50];
initialCond = [0 0];
n = 5000;
m = 100;
tol = 10^-9;

a     = interval(1);
b     = interval(2);
alpha = initialCond(1);
beta  = initialCond(2);
h = (b-a)/n;
%slope guesses
z2o = -2:0.01:2;
z1o = interval(2);
zEnd = [];
for i = 1:1:max(size(z2o));
    [z t] = ABAMPC4(0,50,h,[z1o z2o(i) 0 1],@dF2dt,0);
    zEnd(i) = z(end,1);
    clear z
end
plot(z2o,zEnd)
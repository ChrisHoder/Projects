%Test Script
%%
f = inline('sin(x)');
R = RombergInt(0,pi,f,10,10^-9);


%%
clc;clear;
f = inline('x^2*exp(-x)');
a = 0;
b = 1;
points = [a,b];
[Value points] = AdapQuad(a,b,10^-9,f,points,0,10);
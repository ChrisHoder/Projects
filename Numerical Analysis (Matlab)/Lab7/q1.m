% FILE: q1.m
% AUTHOR: Chris Hoder
% DATE: 11/2/2012
% CLASS: ENGS 91
% Problem Set 7, Question 1

%test of midpoint rule stability criteria

%% midpoint method
clc;clear;
figure
%stable step size
h = 1.9/7;
a = 0;
b = a + h*50;
[t y] = MidpointRule(h,a,b,50,@dFdx);
subplot(3,1,1);
plot(t,y);
title('Stable solution with h<2/7. h = 1.9/7');
xlabel('t');
ylabel('y(t)');

%unstable step size
h = 2.1/7;
b = a + h*50;
[t y] = MidpointRule(h,a,b,50,@dFdx);
subplot(3,1,2);
plot(t,y);
xlabel('t');
ylabel('y(t)');
title('Unstable solution with h>2/7. h = 2.1/7');


%stable but not accurate step size
h = 2/7;
b = a + h*50;
[t y] = MidpointRule(h,a,b,50,@dFdx);
subplot(3,1,3);
plot(t,y);
xlabel('t');
ylabel('y(t)');
title('Stable solution with h=2/7 but not accurate');


%% Test with AM / AM PC
clc;clear;
%h = 2.39999990/7;
figure
%stable step size
subplot(3,1,1);
h = 11/35;
a = 0;
b = a + h*50;
[t y ] = ABAMPC(h,a,b,50,@dFdx);
plot(t,y)
xlabel('y');
ylabel('y(t)')
title('Stable solution with h<12/35. h = 11/35');

%unstable step size
subplot(3,1,2);
h = 13/35;
a = 0;
b = a + h*50;
[t y ] = ABAMPC(h,a,b,50,@dFdx);
plot(t,y)
xlabel('y');
ylabel('y(t)')
title('Unstable solution with h>12/35. h = 12/35');

%stable but not accurate
subplot(3,1,3);
h = 12/35;
a = 0;
b = a + h*50;
[t y ] = ABAMPC(h,a,b,50,@dFdx);
plot(t,y)
xlabel('y');
ylabel('y(t)')
title('Stable solution with h=12/35 but not accurate');



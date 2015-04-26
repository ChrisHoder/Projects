% FILE: q4d.m
% AUTHOR: Chris Hoder
% COSC 74
% 1/30/2013

%% Part D
%  plot in a single figure the prior for a=2 and a=10.
close all; clear all
a = [2 10];
z = [1/6 1/923780];
mu = 0:.01:1;
P = zeros(max(size(mu)), 2);
%for the 2 values of a
for j = 1:2,
    for i=1:max(size(mu)),
        %determine the prior for each value of mu
       p(i,j) = (1/z(j))*(mu(i)^(a(j)-1))*(1-mu(i))^(a(j)-1);
    end
end

%plot
plot(mu, p)
legend('a = 2','a = 10');
title('Prior plotted as a function of \mu, p(\mu;a)')
xlabel('\mu');
ylabel('Probability')


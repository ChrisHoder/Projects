% FILE: q4c.m
% AUTHOR: Chris Hoder
% COSC 74
% 1/30/2013

%% Part C
%plot likelihoodfunction
close all; cla;clear;clc; 
M = [1 100 100];
H = [1 100 80 ];
mu = 0:.01:1;
p = zeros(max(size(mu)),3);
%for each trial
for j= 1:3,
    h = H(j);
    m = M(j);
    %for all the values of mu
    for i = 1:max(size(mu)),
     %calculate the likelihood at this mu
     p(i,j) = mu(i)^(h)*(1-mu(i))^(m-h);
    end
    
    %plotting, bottom will span both subplots
    if( j == 3),
        subplot(2,2,3:4);
    else
        subplot(2,2,j);
    end
    plot(mu,p(:,j));
    title(['max is ', num2str(h/m)]);
    xlabel('\mu');
    ylabel('Likelihood');
end

%plot(mu, p)
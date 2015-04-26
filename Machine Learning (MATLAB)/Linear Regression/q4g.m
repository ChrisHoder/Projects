% FILE: q4g.m
% AUTHOR: Chris Hoder
% COSC 74
% 1/30/2013


%% Part G
%  plot the posterior for a = 10, and the same flipping results considered
%  above.
close all; clear all;
a = 10;
z = 1/923780;
mu = 0:.01:1;
M = [1 100 100];
H = [1 100 80 ];
P = zeros(max(size(mu)), 3);
%for the different senarios
for j = 1:3,
    h = H(j);
    m = M(j);
    %for each value of mu find the posterior
    for i = 1:max(size(mu)),
        P(i,j) = (mu(i)^(h)*(1-mu(i))^(m-h))*(1/z)*(mu(i)^(a-1))...
                                                          *(1-mu(i))^(a-1);
    end
    
    %plot data on one figure with subplots
    if( j== 3)
        subplot(2,2,3:4);
    else
        subplot(2,2,j);
    end
    plot(mu,P(:,j));
    xlabel('\mu');
    ylabel('Posterior');
    if( j == 1),
       title('m=1, H=1'); 
    elseif(j == 2),
       title('m=100,H=100');
    else
       title('m=100,H=80');
    end
end
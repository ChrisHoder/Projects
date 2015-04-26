% FILE: q1e.m
% AUTHOR: Chris Hoder
% DATE: 2/28/2013
% COSC 74 
% Question 1 e)
% 
% (e) [1 point] Plot the decision boundary y(x) = w?x + b = 0 as well as
% the margin lines (see illustration in the lecture slides) on top of the 
% scatter plot of the data. Also mark the support vectors in the plot.
%
%
clc;close all; clear all;
warning('off','optim:quadprog:WillRunDiffAlg');
warning('off','all')
load('iris_subset.mat');

%color red (class 1)
trainsetY_1 = trainsetY(trainsetY(:) == 1 );
trainsetX_1 = trainsetX(trainsetY(:) == 1, :);


%color blue (class -1)
trainsetY_2 = trainsetY(trainsetY(:) == -1 );
trainsetX_2 = trainsetX(trainsetY(:) == -1,:);

%plot data
hold on;
scatter(trainsetX_1(:,1),trainsetX_1(:,2),'r');
scatter(trainsetX_2(:,1),trainsetX_2(:,2),'b');
hold off


clc
m = size(trainsetX,1);
n = size(trainsetX,2);

% build H matrix
H = eye(n+1);
H(n,n) = 0;

% build our A matrix
A = zeros(m,n+1);
for i = 1:m,
    A(i,:) = [-trainsetY(i)*trainsetX(i,:) -trainsetY(i)];
end
% build d matrix
d = -ones(m,1);
% build f matrix (unused)
f = [];
%call quadprog
[x, fval, exitflag, output, lambda] = quadprog(H,f,A,d);

%separate out variables
w = x(1:2);
b = x(3);

fprintf('The values for w obtained:\n');
disp(w)

fprintf('\n\n The value for b obtained \n');
disp(b)

%plot decision boundary
x_line = 4:.01:7;
y = (-w(1)*x_line-b)/w(2);
hold on;
plot(x_line,y);
plot(x_line,y+1/w(2),'-.r');
plot(x_line,y-1/w(2),'-.b');
hold off;
xlabel('Sepal Length');
ylabel('Sepal Width');
legend('1','-1','Decision Boundary','Margin 1','Margin -1');


% Plot distances gamma
idx = lambda.ineqlin > 0;
% get support vectors
supportVectorsX = trainsetX(idx,:);
supportVectorsY = trainsetY(idx,:);
for i=1:length(supportVectorsY)
    x_i = supportVectorsX(i,:);
    y_i = supportVectorsY(i,:);
    gamma = (w'*x_i'+b)/norm(w);
    r =(x_i - gamma*w'/norm(w));
    hold on;
    plot([x_i(1) r(1)],[x_i(2), r(2)]);
    hold off;
end
axis square
title(['SVM decision boundary placed on top of scatterplot of data',...
    'The margin lines at +/-1 have also been added.Support vectors are',...
    'identified by the perpendicular lines indicating ther length.']);

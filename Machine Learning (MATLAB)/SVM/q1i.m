% FILE: q1i.m
% AUTHOR: Chris Hoder
% DATE: 2/28/2013
% COSC 74 
% Question 1 i)
% 
% (i) [3 points] Using this dual formulation, train a linear SVM 
% (i.e., k(x(i),x(j)) = x(i)?x(j)) on the training data with C = 100. 
% How many support vectors do you find? Note that due to numerical reasons,
% ?i is never going to be exactly 0 for non-support vectors. Use a positive 
% threshold (say 10?5) to determine if an input vector is a support vector.
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
hold on;
scatter(trainsetX_1(:,1),trainsetX_1(:,2),'r');
scatter(trainsetX_2(:,1),trainsetX_2(:,2),'b');
hold off
xlabel('Sepal Length');
ylabel('Sepal Width');

m = size(trainsetX,1);
n = size(trainsetX,2);
C = 100;

%Since K(i,j) = K(j,i) by property of kernels we can only need to go down
%half of the matrix and can fill in the transpose at the same time. @K is
%the kernel function in use
H = zeros(m,m);
K = @KernelFunction;
%warning('asdfa')
for i = 1:m,
    for j=i:m,
        H(i,j) = trainsetY(i)*trainsetY(j)*K(trainsetX(i,:),trainsetX(j,:));
        H(j,i) = H(i,j);
    end
    
end
%H = -H;
%f = [zeros(n+1,n+m+1); zeros(m,n+1) C*eye(m,m)];
f = -ones(m,1);
% generate A
Aeq = trainsetY';
beq = [0];


lb = zeros(m,1);
ub = C*ones(m,1);
[x, fval, exitflag, output, lambda] = quadprog(H,f,[],[],Aeq,beq,lb,ub);

%get support vectors
threshold = 10^-5;
%idx = lambda.ineqlin > threshold;
idx = x(:) > threshold;
supportVectorsAlpha = x(idx,:);
supportVectorsX = trainsetX(idx,:);
supportVectorsY = trainsetY(idx,:);

outerSum = 0;
sumW = [0 0];
for i = 1:length(supportVectorsY);
   
    innerSum = 0;
    for j = 1:length(supportVectorsY);
       innerSum = innerSum + supportVectorsAlpha(j)*supportVectorsY(j)*...
                            K(supportVectorsX(i,:),supportVectorsX(j,:)); 
    end
    outerSum = outerSum + supportVectorsY(i) - innerSum;
    sumW = sumW + supportVectorsAlpha(i)*supportVectorsY(i)*...
                                                      supportVectorsX(i,:);
end%
b = (1/length(supportVectorsY))*outerSum;
%b = outerSum+1;
%b = 0;

x_line = 4:0.01:7;
y = (-b - sumW(1)*x_line)/(sumW(2));
for i = 1:length(x_line),
    y_val = K(sumW,[x_line(i) y(i)]);
end
hold on;
plot(x_line,y,'-k');
plot(x_line,y+1/sumW(2),'-.r')
plot(x_line,y-1/sumW(2),'-.b')
hold off;
legend('1','-1','Decision Boundary','Margin 1','Margin -1');

fprintf('The number of non-zero alphas (i.e. Support Vectors) is %.02f\n',...
                                                   length(supportVectorsY));
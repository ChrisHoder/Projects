% FILE: q1k.m
% AUTHOR: Chris Hoder
% DATE: 2/28/2013
% COSC 74 
% Question 1 k)
%
% (k) [3 points] Retrain the dual formulation, but now use a polynomial 
% kernel of degree 3, i.e.
% k(x(i),x(j)) = (x(i)?x(j))3. How many support vectors do you have now?
% What does the decision function look like? Is it nonlinear?

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
K = @KernelFunction2;
%warning('asdfa')
for i = 1:m,
    for j=i:m,
        H(i,j) = trainsetY(i)*trainsetY(j)*K(trainsetX(i,:),trainsetX(j,:));
        H(j,i) = H(i,j);
    end
    
end

f = -ones(m,1);

% generate Aeq
Aeq = trainsetY';
% generate beq
beq = [0];


lb = zeros(m,1);
ub = C*ones(m,1);
[x, fval, exitflag, output, lambda] = quadprog(H,f,[],[],Aeq,beq,lb,ub);

%get support vectors
threshold = 10^-5;
idx = x(:) > threshold;
supportVectorsAlpha = x(idx,:);
supportVectorsX = trainsetX(idx,:);
supportVectorsY = trainsetY(idx,:);

% Calculate b
outerSum = 0;
for i = 1:length(supportVectorsY);
   
    innerSum = 0;
    for j = 1:length(supportVectorsY);
       innerSum = innerSum + supportVectorsAlpha(j)*supportVectorsY(j)*K(supportVectorsX(i,:),supportVectorsX(j,:)); 
    end
    outerSum = outerSum + supportVectorsY(i) - innerSum;
end%
b = (1/length(supportVectorsY))*outerSum;

% Compute the boundary layer
x_1 = (4.25:0.005:7)';
x_2 = (1:0.005:5.5)';
[X1, X2] = meshgrid(x_1,x_2);
Z = zeros(size(X1));
x_2_vals = zeros(length(x_1),1);
x_2_1 = zeros(length(x_1),1);
x_2_2 = zeros(length(x_2),2);
threshold = 10*10^-2;
% Generate the boundary layer
for i =1:size(X1,2),
    for j = 1:size(X1,1),
        innerSum = 0;
        for k = 1:length(supportVectorsY),
            innerSum = innerSum + supportVectorsAlpha(k)*supportVectorsY(k)*K(supportVectorsX(k,:),[X1(j,i) X2(j,i)]);
        end
        Z(j,i) = innerSum + b;
    end
    %find the margin point 
    [minVal I] = min(abs(Z(:,i)));
    [minVal_margin1,I_1] = min(abs(Z(:,i)-1));
    [minVal_margin_min1,I_2] = min(abs(Z(:,i)+1));
    Z(:,i);
    % here we check if points meet our threshold. We do not add the point
    % but we would would want to compute more points or make the threshold
    % larger to guarnetee that we have a sufficient number of points to
    % plot a good figure. Likewise since our region > 0 i simply just don't
    % add the points and then plot only the x_2 values that are greater
    % than 0
    if( abs(minVal) < threshold),
        x_2_vals(i) = X2(I,i);
    else
        disp('Make threshold larger or compute more points!')
        
    end
    if( abs(minVal_margin1) < threshold),
        x_2_1(i) = X2(I_1,i);
    else
        disp('Make threshold larger or compute more points!')
        
    end
    if( abs(minVal_margin_min1) < threshold),
        x_2_2(i) = X2(I_2,i);
    else
        disp('Make threshold larger or compute more points!')
       
    end
end
hold on;
plot(x_1(x_2_vals(:) ~= 0),x_2_vals(x_2_vals(:) ~= 0),'-k')
plot(x_1(x_2_1(:) ~= 0),x_2_1(x_2_1(:) ~= 0),'-.r');
plot(x_1(x_2_2(:) ~= 0),x_2_2(x_2_2(:) ~= 0),'-.b')
hold off;
% y = (-b - sumW(1)*x_line)/(sumW(2));
% % for i = 1:length(x_line),
% %     y_val = K(sumW,[x_line(i) y(i)]);
% % end
% hold on;
% plot(x_line,y);
% plot(x_line,y+1/sumW(2),'-.r')
% plot(x_line,y-1/sumW(2),'-.b')
% hold off;
legend('1','-1','Decision Boundary','Margin 1','Margin -1');

fprintf('The number of non-zero alphas (i.e. Support Vectors) is %.02f\n',...
                                                 length(supportVectorsY))
% FILE: q1g.m
% AUTHOR: Chris Hoder
% DATE: 2/28/2013
% COSC 74 
% Question 1 g)
%
%
% (g) [3 points] Train this formulation on the same training set. The data 
% is linearly separable, but you should still see the effect of the slack 
% variables depending on the setting of C. Plot the decision boundary as 
% well as the margin lines on top of the data for two different settings 
% of C. Also mark the support vectors. You should choose the settings of 
% C so that in one of the cases the margin lines look like as before; in 
% the other case several data points should violate the margin constraint.
% Report which values of C you found and how many support vectors you have
% in each case. Report the performance on the test set for both settings of
% C.
%
%
%
clc;close all; clear all;
warning('off','optim:quadprog:WillRunDiffAlg');
warning('off','all')
load('iris_subset.mat');



m = size(trainsetX,1);
n = size(trainsetX,2);
%C = 1000;
%c = [.01,.02, .03, .05, .1, 1, 10, 100, 1000];
c = [0.02, 100];
for q = 1:length(c)
    fprintf('\n-----------------\nSVM with C = %.02f\n',c(q))
    C = c(q);
    H = [eye(n) zeros(n,m+1); zeros(m+1,n+m+1)];
    %f = [zeros(n+1,n+m+1); zeros(m,n+1) C*eye(m,m)];
    f = [zeros(n+1,1); C*ones(m,1)];
    % generate A
    A = zeros(m,n+1+m);
    for i = 1:m,
        zerovec = zeros(1,m);
        zerovec(i) = -1;
        A(i,:) = [-trainsetY(i)*trainsetX(i,:) -trainsetY(i) zerovec];
    end

    d = -ones(m,1);
    lb = [ones(n+1,1)*-inf; zeros(m,1)];
    [x, fval, exitflag, output, lambda] = quadprog(H,f,A,d,[],[],lb,[]);
    
    w = x(1:2);
    b = x(3);
    x_line = 4:0.01:7;
    y = (-w(1)*x_line-b)/w(2);
    
    % Find the number of support vectors
    idx = lambda.ineqlin > 0;
    %get the support vectors
    supportVectorsX = trainsetX(idx,:);
    supportVectorsY = trainsetY(idx,:);
    num(q) = length(supportVectorsY);
    
    fprintf('The number of support vectors for C=%.02f is %d\n',c(q),num(q)); 

    
    
    %label data to find the error rate
    label = zeros(m,1);
    for i = 1:m,
        val = w'*trainsetX(i,:)'+b;
        if( val > 0)
            label(i) = 1;
        else
            label(i) = -1;
        end
    end
    
    label_test = zeros(size(testsetY,1),1);
    for i = 1:size(testsetY,1),
       val = w'*testsetX(i,:)'+b;
       if( val > 0),
           label_test(i) = 1;
       else
           label_test(i) = -1;
       end
        
    end
    
    %print error rate by comparing our labels to the trainsetY
    errors = sum(label(:) ~= trainsetY(:))/length(trainsetY);
    errorTest = sum(label_test(:) ~= testsetY(:))/length(testsetY);
    fprintf(['The error rate on the training set for C=%.02f is ',...
                                                   '%.02f\n'],c(q),errors);
    fprintf(['The error rate on the test set for C=%.02f is ',...
       '%.02f\n'],c(q),errorTest);

    %plot the data
    if( q == 1),
        subplot(2,2,1);
    else
        subplot(2,2,3);
    end
    hold on;
    plot(x_line,y,'-k');
    plot(x_line,y+1/w(2),'-.r');
    plot(x_line,y-1/w(2)','-.b');
    %scatter(trainsetX(label(:) == 1,1),trainsetX(label(:) == 1,2),'r');
    %scatter(trainsetX(label(:) == -1,1), trainsetX(label(:) == -1,2),'b');
    
    hold off;
    
    %color red (class 1)
    trainsetY_1 = trainsetY(trainsetY(:) == 1 );
    trainsetX_1 = trainsetX(trainsetY(:) == 1, :);


    %color blue (class -1)
    trainsetY_2 = trainsetY(trainsetY(:) == -1 );
    trainsetX_2 = trainsetX(trainsetY(:) == -1,:);

    % plot data
    hold on;
    scatter(trainsetX_1(:,1),trainsetX_1(:,2),'r');
    scatter(trainsetX_2(:,1),trainsetX_2(:,2),'b');
    
    xlabel('Sepal Length');
    ylabel('Sepal Width');
    title(sprintf('SVM results on Test Set with c value %.02f',C))
    scatter(supportVectorsX(:,1),supportVectorsX(:,2),'k')
    legend('Decision Boundary','margin 1','margin -1','1','-1','Support Vectors');
    hold off
    
    %test set
    if(q == 1),
        subplot(2,2,2);
    else
        subplot(2,2,4);
    end
    %color red (class 1)
    testsetY_1 = testsetY(testsetY(:) == 1);
    testsetX_1 = testsetX(testsetY(:) == 1,:);
    
    %color blue (class -1)
    testsetY_2 = testsetY(testsetY(:) == -1 );
    testsetX_2 = testsetX(testsetY(:) == -1, :);
    
    %plot data
    hold on;    
    plot(x_line,y,'-k');
    plot(x_line,y+1/w(2),'-.r');
    plot(x_line,y-1/w(2)','-.b');
    scatter(testsetX_1(:,1),testsetX_1(:,2),'r');
    scatter(testsetX_2(:,1),testsetX_2(:,2),'b');
    %scatter(trainsetX(label(:) == 1,1),trainsetX(label(:) == 1,2),'r');
    %scatter(trainsetX(label(:) == -1,1), trainsetX(label(:) == -1,2),'b');
    legend('Decision Boundary','margin 1','margin -1','1','-1');
    xlabel('Sepal Length');
    ylabel('Sepal Width');
    title(sprintf('SVM results on Test Set with c value %.02f',C))
    hold off;
    
    
end


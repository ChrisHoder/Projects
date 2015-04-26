% FILE: MLNB.m
% AUTHOR: Chris Hoder
% DATE: 2/14/13
% COSC 74
% Problem Set 2 Question 3 a)

% This method will compute the parameters for the naive bayes model. The
% parametes are the conditional probabiliteis after assuming the
% conditional independence assumption:
%               p(x_i|y,x_j) = p(x_i|y) for all i not equal to j
%
% X is the training set with m examples (rows) and n feautres (columns)
% Y is the output to be predicted as a vector.
%
% OUTPUT:
%       phiY: p(y=1)
%       phiValues: n x 2 matrix
%       phiValues(i,1) = p(x_i = 1 | y = 1)
%       phiValues(i,2) = p(x_i = 1 | y = 0)
%
%       Output values are computed using Laplacian smoothing 
function [phiY, phiValues] = MLNB(X,Y)
    m = length(Y);
    n = size(X,2);
    % m == number of test samples
    % n == number of variables
    %y can only be 1 or 0 so just take the sum
    sumY = sum(Y);
    phiY = sumY/m;

    %number of parameters
    phiValues = zeros(n,2);
    %yZeros = find(Y==0);
    yZeros = Y==0;
    yOnes  = Y==1;
    for i = 1:n,
        % With laplacian smoothing
        phiValues(i,1) = (1+sum(X(yOnes,i)))/(2+sumY);
        phiValues(i,2) = (1+sum(X(yZeros,i)))/(2+m-sumY);
        %non - laplacian smoothing
        %phiValues(i,1) = sum(x(yOnes,i))/sumY;
        %phiValues(i,2) = sum(x(yZeros,i))/(m-sumY);
    end
end
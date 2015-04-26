%test file
%test Code
close all; clear all;
type = 'q';
load('autompg.mat')
dataSetX = trainsetX;
dataSetY = trainsetY;
y = trainsetY;
lambdas = [10^-5, 10^-4 , 10^-3, 10^-1, 10,100, 10^3, 10^5, 10^7];
theta = zeros(max(size(lambdas)));
L = zeros(max(size(lambdas)));
for i = 1:max(size(lambdas)),
    theta = regularizeRegression(dataSetX,dataSetY,lambdas(i),type);
    %legend('Test','train')
    L(i) = errorEval(theta,testsetX,testsetY,type)
end

semilogx(lambdas,L)
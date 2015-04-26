%% train
clear all; close all; clc
load('spamdata.mat');

x = trainsetX;
y = trainsetY;
m = length(y);
n = size(trainsetX,2);
% m == number of test samples
% n == number of variables
%y can only be 1 or 0 so just take the sum
sumY = sum(y);
phiY = sumY/m;

%number of parameters
phiValues = zeros(n,2);
yZeros = find(y==0);
yOnes  = find(y==1);
for i = 1:n,
    phiValues(i,1) = (1+sum(x(yOnes,i)))/(2+sumY);
    phiValues(i,2) = (1+sum(x(yZeros,i)))/(2+m-sumY);
    %phiValues(i,1) = sum(x(yOnes,i))/sumY;
    %phiValues(i,2) = sum(x(yZeros,i))/(m-sumY);
end


%% test

X = testsetX;
Y = testsetY;
m = size(X,1);
n = size(X,2);
error = 0;
%find the log prob
predictY = zeros(m,1);
for j = 1:m,
    x = X(j,:);
    y = Y(j);
    logprob1 = 0;
    logprob0 = 0;
    for i = 1:n,
       if( x(i) == 1)
            logprob1 = logprob1 + log(phiValues(i,1));
            logprob0 = logprob0 + log(phiValues(i,2));
       else
            logprob1 = logprob1 + log(1-phiValues(i,1));
            logprob0 = logprob0 + log(1-phiValues(i,2));
       end
    end
    prob1 = exp(logprob1);
    prob0 = exp(logprob0);
    Prob = (phiY*prob1) / (prob1*phiY + (1-phiY)*prob0);
    %logProb = (log(phiY) + logprob1) - log(phiY) - logprob1 (1-phiY)*(logprob0));
    if( Prob > 1/2)
        predictY(j) = 1;
    else
        predictY(j) = 0;
    end
    if( predictY(j) ~= y ),
        error = error + 1;
    end
end

%% part b
clear all; close all; clc
load('spamdata.mat');

x = trainsetX;
y = trainsetY;
m = length(y);
n = size(trainsetX,2);
% m == number of test samples
% n == number of variables
%y can only be 1 or 0 so just take the sum
sumY = sum(y);
phiY = sumY/m;

%number of parameters
phiValues = zeros(n,2);
yZeros = find(y==0);
yOnes  = find(y==1);
for i = 1:n,
    %calculate p(xi = 1 | y=1) with laplacian smoothing
    phiValues(i,1) = (1+sum(x(yOnes,i)))/(2+sumY);
    %calculate p(xi = 1 | y=0) with laplacian smoothing
    phiValues(i,2) = (1+sum(x(yZeros,i)))/(2+m-sumY);
end


prob0 = zeros(n,1);
for i = 1:n,
   %we include this index so that we can reference the word after we sort
   %the data down below
   prob0(i,1) = i;
   prob0(i,2) = (phiValues(i,2)*(1-phiY))/(phiValues(i,2)*(1-phiY) +...
                                                    phiValues(i,1)*phiY);
end


%generate the names of the 6 most indicative of spam and the 6 most
%indicative of ham by loading the text document
names = textread('spambase_names.txt','%s');
%sorts based on the probabilities in ascending order
sortedprobs = sortrows(prob0,2);
disp('6 most indicative of a message being "spam":');
namesIdx = sortedprobs(1:6,1);
spamwords = sprintf('1. %s, 2. %s, 3. %s, 4. %s, 5. %s, 6. %s',...
    names{namesIdx(1)},names{namesIdx(2)},names{namesIdx(3)},...
    names{namesIdx(4)},names{namesIdx(5)},names{namesIdx(6)});
disp(spamwords);
fprintf('\n\n');
disp('6 most indicative of a message being "ham":');
namesIdx = sortedprobs(end-6:end,1);
spamwords = sprintf('1. %s, 2. %s, 3. %s, 4. %s, 5. %s, 6. %s',...
    names{namesIdx(6)},names{namesIdx(5)},names{namesIdx(4)},...
    names{namesIdx(3)},names{namesIdx(2)},names{namesIdx(1)});
disp(spamwords)
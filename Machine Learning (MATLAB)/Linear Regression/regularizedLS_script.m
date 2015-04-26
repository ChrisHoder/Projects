% script

%case 1 the B is just testsetX' + a row of 1's at the top9

%case 2 the B is more complicated:

%given x as [1,2,3] row that has n fields

% inputs
lambda2 = [10e-5  10e-3 10e-1 10, 10^3, 10^5, 10^7];
lambda = lambda(1);


%% given dataset, lambda
type = 'q';
load('autompg.mat')
dataSet = testsetX;
y = testsetY;
%% linear case
if( strcmp(type,'l') == 1)
    [m, n] = size(dataSet);
    B = [ones(m,1)  dataSet];
    A = (B'*B + lambda*eye(n+1));
elseif( strcmp(type,'q') ==1)
    %% Quadratic case
    %get the number of rows, m and columns, n. where each row is a different
    %data point and the columns are the values for each respective field.
    [m, n] = size(dataSet);
    for j = 1:m,
        b = [1 x];
        for i = 1:n,
            b = [b x(i)*x(i:end)];
        end
        b = b';
        if( j==1)
            B = b;
        else   
            B = [B b];
        end
    end
    B = B';
    A = (B'*B + lambda*eye(size(B,2)));
end

yprime = B'*y;
theta = A\yprime;



%% error test, given test set
testSet = testsetX;
yTest = testsetY;
sum = 0;
for i = 1:m,
    sum = sum + (yTest(i)-theta'*B(i,:)')^2;
end
sum = sum/m;


%% cross validation
%number of folds
k = 10;

%generate a random permutation of the indices for the data
indx = randperm(m);
subsetSize = floor(m/k);
remainder = mod(m,k);

%for each set generate the training and test sets based on the number of
%folds givne in k
for i=1:k,
    tSet = dataSet(indx(subsetSize*(i-1)+1:subsetSize*i),:);
    %add in the remainder row if needed
    if(i <= remainder),
        tSet = [tSet ; dataSet(k*subsetSize+i,:)];
    end
    
    %data before validation set
    dSettemp1 = dataSet(indx(1:(i-1)*subsetSize),:);
    %data after validation set (includes first part of remainder
    dSettemp2 = dataSet(indx((subsetSize*i)+1:subsetSize*k+i),:);
    %remainderdata
    dSettemp3 = dataSet(indx(subsetSize*k+i+1:end),:);
    
    dSet = [dSettemp1; dSettemp2; dSettemp3];
    
end

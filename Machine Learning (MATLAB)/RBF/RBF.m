%script to run an RBF with either gaussian or thin-plate spline basis
%functions, 'nodes' different hidden layer sizes, and tim inetervals
%6,12,18 and 24 hours in advance. 
load('All_Train_Test_handin.mat');

%selection of RBF. 0 -> Gaussian, 1-> Thin-Plate Spline
sel = 0;

%loops to run through different size k and different time intervals. we
%will store the predictions in a cell array 'results' and labels as 2x1
%vectors giving the time interval and numer of hidden nodes. 
results = {};
labels = {};
nodes = [100,500,1000];
intervals = [6,12,18,24];

for t=1:4
for q=1:3
    
%pick different training sets and corresponding test sets
k = nodes(q);
if t==1    
    X = x6train;                    Y = y6train;
    X_test = x6test;        
    [m_test,~] = size(X_test);      phi_test = zeros(m_test,k);
elseif t==2
    X = x12train;           Y = y12train;
    X_test = x12test;        
    [m_test,~] = size(X_test);      phi_test = zeros(m_test,k);
elseif t==3
    X = x18train;           Y = y18train;
    X_test = x18test;        
    [m_test,~] = size(X_test);      phi_test = zeros(m_test,k);
elseif t==4
    X = x24train;           Y = y24train;
    X_test = x24test;        
    [m_test,~] = size(X_test);      phi_test = zeros(m_test,k);
end

%pick different number of nodes
[m,n] = size(X);

%call pickCent function to pick center, with 2nd input equal to 0 or 1. 0
%gives a random selection of samples from X as the centers. 1 gives an 
%orthogonal least sqaures selection of centers.
if sel == 0
    cent = pickCent(k,X,0);
elseif sel == 1
    cent = pickCent(k,X,1);
end

%gives euclidean distance from point i of cent to point j. a vector is
%returned with distances in the order: (2,1),...,(m,1),(3,2),...,(m,2),...,
%(m,m-1).
    dist = pdist(cent,'euclidean');
    
%common choices of sig_i
%d_ave is the average distance to centers from samples    
if sel == 0
    sig = 2*mean(dist)*ones(k,1);
end
    
%Basis function in-line equations. 
%'x' is a kxn matrix of repeated rows of vector x^i. 'c' is kxn matrix
%of center points. 's' is a kx1 matrix of sigma_j, j=1,..,k. 

%returns a vector of length k of the gaussian function for all centers
%c_1,...,c_k for the given point x. 
    gauss = @(x,c,s) exp(-1* diag((x-c)*((x-c)'))./(2*s.^2) );
%spline, same as gauss, with RBF rlog(r^2) instead of exp(-r^2/2sig^2),
%where r is the distance ||x-c||
    thin_plate = @(x,c) diag((x-c)*((x-c)')) .* log( sqrt( diag((x-c)*((x-c)')) ) );

%pre-allocate space for phi matrix
phi = zeros(m,k);

%calculate the gaussian for each center and each point. one iteration
%calculates the gaussian for all centers and one sample x. 
for i=1:m
    x_fun = repmat(X(i,:),k,1);
    if sel == 0
        phi(i,:) = gauss(x_fun,cent,sig)';
    elseif sel == 1
        phi(i,:) = thin_plate(x_fun,cent)';
    end
end

%solve directly for weights using pseudoinverse, where W^T = Phi^t*Y
W = pinv(phi)*Y;
W = W';
    
%run algorithm with weights on test data to make prediction. 
for j=1:m_test
    x_fun_t = repmat(X_test(j,:),k,1);
    if sel == 0
        phi_test(j,:) = gauss(x_fun_t,cent,sig)';
    elseif sel == 1
        phi_test(j,:) = thin_plate(x_fun_t,cent)';
    end
end

%store predictions and vector signifying data set and k-value in cell
%arrays
y_pred = W*phi_test';
results{end+1} = y_pred;
labels{end+1} = [intervals(t),nodes(q)];

end
end
% FILE: regularizeRegression.m
% AUTHOR: Chris Hoder
% COSC 74
% 1/30/2013

% This method will compute the theat values for a regularized regression
% where X is the traning data with the rows being separate training
% examples and the columns being the feature values. y is the vector of the
% outcome we wish to predict. Type can be either 'l' or 'q' for linear or
% quadratic b vectors as defined in the problem set.
function theta = regularizeRegression(X,y,lambda,type)
    % linear case
    if( strcmp(type,'l') == 1)
        [m, n] = size(X);
        B = [ones(m,1)  X];
        %A = (B'*B + lambda*eye(n+1));
        %We do not want to regularize the constant coefficient we added in
        I = eye(n+1);
        I(1,1) = 0;
        A = (B'*B + lambda*I);
    elseif( strcmp(type,'q') == 1)
        % Quadratic case
        % get the number of rows, m and columns, n. where each row is a 
        % different data point and the columns are the values for each
        % respective field.
        [m, n] = size(X);
        for j = 1:m,
            b = [1 X(j,:)];
            for i = 1:n,
                b = [b X(j,i)*X(j,i:end)];
            end
            b = b';
            if( j==1)
                B = b;
            else   
                B = [B b];
            end
        end
        B = B';
        % we do not want to regularize the constant coefficient we added in
        I = eye(size(B,2));
        I(1,1) = 0;
        A = (B'*B + lambda*I);
    end
    % calculate theta via the closed form solution
    yprime = B'*y;
    theta = A\yprime; 
end
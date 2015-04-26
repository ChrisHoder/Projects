% FILE: errorEval.m
% AUTHOR: Chris Hoder
% COSC 74
% 1/30/2013

% This method will compute the mean squared error of the data set X of type
% 'l' or 'q' for the given thetas
function error = errorEval(theta,dataX,dataY, type)
    % linear case
    if( strcmp(type,'l') == 1)
        [m, n] = size(dataX);
        B = [ones(m,1)  dataX];
    elseif( strcmp(type,'q') ==1)
        % Quadratic case
        %get the number of rows, m and columns, n. where each row is a different
        %data point and the columns are the values for each respective field.
        [m, n] = size(dataX);
        for j = 1:m,
            b = [1 dataX(j,:)];
            for i = 1:n,
                b = [b dataX(j,i)*dataX(j,i:end)];
            end
            b = b';
            if( j==1)
                B = b;
            else   
                B = [B b];
            end
        end
        B = B';
    end
    
    %number of examples
    m = size(dataY,1);
    
    % calculate the mean squared error
    sum = 0;
    for i = 1:m,
        sum = sum + (dataY(i)-theta'*B(i,:)')^2;
    end
    error = sum/m;


end
% FILE: natCubicSpline.m
% AUTHOR: Chris Hoder
% DATE: 9/27/2012
% ENGS 91
% Laboratory 3

% This method will compute the coefficients for a natural cubic spline of
% the form:
%   S_j(x) = a_j + b_j*(x-x_j)+c_j*(x-x_j)^2 + d_j*(x-x_j)^3
%
% The inputs are the x,y points for which to make the cubic spline. The
% outputs are the a,b,c,d coefficient vectors individually.
%
% This code was developed by modfying the pseudocode presented in the text
% on page 146, however I used the left divide matrix operation instead of
% using the tridiagonal algorithm used in the book. 
function [a,b,c,d] = natCubicSpline(x,y)
    % the a coefficients are all the points y
    a = y;
    %determine the size (nunber of splines)
    n = max(size(x))-1;
    %calculate h_i
    h = zeros(n,1);
    %get the difference equation x_j-x_(j-1)
    for i=0:n-1,
        h(i+1) = x(i+2)-x(i+1);
    end
    %determine the alpha vector (see attached notes)
    alpha = zeros(n+1,1);
    for i=1:n+1,
        if(i==1),
            alpha(i) = 0;
        elseif(i==n+1),
            alpha(i) = 0;
        else
            alpha(i) = (3/h(i))*(y(i+1)-y(i))-(3/h(i-1))*(y(i)-y(i-1));
        end
    end
    %create the tridiagonal matrix, as shown on attached sheet
    H = zeros(n+1,n+1);
    for i = 1:n+1,
        for j=1:n+1,
            %this is the diagonal term
            if( i==j),
                if( i==1),
                    H(i,j) = 1;
                elseif( i== n+1),
                    H(i,j) = 1;
                else
                    H(i,j) = 2*(h(i-1)+h(j));
                end
            %the terms below the diagonal
            elseif( i == j+1),
                if( j == n),
                    H(i,j) = 0;
                else,
                    H(i,j) = h(j);
                end
            %terms above the diagonal
            elseif( j == i+1),
                if(j == 2),
                    H(i,j) = 0;
                else,
                    H(i,j) = h(i);
                end
            end
           
        end
    end
    %solve for the c coefficients using linear/matrix algebra    
    c = H\alpha;
    
    % now we can use this infomation to determine the b,d
    % coefficients, these will only have 32 points (the number of splines)
    for i = n:-1:1,
       b(i) = (a(i+1)-a(i))/h(i)-h(i)*(c(i+1)+2*c(i))/3;
       d(i) = (c(i+1)-c(i))/(3*h(i));
    end
    
    a;
    b;
    c;
    d;
    
   %method returns a,b,c,d separately 
end
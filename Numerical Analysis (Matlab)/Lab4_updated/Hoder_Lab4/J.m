% FILE: J.m
% AUTHOR: Chris Hoder
% DATE: 10/8/2012
% CLASS: ENGS 91
% Laboratory 4 Question 1


% this method computes the jacobian for the non-linear system for question
% one on the lab, the equations were derived by hand and are in the work
% sheet
function JMatrix = J(a,b)
    x = [ 5 13 21 27 38 48 60 72 92];
    y = [44 29 20 14 8   5  3  2  1];
    df1da = 0;
    df1db = 0;
    df2da = 0;
    df2db = 0;
    %all of these partials require a sum over the input points
    for i = 1:9,
     % df1/da
     df1da = df1da + 4*b*x(i)*exp(2*x(i)*a)-2*y(i)*x(i)*exp(a*x(i));
     %df1/db
     df1db = df1db + 2*exp(2*a*x(i));
     %df2/da
     df2da = df2da + 4*b*x(i)*exp(2*a*x(i))-2*x(i)^2*y(i)*exp(a*x(i));
     %df2/db
     df2db = df2db + 4*b*x(i)*exp(2*a*x(i))-2*x(i)*y(i)*exp(2*x(i));
    end
    %put together the entire matrix
     JMatrix = [df1da df1db; df2da df2db];
    
end
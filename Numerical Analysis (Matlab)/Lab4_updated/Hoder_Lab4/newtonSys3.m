% FILE: newtonSys3.m
% AUTHOR: Chris Hoder
% DATE: 10/8/2012
% CLASS: ENGS 91
% Laboratory 4 Question 1

% this method applies newton's equations for solving a system of nonlinear 
% equations. the equations are designed to minimize the error between the
% given points and the nonlinear equation y = b*exp(a*x). It will return
% all of the values for each step. guess is the initial guess to the
% solution in the form guess = [a,b]
function result = newtonSys3(guess,tol,nMax)
    %save the initial values
    result(1,1) = guess(1,1);
    result(1,2) = guess(1,2);
    %error array
    error(1) = 1;
    i=2;
    %while i < max number of iterations, continue
    while(i<nMax),
       %evaluate the function, f, and the jacobian J at the ith points
       a = result(i-1,1);
       b = result(i-1,2);
       JMatrix = J(a,b);
       f = fMatrix(a,b);
       %find the 2 new points using Newton's method for a system of
       %nonlinear equations
       valuesNew = result(i-1,:)-(JMatrix\f)';
       result(i,1) = valuesNew(1);
       result(i,2) = valuesNew(2);
        
       %calc error
       resultOld = result(i-1,:);
       errorTemp = abs(valuesNew-resultOld);
       %error(i) = sqrt(errorTemp*errorTemp');
       error(i) = sqrt(errorTemp*errorTemp')/sqrt(valuesNew*valuesNew');
       %if the error is less than our tolerance, we are done, exit the
       %loop
       if( error(i) < tol),
           break;
       end
        
        %update iterator
        i = i+1;
        
    end
   %if method exited loop due to max number of iterations, warn the user.
    if( i == nMax),
        warning(['Method reached max number of iterations,',...
                        '%d'],nMax);
    end
    
end
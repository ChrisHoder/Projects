% FILE: newtonSys2.m
% AUTHOR: Chris Hoder
% DATE: 10/8/2012
% CLASS: ENGS 91
% Laboratory 4 Question 2

% this method can be used to solve the linkage problem in  question 3 
% using Newton's method for
% systems of nonlinear equations. theta is a vector of the initial
% conditions for theta2 and theta3. tol is the tolerance we want to know
% the root to. nMax is the maximum number of iterations. This uses the
% inversion of the Jacobian. This will return thetaN which contains a
% matrix where the first column is theta2 the 2nd is theta3. the iteration
% number is the row number where the iterations start at 1.
%
% Some changes have been made to this code, it now inputs theta4 and the
% linkage lengths so that it can be adapted for Lab4 Q2

function thetaN = newtonSys2(theta,tol,nMax,theta4,r1,r2,r3,r4)
    %save the initial values
    thetaN(1,1) = theta(1,1);
    thetaN(1,2) = theta(1,2);
    %error array
    error(1) = 1;
    i=2;
    %while i < max number of iterations, continue
    while(i<nMax),
       %evaluate the function, f, and the jacobian J at the ith points
       theta2 = thetaN(i-1,1);
       theta3 = thetaN(i-1,2);
       J = [-r2*sin(theta2) -r3*sin(theta3); r2*cos(theta2) r3*cos(theta3)];
       f = [r2*cos(theta2)+r3*cos(theta3)+r4*cos(theta4)-r1;
                        r2*sin(theta2)+r3*sin(theta3)+r4*sin(theta4)];
       %find the 2 new points using Newton's method for a system of
       %nonlinear equations
       thetaNew = thetaN(i-1,:)-(J\f)';
       thetaN(i,1) = thetaNew(1);
       thetaN(i,2) = thetaNew(2);
        
       %calc error
       thetaOld = thetaN(i-1,:);
       errorTemp = abs(thetaNew-thetaOld);
       %error(i) = sqrt(errorTemp*errorTemp');
       error(i) = sqrt(errorTemp*errorTemp')/sqrt(thetaNew*thetaNew');
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
                        '%d with theta4 input as %d'],nMax,theta4_input);
    end
    
end
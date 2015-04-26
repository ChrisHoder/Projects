% FILE: modNewton.m
% AUTHOR: Chris Hoder
% DATE: 9/20/2012
% CLASS: ENGS 91
% LAB 2 QUESTION 1


% This method will attempt to find the root of the function f by using the
% modified newton's method. f, fprime, fprime2 are the function, the
% derivative and the second derivative of the function as a MATLAB
% function. Po is an initial point, tol is the tolerance we want to know
% the root to, nMax is the maximum number of iterations that will be
% performed. This method will return a matrix which contains all of the
% points calculated. the first column will be the iteration number, the 2nd
% column the point, Pn and the 3rd column will be the function evaluated at
% this point, f(Pn).

function Pn = modNewton(f, fprime, fprime2, Po, tol, nMax)
    %set initial values
    Pn(1,1) = 0;
    Pn(1,2) = Po;
    Pn(1,3) = f(Po);
    Pn(1,4) = 1;
    %set iterator
    i = 2;
    %while we are less than the maximum number of iterations, continue.
    while( i < nMax),
        %save iterator
        Pn(i,1) = i-1;
        %use modified newton's method
        Pn(i,2) = Pn(i-1,2) - f(Pn(i-1,2))*fprime(Pn(i-1,2))/...
                   ((fprime(Pn(i-1,2))^2)-f(Pn(i-1,2))*fprime2(Pn(i-1,2)));
        % evaluate the function, f at this new point
        Pn(i,3) = f(Pn(i,2));
        %if the point is under our tolerance, exit we are done
        %Pn(i,4) =  abs((Pn(i,2)-Pn(i-1,2))/Pn(i,2));
        Pn(i,4) = abs((Pn(i,2)-Pn(i-1,2)));
        if( Pn(i,4) < tol),
            break;
        end
        %update iterator
        i = i + 1;
    end
    %if loop exited due to reaching the maximum number of iterations, warn
    %the user
    if( i == nMax),
        warning('Method reached max number of iterations, %d',nMax);
    end
    
end
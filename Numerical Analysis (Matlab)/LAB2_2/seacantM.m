% FILE: seacantM.m
% AUTHOR: Chris Hoder
% DATE: 9/20/2012
% CLASS: ENGS 91
% LAB 2 QUESTION 1

% This function will use the seacant method to find the root of the
% provided function, f (as a function). Po, P1 are the initial point for
% n=0 and n=1 respectively. tol is the tolerance that you want to know the
% root to. nMax is the maximum number of iterations the method will perform
% before exiting. A warning will be displayed if the method exits because
% of the maximum number of iterations. The method will return a matrix wher
% the first column is the iteration number, the second column is the Pn
% value and the third column is the f(Pn) value.

function Pn = seacantM(f,Po,P1,tol,nMax),
    %Set intial values into the matrix
    Pn(1,1) = 0;
    Pn(1,2) = Po;
    Pn(1,3) = f(Po);
    Pn(1,4) = 1;
    Pn(2,1) = 1;
    Pn(2,2) = P1;
    Pn(2,3) = f(Po);
    Pn(2,4) = abs((Pn(2,2)-Pn(2,1))/Pn(2,2));
    %initialize iteration variable
    i = 3;
    %while i < max number of iterations allowed, continue
    while( i < nMax),
       %set iteration number
       Pn(i,1) = i-1;
       %get point using seacant method
       Pn(i,2) = Pn(i-1,2) - (f(Pn(i-1,2))*(Pn(i-2,2)-Pn(i-1,2)))/...
                                               (f(Pn(i-2,2))-f(Pn(i-1,2)));
       %evaluate f at the new point
       Pn(i,3) = f(Pn(i,2));
       %if our point is less than the tolerance, we are done, exit
       Pn(i,4) = abs((Pn(i,2)-Pn(i-1,2))/Pn(i,2));
       if( Pn(i,4) < tol),
           break;
       end
                                              
        %update iteration number
        i=i+1;
    end
    %if we exited due to reaching max iterations, display a warning.
    if( i == nMax),
        warning('Method reached max number of iterations, %d',nMax);
    end
end
% FILE: newtonsM.m
% AUTHOR: Chris Hoder
% DATE: 9/20/2012
% CLASS: ENGS 91
% LAB 2 QUESTION 1

% This method will perform newton's method of root finding using the given
% f function and fprime (derivative of the function) that are input. Po is
% the intial point to start at, tol is the tolerance to know the root to
% and nMax is the maximum number of iterations. This method will return a
% matrix where the first column is the iteration number, 2nd is the Point
% value for that iteration number and the 3rd is the function evaluated at
% that point

function Pn = newtonsM(f,fprime, Po, tol, nMax)
    %save intial values
    Pn(1,1) = 0;
    Pn(1,2) = Po;
    Pn(1,3) = f(Po);
    %this isn't important, but initially set the relative convergence error
    % to 1
    Pn(1,4) = 1;
    %set iteration number
    i = 2;
    %while i < Max number of iterations, continue
    while( i < nMax),
        %save new iteration number
        Pn(i,1) = i-1;
        %get new point using newton's method
        Pn(i,2) = Pn(i-1,2) - (f(Pn(i-1,2))/fprime(Pn(i-1,2)));
        %evaluate f at this point
        Pn(i,3) = f(Pn(i,2));
        % if our error is less than the tolerance, then we are done
        % and should exit the loop
        Pn(i,4) = abs((Pn(i,2)-Pn(i-1,2))/Pn(i,2));
        if( Pn(i,4) < tol),
            break;
        %check to make sure that the derivative is not going to 0 also
        elseif(fprime(Pn(i,2))==0),
            warning('f''(%d)'' = 0', Pn(i,2));
            break;
        end
        %update iteration number
        i = i+1; 
    end
    % if the loop exited because it reached the maximum number of
    % iterations, display a warning for the user. i.e. we are not yet
    % within the tolerance the user specified.
    if( i == nMax),
        warning('Method reached max number of iterations, %d',nMax);
    end
    
end

% FILE: AitkenM.m
% AUTHOR: Chris Hoder
% DATE: 9/23/2012
% CLASS: ENGS 91
% LAB 2 QUESTION 1

% This method will perform Aitken's delta squared method on a set of
% linearly converging points, x. 

function PnHat = AitkenM(x,tol),

    i = 1;
    %while there are still more points in x that can be used
    while( (i+2) < max(size(x)) ),
        PnHat(i,3) = i;
        %get the new set of points PnHat(i)
        PnHat(i,1) = x(i) - ((x(i+1)-x(i))^2)/(x(i+2)-2*x(i+1)+x(i));
        %check the error on all but the first iteration
        if( i >1),
           %compute relative error
           PnHat(i,2) = abs((PnHat(i,1) - PnHat(i-1,1))/PnHat(i,1));
           %if our error is less than the tolerance, exit
           if( PnHat(i,2) < tol),
               break;
           end
        end
        %increment up
        i = i + 1; 
    end

end
% FILE: RombergInt.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 2


%This method will perform romberg integration on the function f over the
%interval  a->b. The iterations will be repeated until the difference is
%less than the tol, at which point the method will return the Romberg
%table, R. Additionally, if this toleranc is not met the method will stop
%after nMax iterations.This method had the function f(x) = x^(1/3)
%hardcoded for computational efficiency
function [R count] = RombergIntb(a,b,nMax,tol),
    h(1) = b-a;
    R(1,1) = (h/2)*((b^(1/3))+(a)^(1/3));
    count = 2;
   	for i=2:nMax,
       if( i  == 2),
           h(i) = h(1);
       else
           h(i) = h(i-1)/2;
       end
        
       sumVal = 0;
       %compute the sum
       for z = 1:2^(i-2),
           sumVal = sumVal + (a + (z - 1/2)*h(i))^(1/3); %sum in Eq 4.32 in text 
           count = count+1;
       end
       R(i,1) = (1/2)*(R(i-1,1)+h(i)*sumVal);
       
       %fill in the row
       for j = 2:i,
           %extrapolation via Eq. 4.35
           R(i,j) = R(i,j-1) + ((R(i,j-1)-R(i-1,j-1))/(4^(j-1)-1));
       end
       
       %if we are within our tolerance level, we are done and can exit the
       %method. Switch these two if statements for different exit criteria.
       %The second checks to see when the composite trapezoidal rule has
       %reached a given error criteria
       %if( abs(R(i,i) - R(i-1,i-1)) < tol)
       if( abs(R(i,1) - R(i-1,1)) < tol),
           break;         
       end
       
    end
    
   
    %if loop exited due to reaching the maximum number of iterations, warn
    %the user
    if( i == nMax),
        warning('Method reached max number of iterations, %d',nMax);
    end

end
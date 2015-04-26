% FILE: chebyshevRoots.m
% AUTHOR: Chris Hoder
% DATE: 9/27/2012
% ENGS 91
% Laboratory 3

%Return the n roots of the chebyshev nth order polynomial.
function x = chebyshevRoots(n)
    x = zeros(n,1);

    %this formula was taken from the book
    for k=1:n,
       x(k)  = cos(((2*k-1)/(2*n))*pi);
        
    end

    
end
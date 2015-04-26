% FILE: BesselCalcForward.m
% DATE: 9/16/2012
% AUTHOR: Chris Hoder
% CLASS: ENGS 91
% ASSIGNMENT: 1

% This method will use the recursion relation definition of bessel
% functions to determine all of the J_n(x) values for a given x value and
% the first 2 bessel function values (n0 and n1). The returned value will
% be a matrix which contains the n value, exact value (from besselj
% method), value determined using the recursion relation, absolute error
% between the two and relative error between the two.

function calc = BesselCalcForward(x,nMax,n0,n1)
%create arrray for data
calc = zeros(nMax+1,5);
%calculate each n value in the recursion
for i=1:1:nMax+1,
    %gets the exact value from BesselJ matlab method
    x1 = besselj(i-1,x); 
    
    %initial conditions are added in
    if( i == 1 ),
        x2 = n0;
    elseif( i == 2 ),
        x2 = n1;
    else
        %use the recursion relation
        % J_n+1 = (2n/x)J_n - J_n-1 
        x2 = ((2*(i-2))/x)*calc(i-1,3)-calc(i-2,3);
    end
    %save the n value
    calc(i,1) = i-1;
    calc(i,2) = x1;
    calc(i,3) = x2;
    % absolute error w/absolute value taken
    calc(i,4) = abs(x1-x2);
    % relative error w/absolute value taken
    calc(i,5) = abs(calc(i,4)/x1);
   
end
end
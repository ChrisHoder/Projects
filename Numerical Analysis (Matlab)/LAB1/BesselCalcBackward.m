% FILE: BesselCalcBackward.m
% DATE: 9/16/2012
% AUTHOR: Chris Hoder
% CLASS: ENGS 91
% ASSIGNMENT: 1

% This method will use the recursion relation definition of bessel
% functions to determine all the J_n(x) values for a given x starting at
% the given n value and working backward to n=0. The user must also input
% the first 2 initial values nMax which is J_n(x) and nMax2 which is
% J_n-1(x). The absolute and relative errors will also be returned. the
% built-in besselj method is used for the exact values.
%
% The returned value will
% be a matrix which contains the n value, exact value (from besselj
% method), value determined using the recursion relation, absolute error
% between the two and relative error between the two.


function error = BesselCalcBackward(x,nStart,nMax,nMax2)
%create array for data
error = zeros(nStart + 1,5);
    %calculate each n value in the recursion
    for i= nStart+1:-1:1,
        % save the n value
        error(i,1) = i-1;
        %initial conditions, user inputs first 2 values
        if( i-1 == nStart),
            %first bessel value input
            error(i,3) = nMax;
        elseif( i-1 == nStart - 1),
            %2nd bessel value input
            error(i,3) = nMax2;
        else
            %use recursion relation to determine  the next J_n(x)
            error(i,3) = ((2*i)/x)*error(i+1,3)-error(i+2,3);
        end

        % find exact bessel value for J_n(x)
        error(i,2) = besselj(i-1,x);
        % determine absolute difference w/ absolute value taken
        error(i,4) = abs(error(i,2) - error(i,3));
        % determine relative value taken w/ absolute value taken
        error(i,5) = abs(error(i,4)/error(i,2));
    end

end
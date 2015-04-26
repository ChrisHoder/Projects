% FILE: neville.m
% AUTHOR: Chris Hoder
% DATE: 9/27/2012
% ENGS 91
% Lab 3

% This method performs neville's algorithm. points are the x points for
% which you have y = f(x). I.e. f(points(i)) = y(i) where f() is the
% function you are attempting to approximate. n is the order of the
% polynomial.
%
% The code for this was developed following an algorithm similar to that
% presented on p118 of the text. We can build higher order polynomials
% based on 2 points from a lower order polynomial. Repeating this process
% recursively we can obtain the desired order polynomial. 
function out = neville(points,y,x,n)
    %put the y(i) values as the first column
    for i = 1:n+1
       Pn(i,1) = y(i); 
    end
    %generate the matrix of polynomials to get the nth order polynomial.
      %Goes to n+1 because there is no 0, index thus the 0th order
      %polynomial (y(i)) is the first index.
      for i =2:n+1,
          for j=2:i,
            Pn(i,j) = ((x-points(i-j+1))*Pn(i,j-1)-(x-points(i))*...
                                    Pn(i-1,j-1))/(points(i)-points(i-j+1));
          end
      end
      
     

    %out put the last element in the matrix (bottom right) as this is the
    % approximation at the highest order polynomial
    out = Pn(n+1,n+1);
end
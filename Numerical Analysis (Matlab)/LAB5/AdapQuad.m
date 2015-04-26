% FILE: AdapQuad.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 4

%This recursive method computes the adaptive quadrature using Simpson's
%method. See page 213 for a discussion of adaptive quadrature. a,b are the
%interval of integration, tol is the tolerance we want the error to be less
%than, f is the function being integrated, points is vector that contains
%the points that have been used to compute the quadrature in all of the
%sub intervals, depth is the current subdivision level, maxDepth is the 
%maximum number of subdivisions allowed. the errorCheck input should
%initial be an empty matrix. It will then add the value of the smallest
%integration performed on each section and will be returned as a new matrix
function [value points errorCheck] = AdapQuad(a,b,tol,f,points,depth,...
                                                       maxDepth,errorCheck)
    h = (b-a)/2;
    c = (a+b)/2;
    points(end+1) = c;
    Sab = (h/3)*(f(a) + f(b) + 4*f(c));
    Sac = (h/6)*(f(a) + f(c) + 4*f((a+c)/2));
    Scb = (h/6)*(f(b) + f(c) + 4*f((b+c)/2));
    %error check
    if( abs( Sab - Sac - Scb ) < 15*tol/(2^depth)),
       %our solution is accurate enough
       value = Sac+Scb;
       points(end+1) = (a+c)/2;
       points(end+1) = (c+b)/2;
       values = [a c Sac];
       values2 = [c b Scb];
       errorCheck = [errorCheck;values;values2];
       return
    % we need to subdivide further to get a more accurate solution
    elseif( depth < maxDepth ),
        depth = depth+1;
        %Recursively call on the left and right sides.
        [sumLeft pointsLeft errorCheck1] =  AdapQuad(a,c,tol,f,points,...
                                                depth,maxDepth,errorCheck);
        [sumRight pointsRight errorCheck2] = AdapQuad(c,b,tol,f,points,...
                                                depth,maxDepth,errorCheck);
        %collect the points evaluated from each to return
        points = union(pointsLeft, pointsRight);
        errorCheck = [errorCheck1 ; errorCheck2];
        %return the sum as the integral over this region (a,b)
        value = sumLeft+sumRight;
        return
    else
        %We have reached max depth without reaching the desired accuracy.
        %display a warning and exit
        warning(['Method reached max depth, ', num2str(maxDepth),...
            ' without reaching desired tolerance of ', num2str(tol)]);
        value = Sab;
        
    end

end
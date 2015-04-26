% FILE: splineNum.m
% AUTHOR: Chris Hoder
% DATE: 9/27/2012
% ENGS 91
% Laboratory 3

% This method will determine the index needed for a given cubic spline
% method. x is the point we are using the cubic spline to interpolate for
% xx is the vector of points used to generate the cubic spline. The
% returned value will the matrix index so that the correct cubic spline
% coefficients can be used to generate the correct cubic for the given x
% value.
function out = splineNum(x,xx),
    for i=1:max(size(xx))-1,
        %we check to see if our point x is greater than the given index yet
        %still less than the next number. We only go up to the second to
        %last point so that there is no index error
        if(x>=xx(i) && x<xx(i+1)),
            out = i;
            return
        end
    end
    % we are in the last cubic spline
    out = i;
end
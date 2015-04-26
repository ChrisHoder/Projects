% FILE: gaussQuad.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 3

%This method will compute the Gaussian Quadrature. x,w are the vector of
%x points and weights respectively defined on the interval (-1,1). The
%method then scales these points onto the given integral interval of (a,b).
%f is the function being integrated.
function out = gaussQuad(a,b,x,w,f)
    out = 0;
    %evaluate each point at the given location and multiply by the weight
    for i=1:max(size(x));
        %scale the point to the correct location
        y = (a+b)/2 + ((b-a)/2)*x(i);
        out = out + f(y)*w(i);
    end
    %an overal scalling factor pops out with the change of variables
    out = out*((b-a)/2);
end
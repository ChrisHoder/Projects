% FILE: SimpsonsRule.m
% AUTHOR: Chris Hoder
% DATE: 10/18/2012
% CLASS: ENGS 91
% LAB 5 QUESTION 4

%this method will compute simposons rule with the following points
%provided. The spacing between the points is assumed to be uniform. This is
%sued to get the error in each interval of simpson's rule that is calulated
%for comparison with the adaptive quadrature rule. The value of the
%integral is also returned.
function [ErrorMatrix value] = simpsonsRule(f,points,type)
    %this will store the error information
    ErrorMatrix = [];
    %initialize variables
    i = 1;
    j = 1;
    h = abs(points(1)-points(2));
    %while there are more points
    while(i < max(size(points))),
        %get the left, right, middle values
        a = points(i);
        c = points(i+1);
        b = points(i+2);
        h = c-a;
        i = i + 2;
        %add them to the error Matrix
        ErrorMatrix(j,1) = a;
        ErrorMatrix(j,2) = b;
        %calculate the simpson's rule intergral over the region
        ErrorMatrix(j,3) = (h/3)*(f(a)+4*f(c)+f(b));
        %we can change this based on part of the question
        if(type == 1),
            %for integral a
            intf = inline('(-x^2-2*x-2)*exp(-x)');
        else
            %for integral b
            intf = inline('(3*x^(4/3))/4');
        end
        %compute the actual integral analytically
        ErrorMatrix(j,4) = (intf(b)-intf(a));
        %compute the absolute error on the interval
        ErrorMatrix(j,5) = abs(ErrorMatrix(j,3) - ErrorMatrix(j,4));
        %compute the error per unit length on the interval
        ErrorMatrix(j,6) = ErrorMatrix(j,5)/(b-a);
        %increase the incerement
        j = j+1;
    end
    %output the value also
    value = sum(ErrorMatrix(:,3));

end
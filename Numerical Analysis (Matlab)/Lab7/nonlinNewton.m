% FILE: nonlinNewton.m
% AUTHOR: Chris Hoder
% DATE: 11/2/2012
% CLASS: ENGS 91
% Problem Set 7, Question 2

% This method completes the nonlinear Newton's method for a initial
% boundary problem ODE. The method takes in the interval [a,b], initial
% conditions [alpha, beta], ratefunction dF2dt, number of steps, maximum
% number of iterations m, and the desired tolerance to have y(b)-beta <
% to and guess the initial guess.
function [y yprime x T zEnd] = nonlinNewton(interval,initialCond,dF2dt,n,...
                                                            m,tol,guess),
    %extract data from the inputs
    a     = interval(1);
    b     = interval(2);
    alpha = initialCond(1);
    beta  = initialCond(2);
    %step size
    h = (b-a)/n;
    %number of iterations
    k = 1;
    %initial guess
    %T = (beta-alpha)/(b-a);
    T(1) = guess;
    
    %while we have not reached the maximum number of interations
    while( k <= m),
        z1o = alpha;
        z2o = T(k);
        [z t] = ABAMPC4(0,b,h,[z1o z2o 0 1],dF2dt,0);
        zEnd(k) = z(end,1);
        error = ( abs(z(end,1) - beta ));
        if( error < tol ),
            y = z(:,1);
            yprime = z(:,2);
            x = t;
            return
        end
        %z(end,3)
        %newton's method to update our guess on the initial point
        T(k+1) = T(k) - (z(end,1)-beta)/z(end,3);
        %update our counter
        k = k + 1;
        %sprintf('Done')
    end
    
    % Method failed to converg on the correct solution
    warning('Maximum number of iterations exceeded'); %#ok<*WNTAG>
    y = z(:,1);
    yprime = z(:,2);
    x = t;
    return



end
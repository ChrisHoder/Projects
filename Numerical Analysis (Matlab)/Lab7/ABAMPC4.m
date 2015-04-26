% FILE: ABAMPC4.m
% AUTHOR: Chris Hoder
% DATE: 10/25/2012
% CLASS: ENGS 91
% LAB 6 QUESTION 3


%adams-bashforth four-step explicit method
% This method computes the solution to a system of 2 equations initial
% value problem ODE using a 4-step Adams predictor-corrector method
% with one correction. The inputs to this method are the intial time
% to, final time tf, step size h, intial values z0, derivative function
% dFdt and the value for the constant a in the derivative
function [z t] = ABAMPC4(to,tf,h,z0,dFdt,a),
	% set intial values
    t(1) = to;
    z(1,1) = z0(1);
    z(1,2) = z0(2);
    %u1
    z(1,3) = z0(3);
    %u2
    z(1,4) = z0(4);
    %the first 3 steps must be computed using an explicit method
    % because the multi-step method are not self starting
    % compute using an Rk4 method
    for i=2:4,
        t(i) = t(i-1)+h;
        K1 = h*dFdt( z(i-1,:)        , t(i-1)        , a);
        K2 = h*dFdt( z(i-1,:) + K1/2 , t(i-1) +  h/2 , a);
        K3 = h*dFdt( z(i-1,:) + K2/2 , t(i-1) +  h/2 , a);
        K4 = h*dFdt( z(i-1,:) + K3   , t(i-1) +  h   , a);
        z(i,1) = z(i-1,1) + (1/6)*(K1(1) + 2*K2(1) + 2*K3(1) + K4(1));
        z(i,2) = z(i-1,2) + (1/6)*(K1(2) + 2*K2(2) + 2*K3(2) + K4(2));
        
        %the derivative calculations
        z(i,3) = z(i-1,3) + (1/6)*(K1(3) + 2*K2(3) + 2*K3(3) + K4(3));
        z(i,4) = z(i-1,4) + (1/6)*(K1(4) + 2*K2(4) + 2*K3(4) + K4(4));
        
    end
    % Now begin the multi-step PC method with one correction
    while( t(i) < tf ),
    	%update time
       i = i + 1;
       t(i) = t(i-1) + h;
       %predict the next point
       f1 = dFdt(z(i-1,:),t(i-1),a);
       f2 = dFdt(z(i-2,:),t(i-2),a);
       f3 = dFdt(z(i-3,:),t(i-3),a);
       f4 = dFdt(z(i-4,:),t(i-4),a);
       %compute our prediction values for wi+1
       w(1) = z(i-1,1) + (h/24)*(55*f1(1)-59*f2(1) + 37*f3(1) - 9*f4(1));
       w(2) = z(i-1,2) + (h/24)*(55*f1(2)-59*f2(2) + 37*f3(2) - 9*f4(2));
       w(3) = z(i-1,3) + (h/24)*(55*f1(3)-59*f2(3) + 37*f3(3) - 9*f4(3));
       w(4) = z(i-1,4) + (h/24)*(55*f1(4)-59*f2(4) + 37*f3(4) - 9*f4(4));
       %correct for wi
       f1 = dFdt(w,t(i-1),a);
       f2 = dFdt(w,t(i-2),a);
       f3 = dFdt(w,t(i-3),a);
       f4 = dFdt(w,t(i-4),a);
       %the points we take
       z(i,1) = z(i-1,1) + (h/24)*(9*f1(1) + 19*f2(1) - 5*f3(1) +f4(1));
       z(i,2) = z(i-1,2) + (h/24)*(9*f1(2) + 19*f2(2) - 5*f3(2) +f4(2));
       %
       z(i,3) = z(i-1,3) + (h/24)*(9*f1(3) + 19*f2(3) - 5*f3(3) +f4(3));   
       z(i,4) = z(i-1,4) + (h/24)*(9*f1(4) + 19*f2(4) - 5*f3(4) +f4(4));   
    end


end
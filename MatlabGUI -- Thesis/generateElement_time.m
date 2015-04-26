% if down == 0 then it is a component of the C(down) derivative
% generates an element of the time dependent matrix
% interestingly this is always purely imaginary ( and can be shown as such)
function [out] = generateElement_time(n,nPrime, eta, wA, phiNot, t,whf,wm,down)

   phi = wA*t + phiNot; % something
   absDifference = abs(n-nPrime);
   value1 = exp(1i*phi)*((1i*eta)^absDifference);
   value2  = exp(-1i*phi)*((1i*eta*-1)^absDifference);
   
   if( down == 0),
        expValue = exp(1i*whf*t)*exp(1i*(nPrime-n)*wm*t);
   else
        expValue = exp(-1i*whf*t)*exp(1i*(nPrime-n)*wm*t);
   end
 
%Modified from Chris's original to be for a cosine pulse 
% Chris original:
%   out = (value1 - value2)*expValue;
%
%My original
%sine pulse
%out = (value1 - value2)/(2*1i)*expValue; 
%cosine pulse
%out = (value1 + value2)/(2)*expValue;
%Fixed version for Chris's code
%sine pulse
%out = (value1 - value2)*expValue; 
%cosine pulse
out = 1i*(value1 + value2)*expValue;
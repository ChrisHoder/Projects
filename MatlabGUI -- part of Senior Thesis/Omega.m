% This is the Omega(t) function called in the generate H matrix
function [out] = Omega(t,Theta,Tp)
   out = Theta/Tp*sech(pi*t/Tp);
end
% This method will take in the time independent matrxi and the time
% dependent H matrix and combine them by multiplying elementwise together
% and multiplying the entire matrix by some overal constants and Omega(t)

function [out] = generate_H(nMax,t,Theta,Tp,Ho,H_t)
    H = zeros(2*nMax+2,2*nMax+2);
    for n = 1:2*nMax+2,
        for nPrime = 1:2*nMax+2,
            H(n,nPrime) = Ho(n,nPrime)*H_t(n,nPrime);
        end
    end
    H = (-1/4)*(1/(1i))*Omega(t,Theta,Tp)*H;
    out = H;
            
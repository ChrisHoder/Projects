% Test function for creating a dummy H for a 4x4 H matrix

function [out] = generateH_test(nMax,t,Theta,Tp,Ho,Ho_t);
    H = zeros(2*nMax+2,2*nMax+2);
    H(1,2) = 1;
    H(2,1) = 1;
    %     for n = 1:2*nMax+2,
%         for nPrime = 1:2*nMax+2,
%             H(n,nPrime) = Ho(n,nPrime)*H_t(n,nPrime);
%         end
%     end
     H = (-1/2)*Omega(t,Theta,Tp)*H;
     out = H;
            
% generate the matrix for the time_dependant matrix

% order assumed to be the following
% columns
% C(down)(0,0), C(down)(0,1)...C(down)(0,n),C(up)(0,0)...C(up)(0,nMax)
% C(down)(1,0).....
%  .
%  .
%  .
% C(down)(nMax,0), ....
% C(up)(0,0),...
%  .
%  .
%  .
% C(up)(nMax,0)...

% this generates the time dependent matrix


function [out] = generate_time_matrix(nMax,eta,wA,phiNot,t, whf,wm)
    %nMax = 10;
    %eta = 0.1;
    time_dep = zeros(2*nMax+2,2*nMax+2);

    for n = 0:nMax,
        for nPrime = 0:nMax,
            time_dep(n+1,nMax+nPrime+2) = generateElement_time(n,nPrime,eta,wA,phiNot, t,whf,wm,0);
            time_dep(nMax+n+2,nPrime+1) = generateElement_time(n,nPrime,eta,wA,phiNot, t, whf,wm,1);
        end
    end
out = time_dep;

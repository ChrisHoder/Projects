% generate the matrix for the time_independant matrix

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


function [out] = generate_noTime_matrix(nMax,eta)
%nMax = 10;
%eta = 0.1;
    time_ind = zeros(2*nMax+2,2*nMax+2);

    
    for n = 0:nMax,
        for nPrime = 0:nMax,
            % C(down) derivatives
            time_ind(n+1,nMax+nPrime+2) = generateElement_NoTime(n,nPrime,eta);
            % C(up) derivatives
            time_ind(nMax+n+2,nPrime+1) = generateElement_NoTime(n,nPrime,eta);
        end
    end
    
    
    
out = time_ind;

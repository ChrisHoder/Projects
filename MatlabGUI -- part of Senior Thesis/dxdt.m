%this creates the derivative based on the derived equations


function dxdt = dxdt(t,x,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp)
    % generate the time dependent component
    Ho_t = generate_time_matrix(nMax,eta,wA,phiNot,t,whf,wm);
    % create the whole H matrix
%    H = generate_H_test(nMax,t,Theta,Tp,Ho,Ho_t);
    H = generate_H(nMax,t,Theta,Tp,Ho,Ho_t);
    % determine the derivatives
    %dxdt = x
    dxdt = -1i*H*x;
    
    
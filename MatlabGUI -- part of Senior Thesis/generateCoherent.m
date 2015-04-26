% this method generates a coherent state in the vibrational energy
% eignestate basis where we are considering 0->nMax (inclusive) states and
% all of the population will be in the down spin state.

function out = generateCoherent(nMax,alpha)
    %generates a coherent state based on the alpha value
    y_init = zeros(2*nMax+2,1)';
    for n = 0:nMax,
       y_init(n+1) = exp(-0.5*abs(alpha)^2)*alpha^n/sqrt(factorial(n));
       %y_init(nMax+2+n) = y_init(n+1);
    end
    
    out = y_init;
% if down == 0 it is a C(down) derivative

% an element in the time-independent matrix for H
function [out] = generateElement_NoTime(n,nPrime,eta)
    nLesser = min([n nPrime]);
    nGreater = max([n nPrime]);
    absDifference = abs(n-nPrime);
    LaguerrePoly = glapoly(nLesser,absDifference,(eta^2));
    value1 = sqrt((factorial(nLesser))/(factorial(nGreater)));
    expValue = exp(-eta^2/2);
    
    
    out = value1*LaguerrePoly*expValue;
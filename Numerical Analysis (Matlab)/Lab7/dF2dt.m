


function F2prime = dF2dt(z,x,a),
    S = 100; % lb/in
    D = 8.8*10^7; % lb in
    L = 50; %in
    q = 1000; % lb/in^2

    z1 = z(1);
    z2 = z(2);
    u1 = z(3);
    u2 = z(4);
    %compute the derivatives and place into the matrix
    F2prime(1) = z2;
    F2prime(2) = ( (S/D)*z2 + (q*x/(2*D))*(x-L)*z1 )*(1+z2^2)^(1.5);

    
    
    %calculate rate function partials
    dfdy = ((q*x)/(2*D))*(x-L)*(1+z2^2)^(1.5);
    dfdyprime = (S/D)*(1+(z2)^2)^(1.5) + ((S/D)*z2 + ((q*x)/(2*D))*(x-L)*z1)*...
                                            (1.5)*(2*z2)*(1+z2^2)^(0.5);
    F2prime(3) = u2;
    F2prime(4) = dfdy*u1 + dfdyprime*u2;
    
    return

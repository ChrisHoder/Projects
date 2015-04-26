function Fprime = dFdt(z,t),
    H = z(1);
    F = z(2);
    a = 10^-2;
    r = 0.75;
    b = 5.0*10^-3;
    m = 0.5;
    Fprime(1) = r*H - a*H*F;
    Fprime(2) = b*H*F - m*F;

end
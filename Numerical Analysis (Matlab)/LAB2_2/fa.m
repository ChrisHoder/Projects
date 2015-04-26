function out = fa(x),
    %out = x*exp(-x^2)+cos(x);
    out = exp(-x^2)-2*x^2*exp(-x^2)-sin(x);
end
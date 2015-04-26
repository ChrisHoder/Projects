function [A, b] = buildTriDiagonal(n,h,x, p,q,r, inits),
    A = zeros(n,n);
    b = zeros(n,1);
    for i=1:1:n,
        A(i,i) = 2+h^2*q(x(i));
        if( (i-1)> 0)
            A(i,i-1) = -1-(h/2)*p(x(i));
        end
        if( (i+1) <= n)
            A(i,i+1) = -1+(h/2)*p(x(i));
        end
        b(i) = -h^2*r(x(i));
        if( i == 1),
            b(i) = b(i) + (1+(h/2)*p(x(i)))*inits(1);
        elseif( i == n)
            b(i) = b(i) + (1 -(h/2)*p(x(i)))*inits(2);
        end
        
    end
    return
end
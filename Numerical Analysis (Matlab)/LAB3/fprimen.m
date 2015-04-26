%derivative calculator for 1b)

function output = fprimen(x,n),
    if( n== 0),
        output = f(x);
        return
    elseif( n==1),
        output = 10+f(x)-10*exp(x)*sin(10*x);
        return
    end
    ddx(1) = f(x);
    ddx(2) = 10+f(x)-10*exp(x)*sin(10*x);
    ddx2(1) = g(x);
    for i = 3:n+1,
        temp = 0;
        for j = 1:i-2,
            temp = temp + ddx(j);
        end
        temp = temp*(-100);
        ddx(i) = temp+ddx(i-1)-10*exp(x)*sin(x);
    
    end

    output = ddx(end);
end
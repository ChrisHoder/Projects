    m = 0
    l = 100
    r = 1

    overalcoef = exp(-r^2*0.5)*(1/(sqrt(factorial(m))*sqrt(factorial(l))))*((1i*r)^(l+m));
    overalValue = 0;
    temp = 0;
    temp5 = 0;
    %temp6 = 0;
    %value = 0;
    for k = 0:l,
        value1 = nchoosek(l,k)*(-1)^k*((1/r^2)^(2*k));
        for j=0:(m),
            for p=0:j,
                for v=0:p,
                    if( (k-1) < j),
                        temp2 = (factorial(j))/(factorial(j-k+1));
                        temp3 = (1+v)^(j-k+1);
                        temp4 = ((-1)^v)*nchoosek(p,v)*(1/(p+1));
                        temp = temp4*temp3*temp2;
                        j
                        p
                        v
                        k
                    else
                        temp = 0;
                    end 
                end
            end
            temp5 = temp*nchoosek(m,j)
        end
        temp6 = temp5*value1
        overalValue = overalValue + temp6
    end
    %overalValue*overalcoef
    overalValue
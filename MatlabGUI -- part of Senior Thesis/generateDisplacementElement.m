function out = generateDisplacementElement(L,m,r),
    overalcoef = exp(-r^2*0.5)*(1/(sqrt(factorial(m))*sqrt(factorial(L))))*((1i*r)^(L+m));
    overalValue = 0;
    temp = 0;
    temp5 = 0;
    %temp6 = 0;
    %value = 0;
    for k = 0:L,
        value1 = nchoosek(L,k)*(-1)^k*((1/(r^2))^(2*k));
        %boundary case, when m = 0
        if(m == 0),
            if( k == 0),
                temp5 = 1;
            else
                temp5 = 0;
            end
        else
        %all other cases
            for j=0:(m-1),
                for p=0:j,
                    for v=0:p,
                        if( (k-1) <= j),
                            temp2 = (factorial(j))/(factorial(j-k+1));
                            temp3 = (1+v)^(j-k+1);
                            temp4 = ((-1)^v)*nchoosek(p,v)*(1/(p+1));
                            temp = temp4*temp3*temp2;
                        else
                            temp = 0;
                        end 
                    end
                end
                temp5 = temp*nchoosek(m,j);
            end
        end
        temp6 = temp5*value1;
        overalValue = overalValue + temp6;
    end
out = overalcoef*overalValue;
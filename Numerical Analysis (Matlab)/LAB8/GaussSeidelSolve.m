function [x] = GaussSeidelSolve(n,A,b,x_initial,T,maxIter,tol),
    k = 2;
    x(:,1) = x_initial;
    
    while( k < maxIter),
       for i=1:1:n,
           sum1 = 0;
           sum2 = 0;
           for j = 1:1:i-1,
                sum1 = sum1 + A(i,j)*x(j,k);
           end
           for j = i+1:1:n,
                sum2 = sum2 + A(i,j)*x(j,k-1);
           end
           x(i,k) = (b(i) - sum1 - sum2)/A(i,i);
       end
       %relative error stopping criteria using L_infinity
       error = max(abs(x(:,k)- T(:)))/max(abs(x(:,k)));
       if( error < tol ),
           return
       end
       
       k = k+1; 
    end
    warning('Did not converge!');

end
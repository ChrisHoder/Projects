function [L U x] = croutFact(n,A,b),
    %combine to augmented matrix
    A = [A b];
    L(1,1) = A(1,1);
    U(1,2) = A(1,2)/L(1,1);
    x(1) = A(1,n+1)/L(1,1);
    
    for i = 2:1:n-1,
       L(i,i-1) = A(i,i-1); %ith row  of L
       L(i,i)   = A(i,i) - L(i,i-1)*U(i-1,i);
       U(i,i+1) = A(i,i+1)/L(i,i); %ith column of U
       x(i) = (A(i,n+1)-L(i,i-1)*x(i-1))/L(i,i);
    end

    L(n,n-1) = A(n,n-1); %nth row of L
    L(n,n)   = A(n,n) - L(n,n-1)*U(n-1,n);
    x(n)     = (A(n,n+1)-L(n,n-1)*x(n-1))/L(n,n);
    
    for i = n-1:-1:1,
       x(i) = x(i)-U(i,i+1)*x(i+1); 
    end
    
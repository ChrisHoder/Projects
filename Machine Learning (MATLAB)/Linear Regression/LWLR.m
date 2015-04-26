function theta = LWLR(x,X,y,tau)
    [m, n] = size(X);
    B = [ones(m,1)  X];
 
   
    W = zeros(m,m);
    for i=1:m,
        W(i,i) = wi(x,X,i,tau);
    end
    W = W/(trace(W));
    A = B'*W*B;
    b = B'*W*y;
    theta = A\b;
    
end
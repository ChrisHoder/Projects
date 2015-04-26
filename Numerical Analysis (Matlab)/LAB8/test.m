%test
clc;clear
L = 1;
a = 0;
b = a+L;
n = 159;
% n = [5,10,20,40,80,160];
h = (b-a)/n;
Tc = 37;
Ts = 32;
Ta = Tc;
lambda = 2.7;
inits = [(Tc-Ta) (Ts-Ta)];
for i=1:1:n,
    x(i) = a+i*h;
    y(i) = (Ts-Tc)*(sinh(lambda*x(i))/sinh(lambda*L));
end

[A,b] = buildTriDiagonal(n,h,x,inline('0'),inline('2.7^2'),...
                                                        inline('0'),inits);

[L U T] = croutFact(n, A, b);
plot(x,T,x,y)

'done'

%calculate the error
error = zeros(n,1);
for i = 1:1:n,
    error(i,1) = abs(y(i)-T(i));
end
figure
semilogy(x,error)

'Max error'
max(error)
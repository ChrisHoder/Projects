nMax = 10;
mMax = 5;
eta = 0.1;
phiNot = pi/2;
alpha = pi/10;
theta = pi;
%dList2 = createDList(mMax,eta,nMax);
values = zeros(2*nMax+2,1);

%y_init = zeros(2*nMax+2,1);
%y_init(1) = 1.0;
y_init = generateCoherent(nMax,alpha);
sum(abs(y_init).^2)
result = UtoOperator(y_init,values,nMax,mMax,phiNot,theta,dList2);
sum(abs(result).^2)


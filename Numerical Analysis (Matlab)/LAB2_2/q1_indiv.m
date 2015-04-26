%% old code
%loglog(error1(1:end-2),error1(2:end-1),'.--m',...
%   error2(1:end-2),error2(2:end-1),'-.or',error3(1:end-2),error3(2:end-1),'-sb');
% axis([10^-16 1 10^-16 1])
% legend('Newton''s','Seacant','modified Newton''s');
% xlabel('|\epsilon_{n-1}|');
% ylabel('|\epsilon_n|');
% grid on
% alpha4 = (log10(error1(end-2))-log10(error1(end-3)))/(log10(error1(end-3))-log10(error1(end-4)))

%fprime = inline('2*(x*exp(-x^2)+cos(x))*(exp(-x^2)-2*x*exp(-x^2)-sin(x))');
%fprime2 = inline(['2*(x*exp(-x^2)+cos(x))*(-exp(-x^2)*',...
%   '(-4*x^3+exp(-x^2)*cos(x)+6*x))+2*(exp(-x^2)-2*x*exp(-x^2)-sin(x))^2']);

%% Newton's method for 1 a)

clear
f = inline('x*exp(-x^2)+cos(x)');
fprime = inline('exp(-x^2)-2*(x^2)*exp(-x^2)-sin(x)');
fprime2 = inline('-exp(-x^2)*(-4*x^3+exp(x^2)*cos(x)+6*x)');
fprime3 = inline('exp(-x^2)*(-8*x^4+24*x^2+exp(x^2)*sin(x)-6)');
Po = -1;
P1 = -2;
tol = 10^-60;
nMax = 100;
Pn1 = newtonsM(f, fprime, Po, tol, nMax);
%generate the error, e = |Pn-P|
%take last point as our end point
p = Pn1(end,2);
error1 = abs( Pn1(:,2) - p);
%calculate lambda
%lambda = .5*((-2*f(p)*(fprime2(p)^2)+f(p)*fprime3(p)*fprime(p)+(fprime(p)^2)*fprime2(p))/(fprime(p)^3));
lambda = .5*(((fprime(p)^2)*fprime2(p))/(fprime(p)^3));
%this should match |lambda|(epsilon_n)^2
calcError = abs(lambda)*error1(2:end-1).^2

%plot log(e_n) = log(lambda) + alpha*log(e_n-1)
% we should see that alpha = 2 in a loglog plot
%loglog(error1(1:end-2),error1(2:end-1),error1(1:end-2),calcError)
% this plot should go to linear and converge to lambda
%loglog(error1(2:end-1)/(error1(1:end-2).^2));
%this should have a slope of 2
loglog(error1(1:end-2),error1(2:end-1));
grid on


%% seacant method for 1 a)
clear
f = inline('x*exp(-x^2)+cos(x)');
fprime = inline('exp(-x^2)-2*x^2*exp(-x^2)-sin(x)');
fprime2 = inline('-exp(-x^2)*(-4*x^3+exp(x^2)*cos(x)+6*x)');
fprime3 = inline('exp(-x^2)*(-8*x^4+24*x^2+exp(x^2)*sin(x)-6)');
Po = -1;
P1 = -2;
tol = 10^-50;
nMax = 100;

Pn2 = seacantM(f, Po, P1, tol, nMax);
error2 = abs(Pn2(:,2) - Pn2(end,2));
p = Pn2(end,2);
lambda = .5*(((fprime(p)^2)*fprime2(p))/(fprime(p)^3));
calcError = abs(lambda)*error2(2:end-1).^2
%loglog(error2(1:end-1),error2(2:end),error2(1:end-2),calcError)
loglog(error2(1:end-2),error2(2:end-1));
grid on


%% modified newton's method for 1 a)
clear
f = inline('x*exp(-x^2)+cos(x)');
fprime = inline('exp(-x^2)-2*x^2*exp(-x^2)-sin(x)');
fprime2 = inline('-exp(-x^2)*(-4*x^3+exp(x^2)*cos(x)+6*x)');
fprime3 = inline('exp(-x^2)*(-8*x^4+24*x^2+exp(x^2)*sin(x)-6)');
Po = -1;
P1 = -2;
tol = 10^-50;
nMax = 100;
Pn3  = modNewton(f,fprime, fprime2,Po,tol,nMax);
p = Pn3(end,2);
error3 = abs( Pn3(:,2) - p);
loglog(error3(1:end-1),error3(2:end));


%loglog(error1(2:end-1),error1(1:end-2),error2(1:end-1),error2(2:end),error3(1:end-1),error3(2:end));
grid on

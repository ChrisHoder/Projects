%Run the differential equation solver

nMax = 10;
eta = 0.1;
wA = 1;
phiNot = 0;
alpha = pi/4;
y_init = generateCoherent(nMax,alpha);
y_approx = zeros(2*nMax+2,1);
y_init(1) = 1.0 
%y_init = [1,0,0,0];
wm = 2*pi/100000;
whf = 2*pi;

Theta = pi/2; %pulse area
Tp = 0.2; %pulse width
Ho = generate_noTime_Matrix(nMax,eta);
timeInt = [-5*Tp,5*Tp];

tic
%profile on
[t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',.002));
%profile viewer
toc
%subplot(2,1,1)
%plot(t,(abs(y)).^2)
%abs(y).^2
%subplot(2,1,2)
%plot(abs(y(end,:)).^2)

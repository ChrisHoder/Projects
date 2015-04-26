% This will generate H based on the follwoing values and print them out to
% the command line

nMax = 2;
y_init = zeros(2*nMax+2,1);
y_approx = zeros(2*nMax+2,1);
y_init(1) = 1.0 
%y_init = [1,0,0,0];

% Parameters of the atom and trap
eta = 0.1;
wm = pi/30;
whf = pi;

%Pulse Parameters
Theta = 10*pi
Tp = 0.2
phiNot = 0;
wA = 1;

Ho = generate_noTime_Matrix(nMax,eta)

timeInt = [-5*Tp,5*Tp];
t = 0;

Ho_t = generate_time_matrix(nMax,eta,wA,phiNot,t,whf,wm)

H = generate_H(nMax,t,Theta,Tp,Ho,Ho_t)
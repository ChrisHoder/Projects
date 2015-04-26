nMax = 10;
eta = 0.1;
wA = 1;
phiNot = 0;
alpha = pi/4;

for i = 0:150,
    nMax = i;
    tic
    y_init = generateCoherent(nMax,alpha);
    nMaxValuesGC(i+1,1) = toc;
    nMaxValuesGC(i+1,2) = nMax;
    nMaxValuesGC(i+1,3) = alpha;
    
end
% 
% for i = 0:150,
%     nMax = i;
% 
%     tic
%     Ho = generate_noTime_Matrix(nMax,eta);
%     noTimeMatrixValues(i+1,1) = toc;
%     noTimeMatrixValues(i+1,2) = nMax;
%     noTimeMatrixValues(i+1,3) = eta;
% end
% 
% whf = 2*pi;
% wm = 2*pi/10000;
% Tp = 0.2;
% Ho = generate_noTime_matrix(nMax,eta);
% Theta = pi/2;
% x = generateCoherent(nMax,alpha);
% t = 1;
% 
% for i=0:50,
%     nMax = i;
%     Ho = generate_noTime_matrix(nMax,eta);
%     x = generateCoherent(nMax,alpha)';
%     tic
%     dxdt(t,x,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp);
%     dxdtTime(i+1,1) = toc;
%     dxdtTime(i+1,2) = nMax;
% end
% 
% for i=0:150,
%     nMax = i;
%     tic
%     generateElement_NoTime(0,i,eta);
%     gENoTime(i+1,1) = toc;
%     gENoTime(i+1,2) = nMax;
% end
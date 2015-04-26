% FILE: compile.m
% AUTHOR: Chris Hoder
% DATE: 9/23/2012
% ENGS 91 LAB 2

% This script will calculate all of the data and display the proper figures
% for questions 1 a), b) and 3. The code uses Cell Mode to only do certain
% parts of the code at a time.

% part 1 a) all of them together
clc
clear
f = inline('x*exp(-x^2)+cos(x)');
fprime = inline('exp(-x^2)-2*(x^2)*exp(-x^2)-sin(x)');
fprime2 = inline('-exp(-x^2)*(-4*x^3+exp(x^2)*cos(x)+6*x)');
fprime3 = inline('exp(-x^2)*(-8*x^4+24*x^2+exp(x^2)*sin(x)-6)');
Po = -1;
P1 = -2;
tol = 10^-60;
nMax = 100;

%Gather the data
Pn1 = newtonsM(f,fprime, Po, tol, nMax);
error1 = abs(Pn1(:,2)-Pn1(end,2));
%get iteration steps, subtract 1 to take out input point
'Number of iterations for Newton''s Method for 1 a)'
max(size(Pn1))-1

%print root
'Root p = '
vpa(Pn1(end,2),20)

%test for the alpha value using formula written in report
alpha = (log10(error1(end-2))-log10(error1(end-3)))/...
                                (log10(error1(end-3))-log10(error1(end-4)))

Pn2 = seacantM(f, Po, P1, tol, nMax);
error2 = abs(Pn2(:,2)-Pn2(end,2));
%get iteration steps, subtract 1 to take out input point
'Number of iterations for Seacant Method for 1 a)'
max(size(Pn2))-1

%test for the alpha value using formula written in report
alpha = (log10(error2(end-2))-log10(error2(end-3)))/...
                                (log10(error2(end-3))-log10(error2(end-4)))
%print root
'Root p = '
vpa(Pn2(end,2),20)

Pn3 = modNewton(f, fprime, fprime2, Po, tol, nMax);
error3 = abs(Pn3(:,2)-Pn3(end,2));
%get iteration steps, subtract 1 to take out input point
'Number of iterations for Modified Newton''s Method for 1 a)'
max(size(Pn3))-1

%test for the alpha value using formula written in report
alpha = (log10(error3(end-2))-log10(error3(end-3)))/...
                                (log10(error3(end-3))-log10(error3(end-4)))
 
%print root
'Root p = '
vpa(Pn3(end,2),20)
                            
%%  plot vs. iteration number

% I have to add 1 because my code indexes off of zero, so the first
% iteration is 0 not 1

subplot(2,2,1);
semilogy(Pn1(:,1)+1,error1,'.--m');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title('Error vs. Iteration number for Newton''s Method');
grid on

subplot(2,2,2);
semilogy(Pn2(:,1)+1,error2,'.--m');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title('Error vs. Iteration number for Seacant Method');
grid on

subplot(2,2,3);
semilogy(Pn3(:,1)+1,error3,'.--m');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title('Error vs. Iteration number for Modified Newton''s Method');
grid on

%% plot e_n-1 vs e_n
subplot(2,2,1)
loglog(error1(1:end-2),error1(2:end-1),'.--m');
%legend('\epsilon_{n-1} vs \epsilon_n');
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title('Error for Newton''s Method');
grid on;

subplot(2,2,2)
loglog(error2(1:end-2),error2(2:end-1),'-.or');
%legend('\epsilon_{n-1} vs \epsilon_n');
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title('Error for Seacant Method');
grid on;

subplot(2,2,3);
loglog(error3(1:end-2),error3(2:end-1),'-sb');
%legend('\epsilon_{n-1} vs \epsilon_n');
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title('Error for Modified Newton''s Method');
grid on;

%% Part 1 b)
clc
clear
f = inline('(x*exp(-x^2)+cos(x))^2');
fprime = inline(['-2*exp(-2*x^2)*(2*x^2+exp(x^2)*sin(x)-1)*',...
                                                   '(exp(x^2)*cos(x)+x)']);
fprime2 = inline(['2*exp(-2*x^2)*((2*x^2+exp(x^2)*sin(x)-1)^2',...
                    '-(exp(x^2)*cos(x)+x)*(-4*x^3+exp(x^2)*cos(x)+6*x))']);
Po = -1.5;
P1 = -1.75;
tol = 10^-50;
nMax = 1000;

% Tabulate Data

Pn4 = newtonsM(f,fprime, Po, tol, nMax);
error4 = abs(Pn4(:,2)-Pn4(end,2));
%get iteration steps, subtract 1 to take out input point
'Number of iterations for Newton''s Method for 1 b)'
max(size(Pn4))-1

%test for the alpha value using formula written in report
alpha = (log10(error4(end-3))-log10(error4(end-4)))/...
                                (log10(error4(end-4))-log10(error4(end-5)))
alpha2 = (log10(error4(end-2))-log10(error4(end-3)))/...
                                (log10(error4(end-3))-log10(error4(end-4)))
'average'
(alpha+alpha2)/2

%print root
'Root p = '
vpa(Pn4(end,2),20)

PnHat1 = AitkenM(Pn4(:,2),tol);
errorH1 = abs(PnHat1(:,1)-PnHat1(end,1));
%get iteration steps
['Number of iterations for Aitken''s Method on',...
                                      ' Newton''s Method output for 1 b)']
max(size(PnHat1))

%due to variation in the graph at close to machine level i spread the two
%points out a bit further but this still follows the same derived formula
alpha2 = (log10(error4(21))-log10(error4(15)))/...
                                (log10(error4(20))-log10(error4(16)))

%print root
'Root p = '
vpa(PnHat1(end,1),20)

Pn5 = seacantM(f, Po, P1, tol, nMax);
error5 = abs(Pn5(:,2)-Pn5(end,2));
%get iteration steps, subtract 1 to take out input point
'Number of iterations for Seacant Method for 1 b)'
max(size(Pn5))-1
%test for the alpha value using formula written in report
alpha = (log10(error5(end-22))-log10(error5(end-23)))/...
                             (log10(error5(end-23))-log10(error5(end-24)))
%print root
'Root p = '
vpa(Pn5(end,2),20)
                         
                         
PnHat2 = AitkenM(Pn5(:,2),tol);
errorH2 = abs(PnHat2(:,1)-PnHat2(end,1));
%get iteration steps
['Number of iterations for Aitken''s Method',...
                                     ' on Seacant Method output for 1 b)']
max(size(PnHat2))

%test for the alpha value using formula written in report
alpha = (log10(errorH2(end-6))-log10(errorH2(end-7)))/...
                            (log10(errorH2(end-7))-log10(errorH2(end-8)))

%print root
'Root p = '
vpa(PnHat2(end,1),20)                        
                        
                        
Pn6 = modNewton(f, fprime, fprime2, Po, tol, nMax);
error6 = abs(Pn6(:,2)-Pn6(end,2));
%get iteration steps, subtract 1 to take out input point
'Number of iterations for Modified Newton''s Method for 1 b)'
max(size(Pn6))-1

%test for the alpha value using formula written in report
alpha = (log10(error6(end-2))-log10(error6(end-3)))/...
                                (log10(error6(end-3))-log10(error6(end-4)))

%print root
'Root p = '
vpa(Pn6(end,2),20)

%%  plot vs. iteration number

% I have to add 1 because my code indexes off of zero, so the first
% iteration is 0 not 1, except for with Aitken's Delta^2 method

subplot(3,2,1);
semilogy(Pn4(:,1)+1,error4,'.--m');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title('Error vs. Iteration number for Newton''s Method');
grid on

subplot(3,2,2);
semilogy(PnHat1(:,3),errorH1,'.--m');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title(['Error vs Iteration number for Aitken''s \Delta^2',...
                            ' method on the output of Newton''s Method']);
grid on;

subplot(3,2,3);
semilogy(Pn5(:,1)+1,error5,'.--m');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title('Error vs. Iteration number for Seacant Method');
grid on


subplot(3,2,4);
semilogy(PnHat2(:,3),errorH2,'.--m');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title(['Error vs Iteration number for Aitken''s \Delta^2',...   
                        'method on the output of the seacant Method']);
grid on;



subplot(3,2,5);
semilogy(Pn6(:,1)+1,error6,'.--m');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title('Error vs. Iteration number for Modified Newton''s Method');
grid on

%% all together
subplot(1,2,1);
semilogy(Pn4(:,1)+1,error4,'.--m', PnHat1(:,3),errorH1,'.:b');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
legend('Newton''s Method','Aitken''s \Delta^2 on Newton''s Method points');
title(['Comparison of Newton''s Method and Aitken''s \Delta^2 Method on',...
           'Newton''s Method Points']);

subplot(1,2,2);
semilogy(Pn5(:,1)+1,error5,'.--m', PnHat2(:,3),errorH2,'.:b');
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
legend('Seacant Method','Aitken''s \Delta^2 on Seacant Method points');
title(['Comparison of Seacant Method and Aitken''s \Delta^2 Method on',...
           'Seacant Method Points']);

%subplot(2,2,3:4);
%semilogy(

%% plot e_n-1 vs e_n
axis([10^-16 1 10^-16 1])

subplot(3,2,1);
loglog(error4(1:end-2),error4(2:end-1),'.--m');
%legend('\epsilon_{n-1} vs \epsilon_n');
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title('Error for Newton''s Method');
grid on

subplot(3,2,2);
loglog(errorH1(1:end-2),errorH1(2:end-1),'.--m');
%legend('\epsilon_{n-1} vs \epsilon_n');
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title(['Error for Aitken''s \Delta^2 method with the result from',...
                                        ' Newton''s Method']);
grid on                                 

subplot(3,2,3);
loglog(error5(1:end-2),error5(2:end-1),'-.or');
%legend('\epsilon_{n-1} vs \epsilon_n');
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title('Error for Seacant Method');
grid on

subplot(3,2,4);
loglog(errorH2(1:end-2),errorH2(2:end-1),'-sb');
%legend('\epsilon_{n-1} vs \epsilon_n');
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title(['Error for Aikten''s \Delta^2 method with the result from',...
                            ' the Seacant Method']);
grid on

subplot(3,2,5:6);
loglog(error6(1:end-2),error6(2:end-1),'-.sb');
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title('Error for Modified Newton''s Method');
grid on

%% A figure with all data in it
% cla
% loglog(error4(1:end-2),error4(2:end-1),'-.or', errorH(1:end-2),...
%         errorH(2:end-1),'-sb',error5(1:end-2),error5(2:end-1),'--xg',...
%         error6(1:end-2),error6(2:end-1),'-..k');

%% Question 3
clc
clear;
%generate data points
[thetaN,i,errorConv] = newtonSys([30*pi/180 0],10^-60,100);

%calculate the new error point where we take the point, p that makes f(p)=0
%to be the last points from our iteration, i.e. thetaN(end,1)
for i =1:max(size(thetaN)),
    
    error(i) = sqrt((thetaN(i,1)-thetaN(end,1))^2+(thetaN(i,2)...
                                                        -thetaN(end,2))^2);
end

%plot the data

subplot(1,2,1);
semilogy(1:1:i,error);
grid on
xlabel('Iteration Number');
ylabel('|\epsilon_n|');
title('Error vs. Iteration number for Newton''s Method');

subplot(1,2,2);
loglog(error(1:end-1),error(2:end));
xlabel('|\epsilon_{n-1}|');
ylabel('|\epsilon_n|');
title('Error for Modified Newton''s Method');
grid on;

%print number of iterations (assuming it will be more than 2 steps
'Iteration steps'
max(size(thetaN))-1

%calculate some alpha values to determine what the convergence rate is
alpha2 =(log10(error(6))-log10(error(5)))/(log10(error(5))-log10(error(4)))

'Root theta1, theta2'
vpa(thetaN(end,1),20)
vpa(thetaN(end,2),20)

grid(gca,'minor')
%axis square

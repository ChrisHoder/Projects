%script to plot results from the RBF results files
load('Spline_Results.mat');
load('Gauss_Results.mat');

for i=1:12
precip(i,1:3) = [Gauss{1,i+1},Gauss{3,i+1}];
precip2(i,1:3) = [Spline{1,i+1},Spline{3,i+1}];
no_precip(i,1:3) = [Gauss{1,i+1},Gauss{4,i+1}];
no_precip2(i,1:3) = [Spline{1,i+1},Spline{4,i+1}];
err(i,1:3) = [Gauss{1,i+1},Gauss{5,i+1}];
err2(i,1:3) = [Spline{1,i+1},Spline{5,i+1}];
end

%Precipitation error for gaussian and thin-plate spline, 100,500 and
%1000 nodes in hidden layer and all time intervals
figure; subplot(1,2,1);
plot3(precip(1:3,1),precip(1:3,2),precip(1:3,3),'o-'); hold all;
plot3(precip(4:6,1),precip(4:6,2),precip(4:6,3),'o-'); hold all;
plot3(precip(7:9,1),precip(7:9,2),precip(7:9,3),'o-'); hold all;
plot3(precip(10:12,1),precip(10:12,2),precip(10:12,3),'o-'); hold all;
plot3(precip([1,4,7,10],1),precip([1,4,7,10],2),precip([1,4,7,10],3),'o-'); hold all;
plot3(precip([2,5,8,11],1),precip([2,5,8,11],2),precip([2,5,8,11],3),'o-'); hold all;
plot3(precip([3,6,9,12],1),precip([3,6,9,12],2),precip([3,6,9,12],3),'o-'); hold all;
xlabel('Prediction Time');
ylabel('Number of Nodes');
zlabel('Precipitation Error');
title('Gaussian RBF Neural Network');
grid on;

subplot(1,2,2);
plot3(precip2(1:3,1),precip2(1:3,2),precip2(1:3,3),'o-'); hold all;
plot3(precip2(4:6,1),precip2(4:6,2),precip2(4:6,3),'o-'); hold all;
plot3(precip2(7:9,1),precip2(7:9,2),precip2(7:9,3),'o-'); hold all;
plot3(precip2(10:12,1),precip2(10:12,2),precip2(10:12,3),'o-'); hold all;
plot3(precip2([1,4,7,10],1),precip2([1,4,7,10],2),precip2([1,4,7,10],3),'o-'); hold all;
plot3(precip2([2,5,8,11],1),precip2([2,5,8,11],2),precip2([2,5,8,11],3),'o-'); hold all;
plot3(precip2([3,6,9,12],1),precip2([3,6,9,12],2),precip2([3,6,9,12],3),'o-'); hold all;
xlabel('Prediction Time');
ylabel('Number of Nodes');
zlabel('Precipitation Error');
title('Thin-Plate Spline RBF Neural Network');
grid on;

%Non-precipitation error for gaussian and thin-plate spline, 100,500 and
%1000 nodes in hidden layer and all time intervals
figure; subplot(1,2,1);
plot3(no_precip(1:3,1),no_precip(1:3,2),no_precip(1:3,3),'o-'); hold all;
plot3(no_precip(4:6,1),no_precip(4:6,2),no_precip(4:6,3),'o-'); hold all;
plot3(no_precip(7:9,1),no_precip(7:9,2),no_precip(7:9,3),'o-'); hold all;
plot3(no_precip(10:12,1),no_precip(10:12,2),no_precip(10:12,3),'o-'); hold all;
plot3(no_precip([1,4,7,10],1),no_precip([1,4,7,10],2),no_precip([1,4,7,10],3),'o-'); hold all;
plot3(no_precip([2,5,8,11],1),no_precip([2,5,8,11],2),no_precip([2,5,8,11],3),'o-'); hold all;
plot3(no_precip([3,6,9,12],1),no_precip([3,6,9,12],2),no_precip([3,6,9,12],3),'o-'); hold all;
xlabel('Prediction Time');
ylabel('Number of Nodes');
zlabel('Non-Precipitation Error');
title('Gaussian RBF Neural Network');
grid on;

subplot(1,2,2);
plot3(no_precip2(1:3,1),no_precip2(1:3,2),no_precip2(1:3,3),'o-'); hold all;
plot3(no_precip2(4:6,1),no_precip2(4:6,2),no_precip2(4:6,3),'o-'); hold all;
plot3(no_precip2(7:9,1),no_precip2(7:9,2),no_precip2(7:9,3),'o-'); hold all;
plot3(no_precip2(10:12,1),no_precip2(10:12,2),no_precip2(10:12,3),'o-'); hold all;
plot3(no_precip2([1,4,7,10],1),no_precip2([1,4,7,10],2),no_precip2([1,4,7,10],3),'o-'); hold all;
plot3(no_precip2([2,5,8,11],1),no_precip2([2,5,8,11],2),no_precip2([2,5,8,11],3),'o-'); hold all;
plot3(no_precip2([3,6,9,12],1),no_precip2([3,6,9,12],2),no_precip2([3,6,9,12],3),'o-'); hold all;
xlabel('Prediction Time');
ylabel('Number of Nodes');
zlabel('Non-Precipitation Error');
title('Thin-Plate Spline RBF Neural Network');
grid on;

%Total error for gaussian and thin-plate spline, 100,500 and 1000 nodes in
%hidden layer and all time intervals
figure; subplot(1,2,1);
plot3(err(1:3,1),err(1:3,2),err(1:3,3),'o-'); hold all;
plot3(err(4:6,1),err(4:6,2),err(4:6,3),'o-'); hold all;
plot3(err(7:9,1),err(7:9,2),err(7:9,3),'o-'); hold all;
plot3(err(10:12,1),err(10:12,2),err(10:12,3),'o-'); hold all;
plot3(err([1,4,7,10],1),err([1,4,7,10],2),err([1,4,7,10],3),'o-'); hold all;
plot3(err([2,5,8,11],1),err([2,5,8,11],2),err([2,5,8,11],3),'o-'); hold all;
plot3(err([3,6,9,12],1),err([3,6,9,12],2),err([3,6,9,12],3),'o-'); hold all;
xlabel('Prediction Time');
ylabel('Number of Nodes');
zlabel('Total Error');
title('Gaussian RBF Neural Network');
grid on;

subplot(1,2,2);
plot3(err2(1:3,1),err2(1:3,2),err2(1:3,3),'o-'); hold all;
plot3(err2(4:6,1),err2(4:6,2),err2(4:6,3),'o-'); hold all;
plot3(err2(7:9,1),err2(7:9,2),err2(7:9,3),'o-'); hold all;
plot3(err2(10:12,1),err2(10:12,2),err2(10:12,3),'o-'); hold all;
plot3(err2([1,4,7,10],1),err2([1,4,7,10],2),err2([1,4,7,10],3),'o-'); hold all;
plot3(err2([2,5,8,11],1),err2([2,5,8,11],2),err2([2,5,8,11],3),'o-'); hold all;
plot3(err2([3,6,9,12],1),err2([3,6,9,12],2),err2([3,6,9,12],3),'o-'); hold all;
xlabel('Prediction Time');
ylabel('Number of Nodes');
zlabel('Total Error');
title('Thin-Plate Spline RBF Neural Network');
grid on;

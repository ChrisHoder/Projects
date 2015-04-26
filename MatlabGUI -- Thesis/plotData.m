% This code can be used to plot the data that has been output by the
% PulseSim GUI. Basically have the final state be a column of the file and
% then it will plot the magnitude square of the values

[filename, pathname] = uigetfile('*','select file');
data_read = dlmread([pathname,filename]);
plot(data_read(1:end,1),abs(data_read(1:end,2:end)).^2);
%semilogy(data_read(1:end,1),abs(data_read(1:end,2:end)).^2);
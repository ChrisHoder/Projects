%[filename, pathname] = uigetfile('*','select file');
data_read = dlmread([pathname,filename]);
dataNorm = data_read(:,2)/max(data_read(:,2));

ind = find(data_read(:,2),1,'last');
plot(data_read(1:ind,1),dataNorm(1:ind));
axis([0 (ind+5) 0 1.1])
xlabel('Time (s)');
ylabel('Power');

hold on
plot(1:35,.98,'.r')
hold off
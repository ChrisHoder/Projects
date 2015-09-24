%script to calculate error of RBF prediction given an output from RBF of
%the 12 different predictions for four time intervals and three hidden
%layer sizes.
res = {};
res{1,1} = '[Time,Nodes]';           res{2,1} = 'Predictions';
res{3,1} = 'Precip Err';             res{4,1} = 'Non-Precip Err';
res{5,1} = 'Total Err';

for k=1:12
    res{1,k+1} = labels{k};
    res{2,k+1} = results{k};
end

test = {y6test,y6test,y6test,y12test,y12test,y12test,y18test,y18test,y18test,y24test,y24test,y24test};

%loop to calculate error for each rbf prediction based on the significance
%value of precipitation is > .1 inches
for i=1:12
    y_pred = res{2,i+1};
    leng = length(y_pred);
    real = zeros(leng,1);
    comp = zeros(leng,1);
    ttt = test{i};
    real(ttt > .1) = 1;
    comp(y_pred > .1) = 1;
    real_ind = find(real==1);        comp_ind = find(comp==1);
    realno_ind = find(real==0);      compno_ind = find(comp==0);
    precip_err = length(find(~ismember(real_ind,comp_ind)))/length(real_ind);
    non_err = length(find(~ismember(realno_ind,compno_ind)))/length(realno_ind);
    res{3,i+1} = precip_err;
    res{4,i+1} = non_err;
    res{5,i+1} = length(find(comp~=real))/leng;
end


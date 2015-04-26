function out = w_i(x,X,i,tau)
    x_i = X(i,:);
    out = exp(-((x_i-x)'*(x_i-x))/(2*tau^2));
end
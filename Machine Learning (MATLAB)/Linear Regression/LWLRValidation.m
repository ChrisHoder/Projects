function error = LWLRValidation(dTrainX,dTrainY,dTestX,dTestY,tau)
    error = 0;
    for i=1:length(dTestY),
       x = dTestX(i,:);
       
       y = dTestY(i);
       theta = LWLR(x,dTrainX,dTrainY,tau);
       x = [1 x];
       f = theta'*x';
       error = error + (y-f)^2;
    end
    error = error/length(dTestY);

end

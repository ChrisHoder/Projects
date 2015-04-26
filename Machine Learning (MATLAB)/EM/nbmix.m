% FILE: nbmix.m
% AUTHOR: Chris Hoder
% DATE: 2/28/2013
% COSC 74 
% Question 4 c)
%
% (c) [14 points + 5 bonus points] Implement the EM algorithm for training 
% the Mixture of two Naive Bayes models that you have derived in problem 3. Please use the syntax
% [labels, loglik] = nbmix(X), where X and labels are defined as before and loglik
% is the log-likelihood value upon convergence. Note that the vector labels is trivially
% obtained from the posteriors p(z(i)|x(i)). Again, you will get 5 bonus points if you code
% the algorithm so that each EM iteration does not involve any loop (obviously you will
% still need a loop over the EM iterations). Note that you will certainly run into numerical
% problems if you compute the class posteriors naively in terms of products of the small
% probabilities p(x(i)|z(i)). 
%
% This method will run the Em algorithm for naive bayes
function [labels, loglik] = nbmix(X)
[m, ~] = size(X);
% INITIALIZE VARIABLES
%  To do this I randomly assign 1 or 0 labels to the data set and then 
%  compute the Naive Bayes values for these labels (using formulas from
%  previous homework).
labels = randi([0,1],[m, 1]);
sum1 = sum(labels(:) == 1);
phi_0 = ((1+(sum(X(labels(:) == 0,:),1)))/(2+(m-sum1)))';
phi_1 = ((1+(sum(X(labels(:) == 1,:),1)))/(2+sum1))';
phiz = sum(labels)/length(labels);

%Initialize values
iterationCount = 1;
loglikprev =  0;
loglik = inf;
threshold = 10^-3;
maxIterations = 100000;
loglikValues = zeros(maxIterations,1);
%%% UNTIL convergence
while( abs(loglik - loglikprev) > threshold && iterationCount < maxIterations),
    %%estep
    pi1 = log(phiz);
    L1 = X*log(phi_1) + (1-X)*log(1-phi_1);
    pi0 = log(1-phiz);
    L0 = X*log(phi_0) + (1-X)*log(1-phi_0);
    b1 = pi1 + L1;
    b0 = pi0 + L0;
    [probs, labels] =  max([b0 b1],[],2);
    labels(labels(:) == 1) = 0;
    labels(labels(:) == 2) = 1;
    f = probs + log(exp(b0-probs)+exp(b1-probs));
   % f = log(exp(L1+pi1) + exp(L0+pi0));
    p1 = exp(pi1+L1-f);
    %p0 = exp(pi0+L0-f);
    %[probs, labels] = max([p0 p1],[], 2);
    %labels(labels(:) == 1) = 0;
    %labels(labels(:) == 2) = 1;
    %gamma = p1;
    %gamma = p1./(p1+p2);
    gamma = p1;
    %mstep
    if(isnan(sum((X'*(1-gamma))/(sum(1-gamma)))))
        warning('issue2');
    end
    %phi_0 = (1+(X'*(1-gamma)))/(2+(sum(1-gamma)));
    phi_0 = ((X'*(1-gamma)))/((sum(1-gamma)));


    %phi_1 = (1+(X'*gamma))/(2+sum(gamma));
    phi_1 = ((X'*gamma))/(sum(gamma));

    phiz = sum(gamma)/m;
    %warning('stop');
    
    loglik_new = sum(f);
    %loglik_new = sum(log(exp(L1 + pi1) + exp(L0 + pi0)));
    %loglik_new = log(gamma'*exp(L1+pi1*ones(m,1)) + (1-gamma)'*exp(L0+pi0*ones(m,1)));
    if( loglik_new == inf || isnan(loglik_new)),
        warning('issue');
    end
    
    loglikprev = loglik;
    loglik = loglik_new;
    loglikValues(iterationCount) = loglik;
    
    iterationCount = iterationCount + 1;
    semilogy(1:iterationCount-1,loglikValues(1:(iterationCount-1)));
    xlabel('Iteration Number','FontSize',16)
    ylabel('Log-Likelihood','FontSize',16)
    set(gca,'FontSize',16)
    grid on
end
if( iterationCount > maxIterations ),
    warning('Did not converge. Optimization hit max iterations');
end
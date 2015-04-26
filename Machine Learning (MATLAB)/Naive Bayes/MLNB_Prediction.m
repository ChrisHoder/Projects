% FILE: MLNB_Prediction.m
% AUTHOR: Chris Hoder
% DATE: 2/14/13
% COSC 74
% Problem Set 2 Question 3 a

% This method will make a prediction for a Maximum Likelihood
% Naive Bayes. the input is x^ and we will predict p(y=1|x=x^) and then if
% this probability is greater than 1/2 we classify the output as y=1
% otherwise we classify the ouptut as y=0. This method follows the Naive
% bayes assumptions outlined in the class notes.
function y = MLNB_Prediction(phiValues, phiY, x)
    n = size(x,2);
    logprob1 = 0;
    logprob0 = 0;
    
    % use the log to calculate p(x=x^|y=1) and p(x=x^|y=0)
    % to avoid underflow problems. then take the exp of the value when
    % calculating the conditional: p(y=1| x=x^)
    
    % for each feature x_i
    for i = 1:n,
       % p(x_i = x_i^ | y = 1)
       if( x(i) == 1)
            logprob1 = logprob1 + log(phiValues(i,1));
            logprob0 = logprob0 + log(phiValues(i,2));
       % p(x_i = x_i^ | y = 0)
       else
            logprob1 = logprob1 + log(1-phiValues(i,1));
            logprob0 = logprob0 + log(1-phiValues(i,2));
       end
    end
    prob1 = exp(logprob1);
    prob0 = exp(logprob0);
    % p(y=1|x=x^);
    Prob = (phiY*prob1) / (prob1*phiY + (1-phiY)*prob0);
    
    % if the probability calculated is greater than 1/2 we classify the
    % output as y
    if( Prob > 1/2)
        y = 1;
    else
        y = 0;
    end
end
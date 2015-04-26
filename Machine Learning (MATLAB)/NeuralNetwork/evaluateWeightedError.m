% FILE: evaluateWeightedError.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/5/2013
% COSC 74 Final Project
%
% This method will determine the error rate for a Neural network with the
% given weights W and biases b. The error rate for a classification problem
% will be the fraction of miss-classified predictions and for a regression
% problem will be the average sum squared error.
%
% INPUTS:
%
%   X:    Examples. Each example is a row with each column a variable
% 
%   Y:    Labels for the given example in the same row
%   
%   W:    Weights for the neural network. This is a cell where each item is 
%         the weights matrix for the given layer
%
%   b:    Biases for each node in the neural network. This is a cell where
%         each item is the biases for the given layer
%
%   f:    This is the node's activation function handle
%
%   type: This is the type of data. It can be classification, 'b' or 
%         regression, 'r'
%
% OUTPUTS:
%
%   errorRate: For classification data this is the fraction of
%              miss-classified examples for regression this is the average
%              sum squared error.
% 
%
% This method is similar to the getErrorRate method except that
% for classification types the error will be weighted by the number of each
% class.

function error = evaluateWeightedError(X,Y,W,b,f,type)
    %%% BOOLEAN DATA %%%
    error = 0;
    numSamp = length(Y);
    if( type == 'b'),
        weight = sum(Y(:) == 1);
        for i = 1:length(Y),
            x = X(i,:);
            y = Y(i);
            y_pred = ANNGeneric(x,W,b,f);
            if( ( y_pred >= 0.5 && y == 0 ) )
                error = error + 1;
            elseif(( y_pred < 0.5 && y == 1) )
                error = error + (numSamp-weight)/weight;
            end

        end
        error = error/((numSamp-weight)*2);
        
    %% REGRESSION DATA %%%
    elseif( type == 'r'),
        for i=1:length(Y),
            x = X(i,:);
            y_pred = ANNGeneric(x,W,b,f);
            error = error + (y_pred-Y(i))^2;
        end
        error = error/length(Y);
            
    end


end



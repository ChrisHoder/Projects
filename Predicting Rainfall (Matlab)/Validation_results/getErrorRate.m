% FILE: getErrorRate.m
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
%   dataX_wrong: For classification these are the examples that were
%                miss-classified. For regression this is empty
%
%   dataY_wrong: For classification these are the outputs for examples 
%                that were miss-classified. For regression this is empty
%
%
function [errorRate, dataX_wrong, dataY_wrong] = ...
                                               getErrorRate(X,Y,W,b,f,type)
    AddPaths; %add paths to all folders
    [examples, variables] = size(X); %get dimmensions of data
    %initialize outputs
    errorRate = 0; 
    dataX_wrong = zeros(examples,variables);
    dataY_wrong = zeros(examples,1);
    predictions = zeros(examples,1);
   
    % FOR EVERY EXAMPLE
    for i = 1:examples,
       y_pred = ANNGeneric(X(i,:),W,b,f); %GET PREDICTION
       %%% CLASSIFICATION DATA %%%
       if( type == 'b'),
           if( y_pred >= 0.5 && Y(i)== 0 || y_pred < 0.5 && Y(i) == 1),
             errorRate = errorRate + 1;
             dataX_wrong(errorRate,:) = X(i,:);
             dataY_wrong(errorRate) = Y(i);
             predictions(i) = y_pred;
           end
       %%% REGRESSION DATA %%%
       elseif( type == 'r'),
           errorRate = errorRate + sum((y_pred-Y(i)).^2);
           predictions(i) = y_pred;
       end

    end
    %%% ONLY INCLUDE DATA THAT WAS MISS-CLASSIFIED %%%
    if( type == 'b'),
        dataX_wrong = dataX_wrong(1:errorRate,:);
        dataY_wrong = dataY_wrong(1:errorRate);
    else
        dataX_wrong = [];
        dataY_wrong = [];
    end
    errorRate = errorRate/examples;
end
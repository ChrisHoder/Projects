% FILE: getCascadeErrorRate.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/5/2013
% COSC 74 Final Project
%
% This method will calculate the predicted cascade results by using the two
% different classifiers. The first classifier will perform classification
% for precipitation or no-precipitation. This network is defined by the 
% network weights, W_class and network biases, b_class. The second network
% will take all examples that were precited to be precipitation and run 
% them through a regression network. This  network is defined by the
% network weights, W_reg and biases b_reg. The activation for both networks
% is assumed to be given by f. 
%
% OUTPUTS: 
%      errorRate:            This is the average sum squared error on the
%                            entire training set
%      missClassPrecip:      This is the number number of precipitation
%                            examples that were miss classified
%      missClassPrecipError: This is the sum squared error for the miss
%                            classified precipitation events
%      nonPrecipError:       This is the sum squared error for the miss
%                            classified non-precipitation examples
%      nonprecipCount:       This is the number of miss classified non
%                            precipitation examples.
function [errorRate,missClassPrecip,missClassPrecipError, nonPrecipError,...
         nonprecipCount] = getCascadeErrorRate(X,Y, ...
                                            W_class,b_class,W_reg,b_reg,f)
                
    AddPaths; %add paths to all folders
    [examples, ~] = size(X); %get dimmensions of data
    
    %initialize outputs
    errorRate = 0; 
    missClassPrecip = 0;
    nonPrecipError = 0;
    missClassPrecipError = 0;
    nonprecipCount = 0;
    predictValues = zeros(examples,1);
    % FOR EVERY EXAMPLE
    for i = 1:examples,
       y_pred_class = ANNGeneric(X(i,:),W_class,b_class,f); %GET PREDICTION
       % if we predicted precipitation, predict how much through the
       % regression data
       if( y_pred_class >=0.5 ),
           
           y_pred = ANNGeneric(X(i,:),W_reg,b_reg,f);
           if( Y(i) < 0.1),
                nonPrecipError = nonPrecipError + sum((y_pred-Y(i)).^2);
                nonprecipCount = nonprecipCount + 1;
           end
       else
           %miss classified precip event
           if( Y(i)  >= 0.1),
               missClassPrecip = missClassPrecip + 1;
               missClassPrecipError = missClassPrecipError + sum(Y(i)).^2;
           end
           y_pred = 0;
       end
       
       
       errorRate = errorRate + sum((y_pred-Y(i)).^2);
       predictValues(i) = y_pred;
    end
    
    errorRate = errorRate/examples;
end

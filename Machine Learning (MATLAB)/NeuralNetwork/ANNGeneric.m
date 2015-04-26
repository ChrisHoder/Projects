% FILE: ANNGeneric.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/8/2013
% COSC 74 Final Project

% This method will compute the output of a generic neural network with
% network weights W, biases b and activation function f
function y = ANNGeneric(x,W,b,f)
    L = length(W);
    for layer = 1:L,
        b_layer = b{layer};
        w = W{layer};
        %first layer is the inputs
        if(layer == 1),
            a{layer} = f(x*w + b_layer);
        else
            aPrev = a{layer-1};
            a{layer} = f(aPrev*w + b_layer);
        end
    end
    %last layer is the output
    y = a{L};
end

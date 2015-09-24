% FILE: loadCases3.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/8/2013
% COSC 74 Final Project
%
% This is a file of different network structures to be trained via a neural
% network using ANNTrain.m

case1.hiddenLayers      = 1;
case1.Nodes             = [1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case1 = case1;
clear case1

case1.hiddenLayers      = 2;
case1.Nodes             = [2 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case2 = case1;
clear case1


case1.hiddenLayers      = 2;
case1.Nodes             = [3 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case3 = case1;
clear case1


case1.hiddenLayers      = 2;
case1.Nodes             = [4 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case4 = case1;
clear case1


case1.hiddenLayers      = 2;
case1.Nodes             = [5 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case5 = case1;
clear case1



case1.hiddenLayers      = 2;
case1.Nodes             = [6 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case6 = case1;
clear case1



case1.hiddenLayers      = 2;
case1.Nodes             = [7 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case7 = case1;
clear case1


case1.hiddenLayers      = 2;
case1.Nodes             = [8 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case8 = case1;
clear case1


case1.hiddenLayers      = 2;
case1.Nodes             = [9 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case9 = case1;
clear case1



case1.hiddenLayers      = 2;
case1.Nodes             = [10 1];
case1.inputs            = 2470;
case1.momentumParam     = 0.02;
case1.alphaAdjust       = 0.6;
case1.alphaMin          = 0.01;
case1.alphaMax          = 10;
case1.f                 = @sigmoid;
case1.fprime            = @dsigmoid;
case1.alpha             = .6;
case1.maxSweepCount     = 30;

AllCases.case10 = case1;
clear case1

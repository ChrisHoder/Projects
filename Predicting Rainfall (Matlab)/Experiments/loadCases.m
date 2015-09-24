% FILE: loadCases.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/8/2013
% COSC 74 Final Project
%
% This is a file of different network structures to be trained via a neural
% network using ANNTrain.m
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

AllCases.case1 = case1;

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

AllCases.case2 = case1;
clear case2

case1.hiddenLayers      = 2;
case1.Nodes             = [20 1];
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

case1.hiddenLayers      = 3;
case1.Nodes             = [5, 5 1];
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

case1.hiddenLayers      = 3;
case1.Nodes             = [10, 10, 1];
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

case1.hiddenLayers      = 3;
case1.Nodes             = [20, 20, 1];
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

case1.hiddenLayers      = 4;
case1.Nodes             = [5, 5, 5, 1];
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


case1.hiddenLayers      = 4;
case1.Nodes             = [10, 10, 10, 1];
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

case1.hiddenLayers      = 4;
case1.Nodes             = [20, 20, 20, 1];
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

% case1.hiddenLayers      = 4;
% case1.Nodes             = [10, 40, 40, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% AllCases.case10 = case1;
% clear case1
% 
% case1.hiddenLayers      = 4;
% case1.Nodes             = [5, 10, 10, 1];
% case1.inputs            = 2470;
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% 
% AllCases.case11 = case1;
% clear case1
% 
% case1.hiddenLayers      = 4;
% case1.Nodes             = [10, 5, 10, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% AllCases.case12 = case1;
% clear case1
% 
% case1.hiddenLayers      = 4;
% case1.Nodes             = [10, 10, 5, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% AllCases.case13 = case1;
% clear case1
% 
% case1.hiddenLayers      = 4;
% case1.Nodes             = [10, 5, 5, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% 
% AllCases.case14 = case1;
% clear case1
% 
% case1.hiddenLayers      = 4;
% case1.Nodes             = [5, 10, 5, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% 
% AllCases.case15 = case1;
% clear case1
% 
% case1.hiddenLayers      = 3;
% case1.Nodes             = [20, 20, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% 
% AllCases.case16 = case1;
% clear case1
% 
% case1.hiddenLayers      = 3;
% case1.Nodes             = [20, 5, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% 
% AllCases.case17 = case1;
% clear case1
% 
% case1.hiddenLayers      = 3;
% case1.Nodes             = [20, 10, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% 
% AllCases.case18 = case1;
% clear case1
% 
% case1.hiddenLayers      = 3;
% case1.Nodes             = [20, 5, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% AllCases.case19 = case1;
% clear case1
% 
% case1.hiddenLayers      = 3;
% case1.Nodes             = [5, 10, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% 
% AllCases.case20 = case1;
% clear case1
% 
% case1.hiddenLayers      = 3;
% case1.Nodes             = [5, 20, 1];
% case1.inputs            = 2470;
% case1.momentumParam     = 0.02;
% case1.alphaAdjust       = 0.6;
% case1.alphaMin          = 0.01;
% case1.alphaMax          = 10;
% case1.f                 = @sigmoid;
% case1.fprime            = @dsigmoid;
% case1.alpha             = .6;
% case1.maxSweepCount     = 30;
% 
% AllCases.case21 = case1;
% clear case1

% FILE: buildStruct.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/5/2013
% COSC 74 Final Project
%
% 
% This method will build the structure needed for ANNTrain. See ANNTrain.m
% for more detail on the inputs needed.
function caseStruct = buildStruct(hiddenLayers, Nodes, f,fprime, inputs,...
       maxTrials,threshold,maxThresholdCount,momentumParam, alphaAdjust, ...
       alpha,alphaMin,alphaThreshold, type, InfoRange)

    

    caseStruct.hiddenLayers      = hiddenLayers;
    caseStruct.Nodes             = Nodes;
    caseStruct.inputs            = inputs;
    caseStruct.maxTrials         = maxTrials;
    caseStruct.threshold         = threshold;
    caseStruct.maxThresholdCount = maxThresholdCount;
    caseStruct.momentumParam     = momentumParam;
    caseStruct.alphaAdjust       = alphaAdjust;
    caseStruct.alphaMin          = alphaMin;
    caseStruct.f                 = f;
    caseStruct.fprime            = fprime;
    caseStruct.alpha             = alpha;
    caseStruct.InfoRange         = InfoRange;
    caseStruct.alphaThreshold    = alphaThreshold;
    caseStruct.type              = type;
    
    
end
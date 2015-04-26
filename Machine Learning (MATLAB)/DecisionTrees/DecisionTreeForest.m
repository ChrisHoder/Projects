% FILE: DecisionTreeForest.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/5/2013
%
%
% 
%
%
%
function [ trees ] = DecisionTreeForest( X, Y, C, Trees)
% DECISIONTREE This function learns a decision tree forest from training data X&Y
%   X Nxd N d-dim traing samples (binary)
%   Y Nx1 labels for X (binary)
%   C is the upper bound stopping cricterion for the a decision region, as
%   described in the question.
%   Return: 
%   tree: a cell of length: Trees where each element is a 
%          Px3 the decision tree matrix. The randomness is introduced by
%          the choice of 3 non-denerate feature partitions to be considered
%          at each node during training.
%
%   The data structure for the decision tree matrix:
%
%   The tree structure is a Px4 matrix, each row [s1, s2, s3, value]
%   is either a decision tree splitting node or a leaf.
%   For a sample x:
%   If s1>0, this row is a splitting node:
%   s1 is the decision feature for this split.
%   s2 is the next node (row number) if x_s1>s4; 
%   s3 is the next node (row number) if x_s1<s4.
%   s4 is the split value
%   
%   If s1==0, this row is a leaf:
%   s1 is always 0.
%   s2 is the label for the leaf (either 0 or 1).
%   s3 is p(y=1|x is in this leaf) for this decision leaf.
%   s4 is undefined (could be anything).
%
%   The root splitting node is row 1.


%% initialization
[N,d] = size(X); assert(length(Y) == N);
% These store a list of possible decisions

%%%% CHECK TO SEE IF THERE ARE TEST CASES %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( exist('testCases.mat') ),
    loadedCases = load('testCases.mat');
else
    error('Need to generate Test Cases to run Classifier');
end
feat_idx = loadedCases.cases;
feat_idx = feat_idx(1:end-1,:);
%feat_idx = 1:d;         % using all the feature for the root splitting node
c= N*C;                 % max size for a leaf node
%tree = zeros(2*1/C, 3); % estimate the size of the tree, 
                        % and preallocate the space.
trees{Trees} = [];                     
for i = 1:Trees,  
    len = round(2*1/C);
    
    tree = zeros(len,4);
    % calculating the decision tree, with the current splitting node being the
    % the root node of the tree. See comments in DT_recursive() for details 
    [tree, slot] = DTF_recursive(X, Y, feat_idx, tree, 1, c);
    tree = tree(1:(slot-1), :);
    trees{i} = tree;

end
end
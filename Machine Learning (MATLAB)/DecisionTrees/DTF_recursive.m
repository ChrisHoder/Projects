% FILE: DTF_recursive.m
% AUTHOR: Chris Hoder
% DATE: 3/5/13
%
%
%
%
function [ new_tree, new_slot ] = DTF_recursive(X, Y, feat_idx, tree, slot, c)
% DTF_RECURSIVE A recursive decision tree algorithm
% This function calculates the sub tree of the whole decision tree rooted 
% at the current splitting node

%   X  Txd  the traing samples that fall to the current splitting node (binary)   
%   Y  Tx1  the labels for X (binary)
%   feat_idx Rx1(R<=d) idx for features that can be used by this current 
%                      splitting node 
%   tree Qx4 the tree matrix (see. DecisionTree.m) holding all the part 
%            of the tree that is already calculated
%   slot 1x1 the row number pointing to the next unused row in the tree matrix
%   c 1x1 the max size for a leaf
%
%   Return
%   new_tree Sx4 (S>=Q+1) holding all previous parts in the tree matrix
%                         and the sub-tree rooting at the current splitting 
%                         node.
%   new_slot 1x1 the row number of the next unused row in new_tree

%
%
%
%% Termination condition
N = size(X,1);
sumY = sum(Y);
%subset of the features to consider for the split.
SAMPLE_SIZE = 10000;

% ending condition is if we have a node with fewer then C elements or 
% a pure data set (either all 1's as the output or all 0's) or that we do
% not have any more tests we can run
if (length(Y) <= c || sumY == N || sumY == 0 || isempty(feat_idx)),
    new_tree = tree;
    % by majority vote determine what the label in this leaf will be
    labelCount  = sumY/N;
    % determine what the label of this leaf will be
    if( labelCount >= 0.5 ),
        label = 1;
    else
        label = 0;
    end
    
    % create a new row in new_tree(slot, :), and fill in this row.
    new_tree(slot,:) = [0 label labelCount 0];
    % Return new_tree and new_slot, which is slot+1;
    new_slot = slot + 1;
    return; 
end;

idxs = randperm(length(feat_idx),SAMPLE_SIZE);
feat_Available = feat_idx(idxs,:);


% Calculate the entropy of the parent data
entropy = -(sumY/N)*log(sumY/N) - ((N-sumY)/N)*log((N-sumY)/N);
%initially we have no best test
featBest = -1;
% the change in entropy is going to be at worst 0. If the change in entropy
% is 0 we make no improvement.
dE_best = 0;
for i= 1:size(feat_Available,1), % for each test
   feat = feat_Available(i,:);
   
   %left child (condition is satisified) subset
   leftNodeY = Y(X(:,feat(1)) >= feat(2));
   lenLeft = length(leftNodeY);
   sumLeft = sum(leftNodeY);
   
   %right child (condition not satisfied) subset
   rightNodeY = Y(X(:,feat(1)) < feat(2));
   sumRight = sum(rightNodeY);
   lenRight = length(rightNodeY);
   
   % check to see if we made the child pure (this causes an entropy issue) 
   % otherwise calculate entropy of child
   if( sumLeft == 0 || lenLeft == sumLeft || lenLeft == 0),
       entropyLeft = 0;
   else
       entropyLeft = -(sumLeft/lenLeft)*log(sumLeft/lenLeft)-...
                ((lenLeft-sumLeft)/lenLeft)*log((lenLeft-sumLeft)/lenLeft);
   end
   % check to see if we made the child pure (entropy issue) otherwise
   % calculate entropy of child
   if( sumRight == 0 || lenRight == sumRight || lenRight == 0),
       entropyRight = 0;
   else
        entropyRight= -(sumRight/lenRight)*log(sumRight/lenRight)-...
                ((lenRight-sumRight)/lenRight)*log((lenRight-sumRight)/lenRight);
   end
   
   %calculate change in entropy
   dE = entropy - (lenLeft/N)*entropyLeft-(lenRight/N)*entropyRight;
   % Check to see if we make an improvement
   if( dE >= dE_best )
       dE_best = dE;
       featBest = i;
   end
   
end

feat_selected = feat_Available(featBest,:);

% Check to see if the feature selected divides the data set up any further.
leftNodeY = Y(X(:,feat_selected(1)) >= feat_selected(2));
rightNodeY = Y(X(:,feat_selected(1)) < feat_selected(2));
if( isempty(leftNodeY) || isempty(rightNodeY)), % we have an empty side
    %disp('0 change in entropy')
    new_tree = tree;
    % by majority vote determine what the label in this leaf will be
    labelCount  = sumY/N;
    %N;
    %sum(Y)
    if( labelCount >= 0.5 ),
        label = 1;
    else
        label = 0;
    end
    
    % create a new row in new_tree(slot, :), and fill in this row.
    new_tree(slot,:) = [0 label labelCount 0];
    % Return new_tree and new_slot, which is slot+1;
    new_slot = slot + 1;
    return;
end

%% Create a new splitting node and recursively (NO IMPLEMENTATION NEEDED)
% creating this new node
tree(slot, 1) = feat_selected(1);
% since this feat is used in this split, it is not feasible to use this
% feature again in children nodes.
%% generate the new feat_idx matrix
indx = idxs(featBest);
test = feat_idx(indx);
if( test(1) ~= feat_selected(1)),
    warning('not right');
end
if( indx == 1),
    feat_idx = feat_idx(2:end,:);
elseif( indx == size(feat_idx,1) ),
    feat_idx = feat_idx(1:end-1,:);
else
    temp1 = feat_idx(1:indx-1,:);
    temp2 = feat_idx(indx+1:end,:);
    feat_idx = [temp1 ; temp2];
end

%feat_idx = feat_remaining(feat_remaining ~= feat_selected);
% recursively calculating its left child tree
tree(slot, 2) = slot+1;
[tree, new_slot] = DTF_recursive(X(X(:, feat_selected(1))>=feat_selected(2), :), Y(X(:, feat_selected(1))>=feat_selected(2)), ...
    feat_idx, tree, slot+1, c);
tree(slot, 3) = new_slot;
tree(slot,4) = feat_selected(2);
% recursively calculating its right child tree  
[new_tree, new_slot] = DTF_recursive(X(X(:, feat_selected(1))<feat_selected(2), :), Y(X(:, feat_selected(1))<feat_selected(2)), ...
    feat_idx, tree, new_slot, c);
return;

end
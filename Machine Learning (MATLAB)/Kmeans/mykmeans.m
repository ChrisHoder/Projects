% FILE: q4a.m
% AUTHOR: Chris Hoder
% DATE: 2/28/2013
% COSC 74 
% Question 4 a)
%
%
% (a) [5 points + 5 bonus points] Implement1 the k-means method for the case
% k = 2 (i.e., the function need not be general) by writing a Matlab function
% with syntax [labels, distortion] = mykmeans(X) where X is a m × n matrix 
% containing m examples, each having n features, labels is a m-dimensional 
% output vector containing the assigned labels (with possible values 0 or 1)
% and distortion is a scalar containing the distortion value at convergence.
% You will get 5 bonus points if you code the algorithm without using any 
% form of loop (except for the loop over iterations). Run your code on the
% spam data and plot the distortion as a function of the iterations.
%
% This is my kmeans implementation. There are no for-loops other than the
% loop over the iterations. This initializes our points by randomly
% choosing a point and then finding the next centroid as the furthest point
% from the already chosen centroid.
function [labels, distortion] = mykmeans(X)
     centroid = zeros(2,size(X,2));
%      centroid(1,:) = X(5,:);
%      centroid(2,:) = X(10,:);
 %   if( rand(1) > .5),
%     centroid_new = zeros(2,size(X,2));
%     idx = randperm(size(X,1),1);
%     centroid(1,:) = X(idx,:); %randomly select a point to start
%     [~,i] = max(sum((X-ones(size(X))*diag(centroid(1,:))).^2,2));
%     centroid(2,:) = X(i,:);
  %  else,
    %warning('asdf')
%     warning('asd')
%     
        idx1 = randperm(size(X,1),1); %prevents 2 from being the same
        centroid(1,:) = X(idx1,:);
        idx2 = randperm(size(X,1),1);
        centroid(2,:) = X(idx2,:);
   % end

    % Do not start with a digenerate point
    while( sum(centroid(1,:) ~= centroid(2,:)) == 0)
        idx2 = randperm(size(X,1),1);
        centroid(2,:) = X(idx2,:);
    end
    centroid_start1 = centroid(1,:);
    
    centroid_start2 = centroid(2,:);
    %centroid(1) == label 1,
    %centroid(2) == label 2,
    changes = true;
    maxIterations = 10^6;
    distortionTotals = zeros(maxIterations,1);
    iterationCount = 0;
    %warning('adfaf')
    while(changes == true && iterationCount < maxIterations),
        iterationCount = iterationCount + 1;
        %values1 = sum((X-centroid(1,:)).^2,2);
        %values2 = sum((X-centroid(2,:)).^2,2);
        centroid1 = centroid(1,:);
        centroid2 = centroid(2,:);
        values1 = sum((X-ones(size(X))*diag(centroid1)).^2,2);
        values2 = sum((X-ones(size(X))*diag(centroid2)).^2,2);
        %calculate the labesl and the distortions for eaach point
        [distortions, labels] = min([values1 values2],[],2);
         %labels = distortion;
        labels(labels(:) == 1) = 0;
        labels(labels(:) == 2) = 1;
        if( sum(labels(:)==0) == 0 || sum(labels(:) == 0) == length(labels)...
                                   || sum(sum(isnan(centroid))) ~= 0 ),
            error('asdf');
        end
        %warning('asdaf')
        centroid_new(1,:) = sum(X(labels(:) == 0,:),1)/sum(labels(:)==0);
        centroid_new(2,:) = sum(X(labels(:) == 1,:),1)/sum(labels(:)==1);
        
        %if(sum(centroid_new(1,:)==centroid(1,:)) == length(centroid(1,:)) && sum((centroid_new(2,:) == centroid(2,:))) == length(centroid(2,:))),
        if( sum(sum(centroid == centroid_new)) ==...
                                        size(centroid,1)*size(centroid,2)),
            changes = false;
           
        else
            changes = true;
            centroid = centroid_new;
        end
        %get the distortion
        distortionTotals(iterationCount) = sum(distortions);
        
    end

    %distortion = distortion(iterationCount);
    distortionTotals = distortionTotals(1:iterationCount);
    plot(1:iterationCount,distortionTotals(1:iterationCount),'LineWidth',2.0);
    xlabel('Iteration Number','FontSize',16)
    ylabel('Distortion','FontSize',16)
    set(gca,'FontSize',16)
    distortion = distortionTotals(iterationCount);
    %warning('asdfads')
end
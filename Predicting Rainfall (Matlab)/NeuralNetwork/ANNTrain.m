% FILE: ANNTrain.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/8/2013
% COSC 74 Final Project
%
% This method will train a given nerural network that is specified in the
% given settingsStruc input. The newtork will 
%
%
%  INPUTS:
%
%  X:             These are the training examples
%
%  Y:             These are the corresponding output values
%
%  testX:         These are test examples (do not change training)
%
%  testY:         These are test outputs values
%
%  settingsStruc: This structure contains all of the settings for training
%                 neural network. The expected settings are the following:
%                   
%    settingsStruc.hiddenLayers:       Number of hidden layer (including
%                                      ouputs)
% 
%    settingsStruc.Nodes:              Number of Nodes in each layer as 
%                                      vector
%
%    settingsStruc.inputs:             Number of input variables
%
%    settingsStruc.momentumParam:      Amount of the previous trial step
%                                      direction to add to the next trial
%                                      step. This is optional. Default = 0
%
%    settingsStruc.alpha:              This is the initaial learning 
%                                      parameter (step size).
%
%    settingsStruc.f:                  Node activation function handle
%
%    settingsStruc.fprime:             Derivative of node activation
%                                      function f
%
%    settingsStruc.InfoRange:          This specifies the number of
%                                      evaluations of the gradient there
%                                      will be for each value of alpha
%                                      during the line search. This is an
%                                      optional parameter. Default is 1/2
%                                      the length of the training set
%
%    settingsStruc.alphaMax:           This sepcifies the maximum allowable
%                                      value of alpha. If the alpha value
%                                      goes above this value the
%                                      optimization will exit and the
%                                      solution will not have convereged.
%                                      This is an optional parameter.
%                                      Default is 10
%
%    settingsStruc.alphaMin:           This is the minimum allowable alpha
%                                      value. Once alpha gets below this
%                                      value the training will exit. This
%                                      is an optional parameter. Default is
%                                      0.01
%
%    settingsStruc.type:               This is the training type for the
%                                      Neural Network. The user can specify
%                                      either 'b' for classification or 'r'
%                                      for regression. This will change the
%                                      way that the error evaluation is
%                                      evaluated
%
%    settingsStruc.maxSweepCount:      This is the maximum number of
%                                      that will be trained. An epoch is
%                                      one evaluation of all 3 different
%                                      step sizes. This option is optional
%                                      and the default is 30.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  OUTPUTS:
%
%  W:             Node weights. This is a cell where each element are the 
%                 weights for the given layer in matrix form.
%
%  b:             Node bias values. This is a cell where each elment are 
%                 the biases for the nodes at the given layer.                 
%
%  W_best:        Node weights that led to the lowest error on the training
%                 set.
%
%  b_best:        Node bias values that led to the lowest error on the
%                 training set.
%
%  last_best:     true means that W,b are the same as W_best and b_best          
%
%
%  errorValues:   These are the errors on the test set and training set
%                 time they were evaluated during training. Evaluations
%                 are saved only from runs that are kept in the line search
%                 and not the other runs for different alpha values that
%                 are discarded.
%
%  epochCount:    This is the number of epoch's needed to train the neural
%                 network
function [W, b,W_best,b_best,last_best, errorValues, epochCount] = ...
                                ANNTrain(X, Y, testX, testY, settingsStruc)
                          
    
                                                          
    %%%%%%%%%%%%%%%%%%%%%%%%
    %%%% EXTRACT VALUES %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%
    hiddenLayers      = settingsStruc.hiddenLayers;
    Nodes             = settingsStruc.Nodes;            
    inputs            = settingsStruc.inputs;                  
    f                 = settingsStruc.f;
    fprime            = settingsStruc.fprime;
    alpha             = settingsStruc.alpha;
    type              = settingsStruc.type;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% DETERMINE OPTIONAL SETTINGS %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if( isfield(settingsStruc, 'alphaAdjust') == 1)
        alphaAdjust = settingsStruc.alphaAdjust;
    else
        alphaAdjust = 0.5;
    end
    
    if( isfield(settingsStruc, 'momentumParam') == 1),
        momentumParam = settingsStruc.momentumParam;
    else
        momentumParam = 0;
    end
    
    if( isfield(settingsStruc, 'InfoRange' ) == 1),
        InfoRange = settingsStruc.InfoRange;
    else
        InfoRange = length(Y);
    end

    if( isfield(settingsStruc, 'maxSweepCount') == 1),
       maxSweepCount = settingsStruc.maxSweepCount; 
    else
       maxSweepCount = 30;
    end
    
    if( isfield(settingsStruc, 'alphaMax') == 1)
        alphaMax = settingsStruc.alphaMax;
    else
        alphaMax = 10;
    end
    
    if( isfield(settingsStruc, 'alphaMin') == 1),
        alphaMin = settingsStruc.alphaMin;
    else
        alphaMin = 0.01;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% INITIALIZE VALUES %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    countPrecipEvents = sum(Y);
    numSamp = length(Y);
    L = hiddenLayers;
    n_inputs{L} = []; 
    a{L} = [];
    s{L} = [];
    W{L} = [];
    dW{L}= [];
    b{L} = [];
    trials = 1;
    sampNum = 1;
    
    % This will store our training set/test set values for
    % all the evaluations that are kept during the line search.
    % all others will be discarded
    errorValues = zeros(maxSweepCount,3);
   
    
    %%% Randomly Permute the Training Set %%%
    idx = randperm(numSamp);
    Xmat = X(idx,:);
    Ymat = Y(idx);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% RANDOMLY INITIALIZE WEIGHTS %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for layer = 1:L,
        if( layer == 1),
            d = inputs;
        else
            d = Nodes(layer-1);
        end
        w = zeros(d,Nodes(layer));
        dw = zeros(d,Nodes(layer));
        for j = 1:Nodes(layer),
           %initialize varables with a normal distribution around 0 with a
           %standard deviation equal to the sqrt of the variance. Based on
           %Bishop's book page 260.
           w(:,j) = mvnrnd(0,sqrt(d),d); 
        end
        W{layer} = w;
        dW{layer} = dw;
        b{layer} = mvnrnd(0,sqrt(d),Nodes(layer))';
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% GET INITIAL ERROR ON ENTIRE TRAINING SET %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    y_incorrectTrain = evaluateWeightedError(Xmat,Ymat,W,b,f,type);
    fprintf('Initial train set error: %f\n',y_incorrectTrain);
    W_best = W;
    b_best = b;
    y_incorrectTrain_prev = y_incorrectTrain;
    
    y_incorrect = evaluateWeightedError(testX,testY,W,b,f,type);
    fprintf('Initial test set error %f\n',y_incorrect);
    

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% START ITERATIONS %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    epochCount = 1;

    % stopping criteria are the max sweep count and if alpha becomes too
    % big or too small. If alpha gets too big or reaches the max sweep
    % count than the network did not converge
    while( epochCount < maxSweepCount && alpha > alphaMin && ...
                                                        alpha < alphaMax),
        %save the current state through the linesearch
        W_Hold = W; 
        b_Hold = b;
        dw_Hold = dw;
        y_incorrectTrain_new = [0, 0, 0];
        y_incorrect = [0, 0, 0];
        alphaValues = [(2-alphaAdjust)*alpha, alpha, alphaAdjust*alpha];
        for k = 1:length(alphaValues),
            W = W_Hold;
            b = b_Hold;
            dw = dw_Hold;
            alphaTemp = alphaValues(k);
            %set number of iterations for each step size
            for p = 1:InfoRange

                %%% BOOLEAN DATA. SAMPLE EACH CLASS EVENLY %%%
                if( type == 'b'),
                    cont = false;
                    while( cont == false),
                        if mod(sampNum,numSamp+1) == 0,
                            sampNum = 1;
                            idx = randperm(numSamp);
                            Xmat = Xmat(idx,:);
                            Ymat = Ymat(idx,:);
                        end
                        %edge checking
                        if mod(sampNum,numSamp) == 0
                            ind = numSamp;
                        else
                            ind = mod(sampNum,numSamp);
                        end
                        x = Xmat(ind,:);
                        t = Ymat(ind);
                        sampNum = sampNum + 1;
                        
                        % We want to randomly sample our classes so that
                        % the precip event examples are selected the same
                        % number of times as examples that did not precip. 
                        % this will do that.
                        if( t == 1 && rand < countPrecipEvents/numSamp),
                           cont = false;

                        elseif( t == 0 && rand < ...
                                      (numSamp-countPrecipEvents)/numSamp),
                           cont = false;
                        else
                           cont = true;
                        end
                    end
                 %%% REGRESSION DATA, SAMPLE EXAMPLES EVENLY %%%
                elseif( type == 'r'),
                    if( mod(sampNum,numSamp+1) == 0)
                        sampNum = 1;
                        idx = randperm(numSamp);
                        Xmat = Xmat(idx,:);
                        Ymat = Ymat(idx);
                    end
                    %edge checking
                    if( mod(sampNum, numSamp) == 0)
                        ind = numSamp;
                    else
                        ind = mod(sampNum,numSamp);
                    end
                    x = Xmat(ind,:);
                    t = Ymat(ind);
                    sampNum = sampNum + 1;
                end

     
                clear n_inputs a s;
                %%% CALCULATE NEW OUTPUTS FOR THIS LAYER %%%
                for layer = 1:L,
                    %the first layer will take in the inputs
                    if(layer == 1),
                       n_inputs{layer} =  x*W{layer} + b{layer};
                       a{layer} = f(n_inputs{layer});
                    else
                       n_inputs{layer} = a{layer-1}*W{layer}+b{layer};
                       a{layer} = f(n_inputs{layer});
                    end
                end

                %%% CACLCULATE THE ERROR AT THIS POINT %%%
                 N_L = Nodes(end); %number of output nodes

                %%% CALCULATE SENSITIVITY, S FOR OUTPUT LAYER %%%
                a_L = a{L};
                n_vec = n_inputs{L};
                s_sub = zeros(Nodes(end),1);
                for n = 1:N_L,
                   s_sub(n) = 2*(a_L(n)-t(n))*fprime(n_vec(n));
                end
                s{L} = s_sub;

                %%% BACKPROP THE ERRORS %%%
                for layer = L-1:-1:1,
                    N_l = Nodes(layer);
                    for j = 1:N_l, % for each node in the layer
                        n_vec = n_inputs{layer};
                        sumValue = 0;
                        w = W{layer+1};
                        s_forward = s{layer+1};
                        for i = 1:Nodes(layer+1),
                            sumValue = sumValue + w(j,i)*s_forward(i);
                        end
                        s_sub(j) = fprime(n_vec(j))*sumValue;                
                    end
                    s{layer} = s_sub;
                end
                
                %%%%%%%%%%%%%%%%%%%%%%%
                %%% UPDATE WEIGHTS  %%%
                %%%%%%%%%%%%%%%%%%%%%%%
                
                %for every layer
                for layer = 1:L,
                   w = W{layer};
                   dw = dW{layer};
                   %initial layer's previous is the inputs
                   if(layer == 1),
                       a_layer = x;

                   else
                       a_layer = a{layer-1};

                   end
                   s_sub = s{layer};
                   b_layer = b{layer};
                   %for every node in our layer
                   for j = 1:Nodes(layer),
                       %initial layer's previous are the inptus
                       if( layer == 1),
                           for i = 1:inputs,
                               temp = -alphaTemp*a_layer(i)*s_sub(j)*1 +...
                                                     momentumParam*dw(i,j);
                               w(i,j) = w(i,j) + temp; 
                               dw(i,j) = temp;
                           end
                       %otherwise go down all initial layer Nodes and
                       %update the weights to this layer node
                       else
                            for i=1:Nodes(layer-1),
                                temp = -alphaTemp*a_layer(i)*s_sub(j)*((1)) +...
                                                    momentumParam*dw(i,j);
                                w(i,j) = w(i,j) + temp;
                                dw(i,j) = temp;
                            end
                       end
                       b_layer(j) = b_layer(j) - alphaTemp*s_sub(j);
                   end
                   W{layer} = w;
                   dW{layer} = dw;
                   b{layer} = b_layer;
                end

                trials =  trials + 1;
            end
           
            
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% GET STATUS UPDATE, FIND ERROR ON ENTIRE TEST AND TRAINSET %%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % test set error
            y_incorrect(k) = evaluateWeightedError(testX,testY,W,b,f,type);
            % train set error
            y_incorrectTrain_new(k) =...
                               evaluateWeightedError(Xmat,Ymat,W,b,f,type);


            % Keep track of the best overal W_best and b_best
            if( y_incorrectTrain_new(k) <= y_incorrectTrain_prev ),
                W_best = W;
                b_best = b;
                y_incorrectTrain_prev = y_incorrectTrain_new(k);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%
            %%%% PRINT UPDATE %%%%
            %%%%%%%%%%%%%%%%%%%%%%
            fprintf('\n--------------\nTrial number: %d\n',floor(InfoRange));
            fprintf('For case number %d \n',k);
            fprintf('Alpha %f\n',alphaTemp);
            

            if( type == 'r'),    
                fprintf(['At epoch number %d, search %d, the sum sqaured ',...
             'error on the test set is %f\n'],epochCount,k,y_incorrect(k));
                fprintf(['At epoch number %d, search %d, the sum squared ',...
             'error on the train set is %f\n'],epochCount,k,...
                                                  y_incorrectTrain_new(k));
            elseif( type == 'b')
                fprintf(['At epoch number %d, search %d, the error rate ',...
                  'on the test set is %f\n'],epochCount,k,y_incorrect(k));
                fprintf(['At epoch number %d, search %d, the error rate ',...
         'on the train set is %f\n'],epochCount,k,y_incorrectTrain_new(k));
            end
            fprintf('Total numbers of trials''s computed %d \n',trials);
            % store this result in case we take this alpha value
            Wvalues.(sprintf('t_%d',k)) = W;
            bvalues.(sprintf('t_%d',k)) = b;
            dwvalues.(sprintf('t_%d',k)) = dw;
        end
        
        [minTrain, Index] =  min(y_incorrectTrain_new); 
        alpha = alphaValues(Index);
        %savenew values
        W = Wvalues.(sprintf('t_%d',Index));
        b = bvalues.(sprintf('t_%d',Index));
        dw = dwvalues.(sprintf('t_%d',Index));
        fprintf('\n--------------------------------\n');
        fprintf('Chose the following alpha: %f\n',alpha);
        fprintf('Min train value is %f\n',minTrain);
        %save the errors for this epoch
        errorValues(epochCount,:) = ...
              [epochCount, y_incorrectTrain_new(Index),y_incorrect(Index)];
       
        epochCount = epochCount + 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% END ITERATIONS %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if( alpha > alphaMax )
       fprintf('Optimization failed to converge, alpha got too big\n');
       fprintf('exited program with alpha = %f\n',alpha);
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% PRINT FINAL STATUS %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('\n--------------\n Trial number: %d, epoch number: %d\n',...
                                                        trials,epochCount);
    fprintf('Alpha %f\n',alpha);
    
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% EVALUATE NETWORK ON THE TEST SET %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    y_incorrect = evaluateWeightedError(testX,testY,W,b,f,type);
    y_incorrectTrain_new = evaluateWeightedError(Xmat,Ymat,W,b,f,type);
    if(type == 'b')
        fprintf('At trial number %d the error rate on the test set is %f\n',...
                                                      trials,y_incorrect);
        fprintf('At trial number %d the error rate on the train set is %f\n',...
                                              trials,y_incorrectTrain_new);
    else

        fprintf(['At trial number %d the sum sqaured error on the',...
                                  ' test set is %f\n'],trials,y_incorrect);
        fprintf(['At trial number %d the sum squared error on the ',...
                         'train set is %f\n'],trials,y_incorrectTrain_new);
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% UPDATE OUR BEST INDICATOR %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if( y_incorrectTrain_new <= y_incorrectTrain_prev ),
        W_best = W;
        b_best = b;
        last_best = true;
        fprintf('Last W,b values are best\n');
    else
        last_best = false;
        fprintf('Last W,b values are not best\n');
    end
  
    
    
    
    errorValues(epochCount,:) = [epochCount,y_incorrectTrain_new, y_incorrect];

    fprintf('\n -------------------- \n');
    fprintf('Optimized in %d trials and %d epoch''s \n',trials,epochCount);
  
    errorValues = errorValues(1:epochCount,:); % get only the one's set
    
end
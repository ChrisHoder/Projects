%function to pick the center points for a radial basis function. two
%different methods are used to chooese from the sample space, first
%directly from samples, and second from feature values. 
function cent = pickCent(k,X,sel)
  
    [m,n] = size(X);
   
    if sel == 0
        %Picking centers randomly from samples of X
        ind = randi(m,k,1);
        cent = X(ind,:);
    elseif sel == 1
        %Picking a random matrix from from X for centers
        ind = randi(m,k,n);
        cent = X(ind);
    end
    
end
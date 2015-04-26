%% forward direction
% %x value
% x = ;
% calc = zeros(30,3);
% for i=1:1:31,
%    x1 = besselj(i,x);
%    
%end


function error = besselCalcForward(x,nMax,n0,n1),
calc = zeros(nMax+1,4);
for i=1:1:nMax+1,
    %gets the exact value from BesselJ matlab method
    x1 = besselj(i,x); 
    
    %initial conditions are added in
    if( i == 1),
        x2 = n0;
    elseif( i == 2 ),
        x2 = n1;
    else
        %use the recursion relation
        % J_n+1 = (2n/x)J_n - J_n-1 
        x2 = ((2*i)/x)*calc(i-1,2)-calc(i-2,2);
    end
    
    calc(i,1) = x1;
    calc(i,2) = x2;
    % absolute error w/absolute value taken
    calc(i,3) = abs(x1-x2);
    % relative error w/absolute value taken
    calc(i,4) = abs(calc(i,3)/x1);
   
end



end
function [varargout]=glapoly(n,alp,x)
  
% glapoly  generalized Laguerre polynomial of degree n
    % y=glapoly(n,alp,x) returns the generalized Laguerre polynomial of degree n at x
    % The degree should be a nonnegative integer 
    % The arguments x >0, alp>-1 
    % [dy,y]=glapoly(n,alp,x) also returns the first-order 
    %  derivative of the generalized Laguerre polynomial in dy
% Last modified on Decemeber 21, 2011        
     
if nargout==1,
   if n==0, varargout{1}=ones(size(x));  return; end;
   if n==1, varargout{1}=alp+1-x; return; end;

   polylst=ones(size(x));	poly=alp+1-x;  % L_0=1; L_1=alp+1-x;    
   for k=1:n-1,
	  polyn=((2*k+alp+1-x).*poly-(k+alp)*polylst)/(k+1);  % L_{k+1}=((2k+alp+1-x)L_k-(k+alp)L_{k-1})/(k+1);
      polylst=poly; poly=polyn;	
   end;
   varargout{1}=poly;    
end;

if nargout==2,
   if n==0, varargout{2}=ones(size(x));  varargout{1}=zeros(size(x)); return; end;
   if n==1, varargout{2}=alp+1-x; varargout{1}=-ones(size(x)); return; end;

   polylst=ones(size(x)); poly=alp+1-x; pder=-ones(size(x)); % L_0=1, L_1=alp+1-x, L_1'=-1; 
   for k=1:n-1,
      polyn=((2*k+alp+1-x).*poly-(k+alp)*polylst)/(k+1); % L_{k+1}=((2k+1-x)L_k-kL_{k-1})/(k+1);
	  pdern=pder-poly ;	                	   % L_{k+1}'=L_k'-L_k; (7.12b) of the book  
	  polylst=poly;  poly=polyn;  pder=pdern;
   end;
      varargout{2}=poly;  varargout{1}=pder;
 end;
 
 return;


    

  
     
	

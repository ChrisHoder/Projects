% CODE TAKEN FROM :
%http://www.mathworks.com/matlabcentral/newsreader/view_thread/89531
function L = decimal_latlon(LLmin)
% Convert a vector of degree-minutes values (dddmm.xxxx) into
% decimal degrees.

deg = fix(LLmin/100);
mins = LLmin - deg*100;
L = deg + mins/60;
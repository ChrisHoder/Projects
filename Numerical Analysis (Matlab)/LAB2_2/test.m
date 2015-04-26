% function out = test(x,y),
% 
% out = x(y);
% 
% 
% use
%  inline('3*sin(2*x.^2)')


syms theta2 theta3 r2 r3;


J = [-r2*sin(theta2) -r3*sin(theta3); r2*cos(theta2) r3*cos(theta3)];

d = subs(J,{theta2, theta3, r2, r3},{1,2,3,4})

% subs(cos(a) + sin(b), {a, b}, {sym('alpha'), 2})


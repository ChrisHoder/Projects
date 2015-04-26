%test function

    theta4_input = 360;
    theta2_test = thetaVal(end,2)
    theta3_test = thetaVal(end,3)
    
    syms theta2 theta3 theta4 r1 r2 r3 r4;
    %convert to radians
    theta4_ins = theta4_input*pi/180;
    Jn = [-r2*sin(theta2) -r3*sin(theta3); r2*cos(theta2) r3*cos(theta3)];
    fn = [r2*cos(theta2)+r3*cos(theta3)+r4*cos(theta4)-r1;
        r2*sin(theta2)+r3*sin(theta3)+r4*sin(theta4)];
    
    Jn = subs(Jn,{r2, r3},{7,9});
    fn = subs(fn,{r1, r2,r3,r4,theta4},{11,7,9, 5, theta4_ins});
    
    f = subs(fn,{theta2, theta3},{theta2_test,theta3_test})
    J = subs(Jn,{theta2,theta3},{theta2_test,theta3_test});
    
    
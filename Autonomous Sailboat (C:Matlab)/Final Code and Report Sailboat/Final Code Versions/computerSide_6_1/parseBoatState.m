% this method returns the boat state information that we have stored on the
% boat. this is parsed and stored accordingly
function [out, boat_State] = parseBoatState(stateString, boat_State)
if( ~strcmp(stateString(1:3),'$ST')),
    out = -1;
    return
end
breakInd = strfind(stateString,',');

if( length(breakInd) < 7),
   disp('Recieved partial state information line');
   out = -1;
   return;
end

%rudder angle
boat_State.rAngle = str2num(stateString(breakInd(1)+1:breakInd(2)-1));
%sail angle
boat_State.sAngle = str2num(stateString(breakInd(2)+1:breakInd(3)-1));
boat_State.desiredHeading = str2num(stateString(breakInd(3)+1:breakInd(4)-1));
boat_State.windDir = str2num(stateString(breakInd(4)+1:breakInd(5)-1));
boat_State.windVel = str2num(stateString(breakInd(5)+1:breakInd(6)-1));
boat_State.trueDir = str2num(stateString(breakInd(6)+1:breakInd(7)-1));
boat_State.trueVel = str2num(stateString(breakInd(7)+1:end));


out = 0; % successful parsing
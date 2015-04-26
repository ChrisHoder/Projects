function [out, boat_State] = parseBoatState(stateString, boat_State)
if( ~strcmp(stateString(1:3),'$ST')),
    out = -1;
    return
end
breakInd = strfind(stateString,',');

boat_State.rAngle = str2num(stateString(breakInd(1)+1:breakInd(2)-1));
boat_State.sAngle = str2num(stateString(breakInd(2)+1:breakInd(3)-1));
boat_State.desiredHeading = str2num(stateString(breakInd(3)+1:breakInd(4)-1));

out = 0; % successful parsing
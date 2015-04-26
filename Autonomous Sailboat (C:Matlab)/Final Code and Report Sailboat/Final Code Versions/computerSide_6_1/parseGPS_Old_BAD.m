%%% THIS FILE IS BAD AND WILL NOT RUN CORRECTLY

function [out, GPS_Location] = parseGPS(gpsString, GPS_Location)
    if( ~strcmp(gpsString(1:4),'$GPS')),
       out = -1;
       return
    end
    breakInd = strfind(gpsString,',');
    
    if( length(breakInd) < 7),
       disp('incomplete GPS recieved');
       out = -1;
       return;
    end
    
    %time stamp
    GPS_Location.timestamp = str2num(gpsString(breakInd(1)+1:breakInd(2)-1));
    
    %link quality
   %if( strcmp(gpsString(breakInd(2)+1:breakInd(3)-1),'V')),
   %    out = -1;
   %    return;
   % end
    
    %latitude
    LLmin = str2num(gpsString(breakInd(2)+1:breakInd(3)-1));
    GPS_Location.lat = decimal_latlon(LLmin);
    direction = gpsString(breakInd(3)+1:breakInd(4)-1);
    GPS_Location.latD = direction;
    
    %longitude
    LLmin = str2num(gpsString(breakInd(4)+1:breakInd(5)-1)); %#ok<*ST2NM>
    GPS_Location.long = decimal_latlon(LLmin);
    GPS_Location.longD = gpsString(breakInd(5)+1:breakInd(6)-1);
    
    %SOG
    sog = gpsString(breakInd(6)+1:breakInd(7)-1);
    if( isempty(sog)),
        GPS_Location.sog = 0;
    else
        GPS_Location.sog = str2num(sog);
    end
    
    %TOG
    tog = gpsString(breakInd(7)+1:end);
    if( isempty(tog)),
       GPS_Location.tog = 0;
    else
        GPS_Location.tog = str2num(tog);
    end
    
    out = 0; % successful addition

end
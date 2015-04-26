function [out, GPS_Location] = parseGPS_custom(gpsString, GPS_Location)
    if( ~strcmp(gpsString(1:4),'$GPS')),
       out = -1;
       return
    end
    breakInd = strfind(gpsString,',');
    
    if( length( breakInd ) < 5 )
       disp('Incomplete GPS message recieved');
       out = -1;
       return;
    end
    
    %time stamp
    GPS_Location.timestamp = str2num(gpsString(breakInd(1)+1:breakInd(2)-1));
    
%     %link quality
%     if( strcmp(gpsString(breakInd(2)+1:breakInd(3)-1),'V')),
%        out = -1;
%        return;
%     end
    
    %latitude minutes
    lat_min = str2num(gpsString(breakInd(2)+1:breakInd(3)-1));
    GPS_Location.lat = lat_min;
%     direction = gpsString(breakInd(4)+1:breakInd(5)-1);
%     GPS_Location.latD = direction;
    
    %longitude
    lon_min = str2num(gpsString(breakInd(3)+1:breakInd(4)-1)); %#ok<*ST2NM>
    GPS_Location.long = lon_min;
    
    %SOG
    sog = gpsString(breakInd(4)+1:breakInd(5)-1);
    if( isempty(sog)),
        GPS_Location.sog = 0;
    else
        GPS_Location.sog = str2num(sog);
    end
    
    %TOG
    %tog = gpsString(breakInd(5)+1:breakInd(6)-1);
    tog = gpsString(breakInd(5)+1:end);
    if( isempty(tog)),
       GPS_Location.tog = 0;
    else
        GPS_Location.tog = str2num(tog);
    end
    
    out = 0; % successful addition

end
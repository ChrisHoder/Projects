function varargout = comm(varargin)
% COMM MATLAB code for comm.fig
%      COMM, by itself, creates a new COMM or raises the existing
%      singleton*.
%
%      H = COMM returns the handle to a new COMM or the handle to
%      the existing singleton*.
%
%      COMM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMM.M with the given input arguments.
%
%      COMM('Property','Value',...) creates a new COMM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before comm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to comm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comm

% Last Modified by GUIDE v2.5 29-May-2013 23:30:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comm_OpeningFcn, ...
                   'gui_OutputFcn',  @comm_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before comm is made visible.
function comm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to comm (see VARARGIN)

% Choose default command line output for comm
handles.output = hObject;


%global stop;
setappdata(0,'hMainGui',gcf);
hMainGui = getappdata(0,'hMainGui');
setappdata(hMainGui,'STOP',1);
setappdata(hMainGui,'STOPPING',1);
%setappdata(hMainGui,'incAngle',5);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes comm wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = comm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)%
%value = get(handles.minX,'String')
    clear locationHist
    global stop 
    stop = false;
    hMainGui = getappdata(0,'hMainGui');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal == 1 && stoppedVal == 1 ),
        setappdata(hMainGui,'STOPPING',0);
        setappdata(hMainGui,'STOP',0);
        
    elseif( stopVal == 0 && stoppedVal == 0),
        return;
    elseif( stopVal == 0 && stoppedVal == 1),
        %should never get here
        disp('ERROR');
        return
    elseif( stopVal == 1 && stoppedVal == 0),
        %wait for the method to exit
        return; 
    end 
    
    hMainGui = getappdata(0,'hMainGui');
   
    % get settings
    %rA_s = str2num(get(handles.rA_s,'String'));
    %sA_s = str2num(get(handles.sA_s,'String'));
    %bot_state = str2num(get(handles.bot_state,'String'));
    %check to see if we want to save the data
    saveVal = get(handles.saveCheck,'Value');
    if( saveVal),
        filename = get(handles.filename,'String');
        %filename = './GPS_DATA';
        fp = fopen(filename,'w');
    end
    
    comport = get(handles.comPort,'String');
    
    
    %reset values
    set(handles.text3,'String',0);
    set(handles.text4,'String',0);
    locationHist = zeros(2,100000); %history
    locationNum = 1;
    
    
    GPS_Location= struct('timestamp',0','lat',0,'long',0,'latD','N',...
                                              'longD','W','sog',0,'tog',0);
    setappdata(hMainGui,'GPS_Location',GPS_Location);
    boat_State = struct('rAngle',0,'sAngle',0,'desiredHeading',0,...
                                      'control',0,'windDir',0,'windVel',0);
    setappdata(hMainGui,'boat_State',boat_State);
    count = 0;
    s = xBeeInit(comport); % open/configure com port
    setappdata(hMainGui,'xBee',s);
    
    startTime = clock();
    while(1),
        secTime = etime(clock(),startTime);
        set(handles.text3,'String',sprintf('%d',round(secTime)));
        drawnow();
        if( getappdata(hMainGui,'STOP') == 1),
            break;
        end

       %%% read data
       if( s.BytesAvailable == 0),
          %pause(0.1);
          continue;
       else
          if( s.BytesAvailable < 3),
              pause(0.2);
          end
       end
       %disp('bytes available');
       %disp(s.BytesAvailable);
       line = fgetl(s); % read in line
       %line = fscanf(s,'%s\n'); % read line in
       %disp(s.BytesAvailable);
       %disp('message recieved');
       disp(line);
       %msg = sprintf('\n\n\n\n');
       %fprintf('\n\n\n\n');
       
       %double message check
       dollarLocations = strfind(line,'$');
       if( length(dollarLocations) > 1),
          % take only the first line
          % NOTE we are throwing away useful information here
          line = line(dollarLocations(1),dollarLocations(2)-1); 
       end
       
       line = strtrim(line);
       
       
       %msg recieved
       if(~isempty(line)),
           %update count
           count = count + 1;
           set(handles.text4,'String',sprintf('%d',count));
           
           %cut out the begining of the message:
           
           if(saveVal), 
                fprintf(fp,[line,'\n']);
           end
           %disp(line);
           if( length(line) < 6),
               continue;
           elseif( strcmp(line(1:4),'$GPS')),
               %parse string GPS data
               [out, GPS_Location] = parseGPS_custom(line,GPS_Location);
               setappdata(hMainGui,'GPS_Location',GPS_Location); %UPDATE SAVED STATE
       
               %GPS_Location
               if( out ~= 0),
                   disp('Error parsing GPS string');
                   disp(line);
                   disp('END string');
                   continue;
               end
               %update GUI
               %lat
               set(handles.lat,'String',num2str(GPS_Location.lat));
               %long
               set(handles.long,'String',num2str(GPS_Location.long));
               %sog
               set(handles.sog,'String',num2str(GPS_Location.sog));
               %tog
               set(handles.tog,'String',num2str(GPS_Location.tog));
               
               %long-lat plot
               locationHist(:,locationNum) = [GPS_Location.long; GPS_Location.lat];
               axes(handles.longLat);
               plot(locationHist(1,1:locationNum), locationHist(2,1:locationNum));
               xlabel(sprintf('Longitude, %s',GPS_Location.longD));
               ylabel(sprintf('Latitude, %s',GPS_Location.latD));
               locationNum = locationNum + 1; 
               axes(handles.longLat);
               
               axes(handles.sogTog);
               rdir = GPS_Location.tog * pi/180; %convert to radians
               %[x,y] = pol2cart(rdir,GPS_Location.sog);
               %compass(x,y);
               guidata(hObject, handles);
               set(handles.gpsStatus,'BackgroundColor','green');
               set(handles.gpsStatus,'String','GPS Status: Good');
               drawnow();
               
           elseif(strcmp(line(1:3),'$ST')),
           %status update    
                [out, boat_State] = parseBoatState(line,boat_State);
                set(handles.sA_r,'String',num2str(boat_State.sAngle));
                set(handles.rA_r,'String',num2str(boat_State.rAngle));
                set(handles.desiredHeading,'String',...
                                      num2str(boat_State.desiredHeading));
               %wind direction
               set(handles.wD,'String',num2str(boat_State.windDir));
               %wind velocity
               %boat_State
               set(handles.wS,'String',num2str(boat_State.windVel));
                
                drawnow();
                setappdata(hMainGui,'boat_State',boat_State);
           % error in gps                       
           elseif( strcmp(line(1:2),'$E')),
               %error in the gps connection
               set(handles.gpsStatus,'BackgroundColor','red');
               set(handles.gpsStatus,'String','GPS Status: No Connection');
               
           else
               disp('Unknown data recieved:');
               %disp(line);
           end
        
           
           
       end
       
    end
    setappdata(hMainGui,'STOPPING',1);
    fclose(s); % close serial port
    
   
% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
setappdata(hMainGui,'STOP',1);
disp('Stopping Loop');


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function sA_s_Callback(hObject, eventdata, handles)
% hObject    handle to sA_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sA_s as text
%        str2double(get(hObject,'String')) returns contents of sA_s as a double


% --- Executes during object creation, after setting all properties.
function sA_s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sA_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rA_s_Callback(hObject, eventdata, handles)
% hObject    handle to rA_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rA_s as text
%        str2double(get(hObject,'String')) returns contents of rA_s as a double


% --- Executes during object creation, after setting all properties.
function rA_s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rA_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bot_state_Callback(hObject, eventdata, handles)
% hObject    handle to bot_state (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bot_state as text
%        str2double(get(hObject,'String')) returns contents of bot_state as a double


% --- Executes during object creation, after setting all properties.
function bot_state_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bot_state (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sA_button.
function sA_button_Callback(hObject, eventdata, handles)
% hObject    handle to sA_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
     if( stopVal ~= 0 || stoppedVal ~= 0)
         return; % do nothing
     end
     sA_s = str2num(get(handles.sA_s,'String'));
     boat_State = getappdata(hMainGui,'boat_State');
     fprintf(s,sprintf('$S,%d',round(sA_s)));
     
     

% --- Executes on button press in rA_button.
function rA_button_Callback(hObject, eventdata, handles)
% hObject    handle to rA_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
     if( stopVal ~= 0 || stoppedVal ~= 0)
         return; % do nothing
     end
     rA_s = str2num(get(handles.rA_s,'String'));
     boat_State = getappdata(hMainGui,'boat_State');
     fprintf(s,sprintf('$R,%d',round(rA_s)));
     

% --- Executes on button press in bot_state_button.
function bot_state_button_Callback(hObject, eventdata, handles)
% hObject    handle to bot_state_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveCheck.
function saveCheck_Callback(hObject, eventdata, handles)
% hObject    handle to saveCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveCheck



function comPort_Callback(hObject, eventdata, handles)
% hObject    handle to comPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of comPort as text
%        str2double(get(hObject,'String')) returns contents of comPort as a double


% --- Executes during object creation, after setting all properties.
function comPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_userControl.
function set_userControl_Callback(hObject, eventdata, handles)
% hObject    handle to set_userControl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    control_state = get(handles.controlState,'Value');
    switch control_state
        case 1
            %user control
            fprintf(s,sprintf('$C, 0'));
            %break;
        case 2
            %heading control
            fprintf(s,sprintf('$C,3'));
            %break;
        case 3
            %GPS control
            fprintf(s,sprintf('$C,1'));
    end
    disp(control_state);
    %sA_s = str2num(get(handles.sA_s,'String'));
    %boat_State = getappdata(hMainGui,'boat_State');
    %fprintf(s,sprintf('$S,%d',round(sA_s)));


% --- Executes on selection change in controlState.
function controlState_Callback(hObject, eventdata, handles)
% hObject    handle to controlState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns controlState contents as cell array
%        contents{get(hObject,'Value')} returns selected item from controlState


% --- Executes during object creation, after setting all properties.
function controlState_CreateFcn(hObject, eventdata, handles)
% hObject    handle to controlState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function writeCustomString_Callback(hObject, eventdata, handles)
% hObject    handle to writeCustomString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of writeCustomString as text
%        str2double(get(hObject,'String')) returns contents of writeCustomString as a double


% --- Executes during object creation, after setting all properties.
function writeCustomString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to writeCustomString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in writeString.
function writeString_Callback(hObject, eventdata, handles)
% hObject    handle to writeString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee');  
xBeeString = get(handles.writeCustomString,'String');
xBeeString
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
if( stopVal == 0 && stoppedVal == 0)
    fprintf(s,char(xBeeString));
end




% --- Executes on button press in startLoop.
function startLoop_Callback(hObject, eventdata, handles)
% hObject    handle to startLoop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee'); 
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
if( stopVal == 0 && stoppedVal == 0)
    
    fprintf(s,'1');
end


function dH_s_Callback(hObject, eventdata, handles)
% hObject    handle to dH_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dH_s as text
%        str2double(get(hObject,'String')) returns contents of dH_s as a double


% --- Executes during object creation, after setting all properties.
function dH_s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dH_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in GPS_state.
function GPS_state_Callback(hObject, eventdata, handles)
% hObject    handle to GPS_state (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns GPS_state contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GPS_state


% --- Executes during object creation, after setting all properties.
function GPS_state_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GPS_state (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in wind_Encoder.
function wind_Encoder_Callback(hObject, eventdata, handles)
% hObject    handle to wind_Encoder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee');  
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
if( stopVal == 0 && stoppedVal == 0)
    fprintf(s,'$O');
    disp('Sent Initialization Command');
end


% --- Executes on button press in leftTurn.
function leftTurn_Callback(hObject, eventdata, handles)
% hObject    handle to leftTurn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('leftTurn');
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee');  
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
incAngle = str2num(get(handles.incAmount,'String'));
boat_State = getappdata(hMainGui,'boat_State');
 if( stopVal ~= 0 || stoppedVal ~= 0)
     return; % do nothing
 end

% not in user control
if(boat_State.control ~= 0)
    return 
end

fprintf(s,sprintf('$R,%d',boat_State.rAngle-incAngle));
boat_State.rAngle = boat_State.rAngle - incAnlge;
setappdata(hMainGui,'boat_State',boat_State);

% --- Executes on button press in rightTurn.
function rightTurn_Callback(hObject, eventdata, handles)
% hObject    handle to rightTurn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('rightTurn');
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee');  
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
boat_State = getappdata(hMainGui,'boat_State');
incAngle = str2num(get(handles.incAmount,'String'));
if( stopVal ~= 0 || stoppedVal ~= 0)
     return; % do nothing
end

% not in user control
if(boat_State.control ~= 0)
    return 
end

fprintf(s,sprintf('$R,%d',boat_State.rAngle+incAngle));
boat_State.rAngle = boat_State.rAngle + incAngle;
setappdata(hMainGui,'boat_State',boat_State);


% --- Executes on button press in sailOut.
function sailOut_Callback(hObject, eventdata, handles)
% hObject    handle to sailOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('sailOut');
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee');  
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
boat_State = getappdata(hMainGui,'boat_State');
incAngle = str2num(get(handles.incAmount,'String'));
 if( stopVal ~= 0 || stoppedVal ~= 0)
     return; % do nothing
 end

% not in user control
if(boat_State.control ~= 0)
    return 
end

fprintf(s,sprintf('$S,%d',boat_State.sAngle+incAngle));
boat_State.sAngle = boat_State.sAngle + incAngle;
setappdata(hMainGui,'boat_State',boat_State);

% --- Executes on button press in sailIn.
function sailIn_Callback(hObject, eventdata, handles)
% hObject    handle to sailIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('sailIn');
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee');  
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
boat_State = getappdata(hMainGui,'boat_State');
incAngle = str2num(get(handles.incAmount,'String'));
if( stopVal ~= 0 || stoppedVal ~= 0)
     return; % do nothing
end

% not in user control
if(boat_State.control ~= 0)
    return 
end

fprintf(s,sprintf('$S,%d',boat_State.sAngle-incAngle));
boat_State.sAngle = boat_State.sAngle - incAngle;
setappdata(hMainGui,'boat_State',boat_State);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over sailIn.
function sailIn_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to sailIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function KI_Callback(hObject, eventdata, handles)
% hObject    handle to KI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KI as text
%        str2double(get(hObject,'String')) returns contents of KI as a double


% --- Executes during object creation, after setting all properties.
function KI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function KP_Callback(hObject, eventdata, handles)
% hObject    handle to KP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of KP as text
%        str2double(get(hObject,'String')) returns contents of KP as a double


% --- Executes during object creation, after setting all properties.
function KP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setControls.
function setControls_Callback(hObject, eventdata, handles)
% hObject    handle to setControls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    Kri = str2num(get(handles.KI,'String'));
    Krp = str2num(get(handles.KP,'String'));
    fprintf(s,sprintf('$K,%f,%f',Kri,Krp));

% --- Executes on key press with focus on sailIn and none of its controls.
function sailIn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to sailIn (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee');  
stopVal = getappdata(hMainGui,'STOP');
stoppedVal = getappdata(hMainGui,'STOPPING');
if( stopVal ~= 0 || stoppedVal ~= 0)
     return; % do nothing
end
char_val = lower(get(handles.figure1,'currentcharacter'));
disp(get(handles.figure1,'currentcharacter'));

   %execute these instructions
if( char_val == 'w' )
    disp('w');
    sailIn_Callback(hObject, eventdata, handles);
elseif( char_val == 'a' )
    disp('a');
    leftTurn_Callback(hObject, eventdata, handles);
elseif( char_val == 'd' )
    disp('d');
    rightTurn_Callback(hObject, eventdata, handles);
elseif( char_val == 's')
    disp('s')
    sailOut_Callback(hObject, eventdata, handles);
elseif( get(handles.figure1,'currentcharacter') == 'h'),
    disp('h');

   
end


% --- Executes on button press in GPS_State_Set.
function GPS_State_Set_Callback(hObject, eventdata, handles)
% hObject    handle to GPS_State_Set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    GPS_state = get(handles.GPS_state,'Value');
    switch GPS_state
        case 1
            %send data
            fprintf(s,sprintf('$G, 0'));
            %break;
        case 2
            %don't send data
            fprintf(s,sprintf('$G,1'));
            %break;
    end
    disp(GPS_state);
    %sA_s = str2num(get(handles.sA_s,'String'));
    %boat_State = getappdata(hMainGui,'boat_State');
    %fprintf(s,sprintf('$S,%d',round(sA_s)));
     

% --- Executes on button press in setHeading.
function setHeading_Callback(hObject, eventdata, handles)
% hObject    handle to setHeading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    tempdata=get(handles.dH_s,'String');
    heading = str2num(char(tempdata(2,1)));
    fprintf(s,sprintf('$H,%f',heading));
    disp(heading);
    %sA_s = str2num(get(handles.sA_s,'String'));
    %boat_State = getappdata(hMainGui,'boat_State');
    %fprintf(s,sprintf('$S,%d',round(sA_s)));


% --- Executes on button press in button_Reset.
function button_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to button_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    disp('Resetting to initial state loop');
    fprintf(s,'$A');


% --- Executes on button press in button1.
function button1_Callback(hObject, eventdata, handles)
% hObject    handle to button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function incAmount_Callback(hObject, eventdata, handles)
% hObject    handle to incAmount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of incAmount as text
%        str2double(get(hObject,'String')) returns contents of incAmount as a double


% --- Executes during object creation, after setting all properties.
function incAmount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to incAmount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function goToWay_Callback(hObject, eventdata, handles)
% hObject    handle to goToWay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of goToWay as text
%        str2double(get(hObject,'String')) returns contents of goToWay as a double
    

% --- Executes during object creation, after setting all properties.
function goToWay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goToWay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in goToWaypoint.
function goToWaypoint_Callback(hObject, eventdata, handles)
% hObject    handle to goToWaypoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    tempdata=get(handles.goToWay,'String');
    wayPoint = str2double(tempdata);
    fprintf(s,sprintf('$W,%d',wayPoint));
    disp(wayPoint);


function wayNum_Callback(hObject, eventdata, handles)
% hObject    handle to wayNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wayNum as text
%        str2double(get(hObject,'String')) returns contents of wayNum as a double


% --- Executes during object creation, after setting all properties.
function wayNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wayNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wayLatMin_Callback(hObject, eventdata, handles)
% hObject    handle to wayLatMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wayLatMin as text
%        str2double(get(hObject,'String')) returns contents of wayLatMin as a double


% --- Executes during object creation, after setting all properties.
function wayLatMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wayLatMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wayLongMin_Callback(hObject, eventdata, handles)
% hObject    handle to wayLongMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wayLongMin as text
%        str2double(get(hObject,'String')) returns contents of wayLongMin as a double


% --- Executes during object creation, after setting all properties.
function wayLongMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wayLongMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in editWaypoint.
function editWaypoint_Callback(hObject, eventdata, handles)
% hObject    handle to editWaypoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    wayPoint=str2double(get(handles.goToWay,'String'));
    latMin = str2num(get(handles.wayLatMin,'String'));
    longMin = str2num(get(handles.wayLongMin,'String'));
    fprintf(s,sprintf('$E,%d,%f,%f',wayPoint,latMin,longMin));
    disp(wayPoint);

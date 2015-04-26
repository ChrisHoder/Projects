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

% Last Modified by GUIDE v2.5 02-Jun-2013 21:49:33

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

%global stopping code for ending the loop
setappdata(hMainGui,'STOP',1);
setappdata(hMainGui,'STOPPING',1);

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
    clear locationHist Run_Information
    
    % load data from figure
    hMainGui = getappdata(0,'hMainGui');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    
    
    %%%% CHECK OUR CURRENT STATE %%%%
    
    if( stopVal == 1 && stoppedVal == 1 ),
        % this is the state we want to be in to start. do nothing
        
    elseif( stopVal == 0 && stoppedVal == 0),
        return; % we are running the code currently
    elseif( stopVal == 0 && stoppedVal == 1),
        %should never get here
        disp('ERROR');
        warndlg('Reached Unreachable state!'); %displays warning
        return
    elseif( stopVal == 1 && stoppedVal == 0),
        % we have requested a stop on the while loop and it is yet to
        % execute
        return; 
    end 
    
   
    %%%% SAVE DATA CHECK %%%%
    %check to see if we want to save the data
    saveVal = get(handles.saveCheck,'Value');
    if( saveVal),
        filename = get(handles.filename,'String');
        filename2 = get(handles.filename2,'String');
        %filename = './GPS_DATA';
        fp = fopen(filename,'w');
    end
    
    
    %%% COMPORT USER WANTS TO OPEN. THIS IS THE PORT THE XBEE RADIO IS
    %%% CONNECTED TO
    comport = get(handles.comPort,'String');
    %try to connect to the comport.
    try
        s = xBeeInit(comport); % open/configure com port
    catch %#ok<CTCH>
        disp('failed to connect to com port');
        return
    end
    
    %%% RESET time, lines, GPS status %%%
    set(handles.runTime,'String',0);
    set(handles.LinesRead,'String',0);
    set(handles.gpsStatus,'BackgroundColor','red');
    set(handles.gpsStatus,'String','GPS Status: No Connection');
    
    %%%% INITIALIZE DATA STRUCTURES %%%%
    MAX_ITERATIONS = 100000;% maximum number of iterations we expect to run
    locationHist = zeros(2,MAX_ITERATIONS); %history
    Run_Information  = zeros(MAX_ITERATIONS,13);
    GPS_Location= struct('timestamp',0','lat',0,'long',0,'latD','N',...
                                              'longD','W','sog',0,'tog',0);
    setappdata(hMainGui,'GPS_Location',GPS_Location);
    boat_State = struct('rAngle',0,'sAngle',0,'desiredHeading',0,...
                                      'control',0,'windDir',0,'windVel',0,...
                                      'trueDir',0,'trueVel',0);
                                 
    setappdata(hMainGui,'boat_State',boat_State);
    setappdata(hMainGui,'Run_Information',Run_Information);
    
    
    
    
    %%%% LOAD WAYPOINTS %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%
    load('waypoints.mat'); %load the waypoints data
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% INTIALIZATION OF VALUES %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% ITERATION COUNTS %%%%
    count = 0;       % number of lines read in since begining of loop
    locationNum = 1; % number of valid GPS lines read
    setappdata(hMainGui,'xBee',s); % save the serial com port
    
    startTime = clock();
    GPS_data_count = 0;
    
    %set loop stopping information
    setappdata(hMainGui,'STOPPING',0);
    setappdata(hMainGui,'STOP',0);
    
    %%% START WHILE LOOP %%%
    while(1),
        
        %% update time
        secTime = etime(clock(),startTime);
        set(handles.runTime,'String',sprintf('%d',round(secTime)));
        drawnow();
        
        %%% STOP LOOP CHECK %%%
        if( getappdata(hMainGui,'STOP') == 1),
            break;
        end

       %%% read data %%%
       if( s.BytesAvailable == 0),
          %pause(0.1);
          continue;
       else
          if( s.BytesAvailable < 3), % wait for more info
              pause(0.2);
          end
       end
       
       %%% READ IN LINE %%%
       line = fgetl(s); % read in line
       
       disp(line);
      
       % double message check. want to make sure there is only 1 complete
       % message
       dollarLocations = strfind(line,'$');
       % more than one message
       if( length(dollarLocations) > 1),
          % take only the first line
          % NOTE we are throwing away useful information here
          line = line(dollarLocations(1):dollarLocations(2)-1); 
       end
       
       % remove white space
       line = strtrim(line);
       
       
       %msg recieved
       if(~isempty(line)),
           %update count
           count = count + 1;
           set(handles.LinesRead,'String',sprintf('%d',count));
           
           %cut out the begining of the message:
           
           if(saveVal), 
                fprintf(fp,line); %save raw message
                fprintf(fp,'\n');
           end
           
           
           % ignore short messages (incomplete)
           if( length(line) < 3),
               continue;
           % error in gps                       
           elseif( strcmp(line(1:2),'$E')),
               %error in the gps connection
               set(handles.gpsStatus,'BackgroundColor','red');
               set(handles.gpsStatus,'String','GPS Status: No Connection');
           elseif( strcmp(line(1:3),'$B')),
               
               breakInd = strfind(line,',');
               wpt = line(breakInd(1)+1:end);
               set(handles.reachedWpt,'String',sprintf('Reached Wpt: %s',wpt));
               %%% GPS DATA %%%
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
               %plot the history of all the points
               
               plot(locationHist(1,1:locationNum), locationHist(2,1:locationNum));
               %plot the waypoints
               hold on;
               scatter(waypoints(:,2),waypoints(:,1)); %plot the waypoints
               xlabel(sprintf('Longitude, %s',GPS_Location.longD));
               ylabel(sprintf('Latitude, %s',GPS_Location.latD));
               hold off;
               locationNum = locationNum + 1; 
              
               %plot compass plot
               axes(handles.sogTog);
               rdir = GPS_Location.tog * pi/180; %convert to radians
               [x,y] = pol2cart(rdir,GPS_Location.sog);
               compass(x,y);
               guidata(hObject, handles);
               set(handles.gpsStatus,'BackgroundColor','green');
               set(handles.gpsStatus,'String','GPS Status: Good');
               drawnow();
               
               % save the data to our matrix of information
               if( saveVal ),
                    GPS_data_count = GPS_data_count + 1;
                    Run_Information(GPS_data_count,1:5) = [... 
                             GPS_Location.timestamp,...
                             GPS_Location.long,...
                             GPS_Location.lat,...
                             GPS_Location.sog,...
                             GPS_Location.tog];
                    save(filename2,'Run_Information');
                    setappdata(hMainGui,'Run_Information',Run_Information);
               end
               
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
               set(handles.trueVel,'String',num2str(boat_State.trueVel));
               set(handles.trueDir,'String',num2str(boat_State.trueDir));
               drawnow();
               setappdata(hMainGui,'boat_State',boat_State);
               
               %save information
               if( GPS_data_count ~= 0 && saveVal == 1),
                   Run_Information(GPS_data_count,6:13) = [ ...
                                   boat_State.rAngle,...
                                   boat_State.sAngle,...
                                   boat_State.desiredHeading,...
                                   boat_State.windDir,...
                                   boat_State.windVel,...
                                   boat_State.trueDir,...
                                   boat_State.trueVel,...
                                   boat_State.control];
                   save(filename2,'Run_Information'); 
                   setappdata(hMainGui,'Run_Information',Run_Information);

               end
           
           else
               disp('Unknown data recieved:');
               %disp(line);
           end
        
           
           
       end
       
    end
    % we have stopped.
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
        case 4
            %MAX_VELOCITY_MODE
            fprintf(s,sprintf('$C,4'));
        case 5
            %HEADING_CONTROL_MODE
            fprintf(s,sprintf('$C,5'));
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
    disp('loop started');
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
boat_State.rAngle = boat_State.rAngle - incAngle;
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

fprintf(s,sprintf('$S,%d',boat_State.sAngle-incAngle));
boat_State.sAngle = boat_State.sAngle - incAngle;
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

fprintf(s,sprintf('$S,%d',boat_State.sAngle+incAngle));
boat_State.sAngle = boat_State.sAngle + incAngle;
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
    heading = str2num(char(tempdata));
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



function filename2_Callback(hObject, eventdata, handles)
% hObject    handle to filename2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename2 as text
%        str2double(get(hObject,'String')) returns contents of filename2 as a double


% --- Executes during object creation, after setting all properties.
function filename2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_Waypoints.
function load_Waypoints_Callback(hObject, eventdata, handles)
% hObject    handle to load_Waypoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end

    %load waypoint data from the computer
    [FileName, PathName, ~] = uigetfile();
    load([PathName,FileName]);

    %send waypoint data to the boat
    %build the message with all the waypoints
    xBeeMsg = sprintf('$F,%d',size(waypoints,1));
    for i = 1:size(waypoints,1),
         xBeeMsg = [xBeeMsg, sprintf(',%d,%f,%f',i,waypoints(i,1),waypoints(i,2))];
    end
    %send the message
    fprintf(s,xBeeMsg);
    



function legLength_Callback(hObject, eventdata, handles)
% hObject    handle to legLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of legLength as text
%        str2double(get(hObject,'String')) returns contents of legLength as a double


% --- Executes during object creation, after setting all properties.
function legLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to legLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noGoZone_Callback(hObject, eventdata, handles)
% hObject    handle to noGoZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noGoZone as text
%        str2double(get(hObject,'String')) returns contents of noGoZone as a double


% --- Executes during object creation, after setting all properties.
function noGoZone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noGoZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anlgeOffDegrees_Callback(hObject, eventdata, handles)
% hObject    handle to anlgeOffDegrees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anlgeOffDegrees as text
%        str2double(get(hObject,'String')) returns contents of anlgeOffDegrees as a double


% --- Executes during object creation, after setting all properties.
function anlgeOffDegrees_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anlgeOffDegrees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setTackInfo.
function setTackInfo_Callback(hObject, eventdata, handles)
% hObject    handle to setTackInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    anlgeOffDegrees = str2num(get(handles.anlgeOffDegrees,'String'));
    noGoZone = str2num(get(handles.noGoZone,'String'));
    legLength = str2num(get(handles.legLength,'String'));
    fprintf(s,sprintf('$T,%f,%f,%f',legLength,noGoZone,anlgeOffDegrees));


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
s = getappdata(hMainGui,'xBee');
if(~isempty(s))
    fclose(s);
end
Run_Information = getappdata(hMainGui,'Run_Information');
filename = getappdata(handles.filename2,'String');
saveVal = get(handles.saveCheck,'Value');
%save a second backup copy  -- this may be redundant.
if( saveVal ),
   save(sprintf('%S_2.mat',filename(1:end-4)),'Run_Information'); 
end



% --- Executes on button press in start_Tack.
function start_Tack_Callback(hObject, eventdata, handles)
% hObject    handle to start_Tack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    fprintf(s,'$Z');



function MIN_RUDDERS_Callback(hObject, eventdata, handles)
% hObject    handle to MIN_RUDDERS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MIN_RUDDERS as text
%        str2double(get(hObject,'String')) returns contents of MIN_RUDDERS as a double


% --- Executes during object creation, after setting all properties.
function MIN_RUDDERS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MIN_RUDDERS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MAX_RUDDERS_Callback(hObject, eventdata, handles)
% hObject    handle to MAX_RUDDERS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MAX_RUDDERS as text
%        str2double(get(hObject,'String')) returns contents of MAX_RUDDERS as a double


% --- Executes during object creation, after setting all properties.
function MAX_RUDDERS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MAX_RUDDERS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setRudders.
function setRudders_Callback(hObject, eventdata, handles)
% hObject    handle to setRudders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    MIN_RUDDERS = str2num(get(handles.MIN_RUDDERS,'String'));
    MAX_RUDDERS = str2num(get(handles.MAX_RUDDERS,'String'));
    fprintf(s,sprintf('$F,%d,%d',round(MIN_RUDDERS),round(MAX_RUDDERS)));



function SAIL_GRAD_STEP_Callback(hObject, eventdata, handles)
% hObject    handle to SAIL_GRAD_STEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SAIL_GRAD_STEP as text
%        str2double(get(hObject,'String')) returns contents of SAIL_GRAD_STEP as a double


% --- Executes during object creation, after setting all properties.
function SAIL_GRAD_STEP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SAIL_GRAD_STEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HEAD_GRAD_STEP_Callback(hObject, eventdata, handles)
% hObject    handle to HEAD_GRAD_STEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HEAD_GRAD_STEP as text
%        str2double(get(hObject,'String')) returns contents of HEAD_GRAD_STEP as a double


% --- Executes during object creation, after setting all properties.
function HEAD_GRAD_STEP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HEAD_GRAD_STEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sailDeadband_Callback(hObject, eventdata, handles)
% hObject    handle to sailDeadband (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sailDeadband as text
%        str2double(get(hObject,'String')) returns contents of sailDeadband as a double


% --- Executes during object creation, after setting all properties.
function sailDeadband_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sailDeadband (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setGrads.
function setGrads_Callback(hObject, eventdata, handles)
% hObject    handle to setGrads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    hMainGui = getappdata(0,'hMainGui');
    s = getappdata(hMainGui,'xBee');
    stopVal = getappdata(hMainGui,'STOP');
    stoppedVal = getappdata(hMainGui,'STOPPING');
    if( stopVal ~= 0 || stoppedVal ~= 0)
        return; % do nothing
    end
    SAIL_GRAD_STEP = str2num(get(handles.SAIL_GRAD_STEP,'String'));
    sailDeadband = str2num(get(handles.sailDeadband,'String'));
    HEAD_GRAD_STEP = str2num(get(handles.HEAD_GRAD_STEP,'String'));
    fprintf(s,sprintf('$D,%f,%f,%f',SAIL_GRAD_STEP,sailDeadband,HEAD_GRAD_STEP));
    fprintf('$D,%f,%f,%f\n',SAIL_GRAD_STEP,sailDeadband,HEAD_GRAD_STEP);

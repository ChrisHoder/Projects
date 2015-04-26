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

% Last Modified by GUIDE v2.5 12-May-2013 11:24:30

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
global stop;
setappdata(0,'hMainGui',gcf);
hMainGui = getappdata(0,'hMainGui');
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)%
%value = get(handles.minX,'String')
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
    set(handles.text3,'String',0);
    set(handles.text4,'String',0);
    count = 0;
%     s = xBeeInit('COM6');
%     filename = './GPS_DATA';
%     fp = fopen(filename,'w');
%     fopen(s);
    startTime = clock();
    while(1),
        if( getappdata(hMainGui,'STOP') == 1),
            break;
        end
        disp(count);
        count = count + 1;
%         line = fscan(s);
%         if(~isempty(line)),
%             fprintf(fp,[line,'\n']);
%             count = count + 1;
          pause(0.5);
         set(handles.text4,'String',sprintf('%d',count));
%         end
         secTime = etime(clock(),startTime);
         set(handles.text3,'String',sprintf('%d',round(secTime)));
    end
    setappdata(hMainGui,'STOPPING',1);
    
   
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
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

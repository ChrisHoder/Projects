%------------------------------------------------------------------------%
% OnePlotGUI.m -- This file creates the GUI with the options for plotting
% one figure on the main GUI. Uses graphing functions found in
% PlotViewGui.m
%------------------------------------------------------------------------%

% File: OnePlotGUI.m
% Date: 7/24/2011

function varargout = OnePlotGUI(varargin)
% ONEPLOTGUI MATLAB code for OnePlotGUI.fig
%      ONEPLOTGUI, by itself, creates a new ONEPLOTGUI or raises the existing
%      singleton*.
%
%      H = ONEPLOTGUI returns the handle to a new ONEPLOTGUI or the handle to
%      the existing singleton*.
%
%      ONEPLOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ONEPLOTGUI.M with the given input arguments.
%
%      ONEPLOTGUI('Property','Value',...) creates a new ONEPLOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OnePlotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OnePlotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above xAxis to modify the response to help OnePlotGUI

% Last Modified by GUIDE v2.5 18-Jul-2011 16:45:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OnePlotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OnePlotGUI_OutputFcn, ...
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

% --- Executes just before OnePlotGUI is made visible.
function OnePlotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OnePlotGUI (see VARARGIN)

% Choose default command line output for OnePlotGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

plotGui = getappdata(0,'plotGui');
setappdata(plotGui,'OnePlot',gcf);


% --- Outputs from this function are returned to the command line.
function varargout = OnePlotGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function xAxisLabel_Callback(hObject, eventdata, handles)
% hObject    handle to xAxisLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function xAxisLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xAxisLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function yAxisLabel_Callback(hObject, eventdata, handles)
% hObject    handle to yAxisLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function yAxisLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yAxisLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function zAxisLabel_Callback(hObject, eventdata, handles)
% hObject    handle to zAxisLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function zAxisLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zAxisLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in plotType.
function plotType_Callback(hObject, eventdata, handles)
% hObject    handle to plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = get(hObject,'Value');
% If the user is trying to plot a 3d graph let him  be able to edit the 
% z axis. otherwise hide the option
switch contents
    case 1
        set(handles.zAxis,'visible','off');
        set(handles.zAxisLabel,'visible','off');
    case 2
        set(handles.zAxis,'visible','on');
        set(handles.zAxisLabel,'visible','on');        
    case 3
        set(handles.zAxis,'visible','on');
        set(handles.zAxisLabel,'visible','on');
end


% --- Executes during object creation, after setting all properties.
function plotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in plotButton.
function plotButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Plots the graph

%load the functions, axes, and figrue handles
plotGui = getappdata(0,'plotGui');
fhplot2d = getappdata(plotGui,'fhplot2d');
fhplot3d = getappdata(plotGui,'fhplot3d');
fhplotSlices = getappdata(plotGui,'fhplotSlices');
%findobj(plotGui,'tag','axes9');
axes9 = getappdata(plotGui,'axesFull');
setappdata(plotGui,'plotFigure',getappdata(plotGui,'OnePlot'));
type = get(handles.plotType,'Value');
setappdata(plotGui,'plotLocation',1);
% switch on the type of graph to be ploted
switch type
    case 1 %2d
      setappdata(plotGui,'axesPlot',axes9);
      setappdata(plotGui,'xLabel',get(handles.xAxisLabel,'String'));
      setappdata(plotGui,'yLabel',get(handles.yAxisLabel,'String'));
      setappdata(plotGui,'title',get(handles.title,'String'));
      feval(fhplot2d);   
    case 2 % 3d
       setappdata(plotGui,'axesPlot',axes9);
       setappdata(plotGui,'xLabel',get(handles.xAxisLabel,'String'));
       setappdata(plotGui,'yLabel',get(handles.yAxisLabel,'String'));
       setappdata(plotGui,'zLabel',get(handles.zAxisLabel,'String'));
       setappdata(plotGui,'title',get(handles.title,'String'));
       feval(fhplot3d);
    case 3 %slices
       setappdata(plotGui,'axesPlot',axes9);
       setappdata(plotGui,'xLabel',get(handles.xAxisLabel,'String'));
       setappdata(plotGui,'yLabel',get(handles.yAxisLabel,'String'));
       setappdata(plotGui,'zLabel',get(handles.zAxisLabel,'String'));
       setappdata(plotGui,'title',get(handles.title,'String'));
       feval(fhplotSlices); 
end
%display the notes from this graph on the mainGUI
NotesLocation = findobj(plotGui,'tag','graphNotes');
set(NotesLocation,'String',getappdata(plotGui,'Notes1'));
close(getappdata(plotGui,'OnePlot'));
       

function title_Callback(hObject, eventdata, handles)
% hObject    handle to title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

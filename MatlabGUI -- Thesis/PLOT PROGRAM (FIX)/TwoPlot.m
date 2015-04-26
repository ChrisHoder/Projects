%------------------------------------------------------------------------%
% TwoPlot.m -- This file creates the GUI that has the options to plot 2
% graphs on the main graphing GUI
%------------------------------------------------------------------------%

% File: TwoPlot.m
% Date: 7/24/2011


function varargout = TwoPlot(varargin)
% TWOPLOT MATLAB code for TwoPlot.fig
%      TWOPLOT, by itself, creates a new TWOPLOT or raises the existing
%      singleton*.
%
%      H = TWOPLOT returns the handle to a new TWOPLOT or the handle to
%      the existing singleton*.
%
%      TWOPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TWOPLOT.M with the given input arguments.
%
%      TWOPLOT('Property','Value',...) creates a new TWOPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TwoPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TwoPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TwoPlot

% Last Modified by GUIDE v2.5 18-Jul-2011 16:22:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TwoPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @TwoPlot_OutputFcn, ...
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


% --- Executes just before TwoPlot is made visible.
function TwoPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TwoPlot (see VARARGIN)

% Choose default command line output for TwoPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%save Gui figure handle
plotGui = getappdata(0,'plotGui');
setappdata(plotGui,'TwoPlot',gcf);

% --- Outputs from this function are returned to the command line.
function varargout = TwoPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function xLabelBottom_Callback(hObject, eventdata, handles)
% hObject    handle to xLabelBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function xLabelBottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xLabelBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function yLabelBottom_Callback(hObject, eventdata, handles)
% hObject    handle to yLabelBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function yLabelBottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLabelBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function zLabelBottom_Callback(hObject, eventdata, handles)
% hObject    handle to zLabelBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function zLabelBottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zLabelBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in plotType2.
function plotType2_Callback(hObject, eventdata, handles)
% hObject    handle to plotType2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%if the plot is going to involve the z axis allow the user to set the
% z axis label
contents = get(hObject,'Value');
switch contents
    case 1
        set(handles.zLabel2,'visible','off');
        set(handles.zLabelBottom,'visible','off');
    case 2
        set(handles.zLabel2,'visible','on');
        set(handles.zLabelBottom,'visible','on');
    case 3
        set(handles.zLabel2,'visible','on');
        set(handles.zLabelBottom,'visible','on');
end

% --- Executes during object creation, after setting all properties.
function plotType2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotType2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in plotBottom.
function plotBottom_Callback(hObject, eventdata, handles)
% hObject    handle to plotBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load figure handle, and functions for plotting from mainGui
plotGui = getappdata(0,'plotGui');
fhplot2d = getappdata(plotGui,'fhplot2d');
fhplot3d = getappdata(plotGui,'fhplot3d');
fhplotSlices = getappdata(plotGui,'fhplotSlices');
%get plot type
type = get(handles.plotType2,'Value');
%get axes handle
axes7 = getappdata(plotGui,'axesHalf2');
%set the data so other functions will know which plot is being used
setappdata(plotGui,'plotFigure',getappdata(plotGui,'TwoPlot'));
setappdata(plotGui,'plotLocation',2);
%switch on the type of graph data (2d, 3d, slices)
switch type
    case 1 %2d
      setappdata(plotGui,'axesPlot',axes7);
      setappdata(plotGui,'xLabel',get(handles.xLabelBottom,'String'));
      setappdata(plotGui,'yLabel',get(handles.yLabelBottom,'String'));
    %calls the program that plots the data (in PlotViewGUI.m)
      feval(fhplot2d);
          
    case 2 %3d
       setappdata(plotGui,'axesPlot',axes7);
       setappdata(plotGui,'xLabel',get(handles.xLabelBottom,'String'));
       setappdata(plotGui,'yLabel',get(handles.yLabelBottom,'String'));
       setappdata(plotGui,'zLabel',get(handles.zLabelBottom,'String'));
   %calls the program that plots the data (in PlotViewGUI.m)
       feval(fhplot3d);
    case 3 %slices
       setappdata(plotGui,'axesPlot',axes7);
       setappdata(plotGui,'xLabel',get(handles.xLabelBottom,'String'));
       setappdata(plotGui,'yLabel',get(handles.yLabelBottom,'String'));
       setappdata(plotGui,'zLabel',get(handles.zLabelBottom,'String'));
   %calls the program that plots the data (in PlotViewGUI.m)
       feval(fhplotSlices);
end

%sets the notes data to be displayed for this plot
NotesLocation = findobj(plotGui,'tag','graphNotes');
NotesType = findobj(plotGui,'tag','NotesType');
set(NotesLocation,'String',getappdata(plotGui,'Notes2'));
set(NotesType,'Value',2);


function xLabelTop_Callback(hObject, eventdata, handles)
% hObject    handle to xLabelTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function xLabelTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xLabelTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function yLabelTop_Callback(hObject, eventdata, handles)
% hObject    handle to yLabelTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function yLabelTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yLabelTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function zLabelTop_Callback(hObject, eventdata, handles)
% hObject    handle to zLabelTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function zLabelTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zLabelTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in plotType1.
function plotType1_Callback(hObject, eventdata, handles)
% hObject    handle to plotType1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If the user is trying to plot a 3d graph let him  be able to edit the 
% z axis. otherwise hide the option
contents = get(hObject,'Value');
switch contents
    case 1
        set(handles.zLabel,'visible','off');
        set(handles.zLabelTop,'visible','off');
    case 2
        set(handles.zLabel,'visible','on');
        set(handles.zLabelTop,'visible','on');
    case 3
        set(handles.zLabel,'visible','on');
        set(handles.zLabelTop,'visible','on');
end


% --- Executes during object creation, after setting all properties.
function plotType1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotType1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in plotTop.
function plotTop_Callback(hObject, eventdata, handles)
% hObject    handle to plotTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%lod gui data and plotting functions (from PlotViewGUI.m)
plotGui = getappdata(0,'plotGui');
fhplot2d = getappdata(plotGui,'fhplot2d');
fhplot3d = getappdata(plotGui,'fhplot3d');
fhplotSlices = getappdata(plotGui,'fhplotSlices');
%determine type of graph user chose
type = get(handles.plotType1,'Value');
%get top axes handle
axes6 = getappdata(plotGui,'axesHalf1');
setappdata(plotGui,'plotFigure',getappdata(plotGui,'TwoPlot'));
%set plotLocaiton for the notes section
setappdata(plotGui,'plotLocation',1);
%Switch on the type of graph to be plotted: 2d, 3d slices. Set data for
%functions
switch type
    case 1 %2d
      setappdata(plotGui,'axesPlot',axes6);
      setappdata(plotGui,'xLabel',get(handles.xLabelTop,'String'));
      setappdata(plotGui,'yLabel',get(handles.yLabelTop,'String'));
      setappdata(plotGui,'title',get(handles.titleTop,'String'));
      %call plotting function (see PlotViewGUI.m)
      feval(fhplot2d);
          
    case 2 %3d
       setappdata(plotGui,'axesPlot',axes6);
       setappdata(plotGui,'xLabel',get(handles.xLabelTop,'String'));
       setappdata(plotGui,'yLabel',get(handles.yLabelTop,'String'));
       setappdata(plotGui,'zLabel',get(handles.zLabelTop,'String'));
       setappdata(plotGui,'title',get(handles.titleTop,'String'));
       %call plotting function (see PlotViewGUI.m)
       feval(fhplot3d);
    case 3 %slices
       setappdata(plotGui,'axesPlot',axes6);
       setappdata(plotGui,'xLabel',get(handles.xLabelTop,'String'));
       setappdata(plotGui,'yLabel',get(handles.yLabelTop,'String'));
       setappdata(plotGui,'zLabel',get(handles.zLabelTop,'String'));
       setappdata(plotGui,'title',get(handles.titleTop,'String'));
       %call plotting function (see PlotViewGUI.m)
       feval(fhplotSlices);
end
%set the notes for this particular graph to be visible on the mainGUI.
NotesLocation = findobj(plotGui,'tag','graphNotes');
NotesType = findobj(plotGui,'tag','NotesType');
set(NotesLocation,'String',getappdata(plotGui,'Notes1'));
set(NotesType,'Value',1);



function titleBottom_Callback(hObject, eventdata, handles)
% hObject    handle to titleBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function titleBottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to titleBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function titleTop_Callback(hObject, eventdata, handles)
% hObject    handle to titleTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function titleTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to titleTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

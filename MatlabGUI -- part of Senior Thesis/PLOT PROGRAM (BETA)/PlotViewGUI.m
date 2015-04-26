%------------------------------------------------------------------------%
% PlotViewGUI.m -- This file creates the PlotViewGUI.fig. The main GUI for the
% plotting program. This file also contains the functions that read and
% plot the 2d, 3d and slices data.
%------------------------------------------------------------------------%

% File: PlotViewGui.m
% Date: 7/24/2011


function varargout = PlotViewGUI(varargin)
% PLOTVIEWGUI MATLAB code for PlotViewGUI.fig
%      PLOTVIEWGUI, by itself, creates a new PLOTVIEWGUI or raises the existing
%      singleton*.
%
%      H = PLOTVIEWGUI returns the handle to a new PLOTVIEWGUI or the handle to
%      the existing singleton*.
%
%      PLOTVIEWGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTVIEWGUI.M with the given input arguments.
%
%      PLOTVIEWGUI('Property','Value',...) creates a new PLOTVIEWGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlotViewGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlotViewGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlotViewGUI

% Last Modified by GUIDE v2.5 20-Apr-2012 19:53:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlotViewGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PlotViewGUI_OutputFcn, ...
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

% --- Executes just before PlotViewGUI is made visible.
function PlotViewGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlotViewGUI (see VARARGIN)

% Choose default command line output for PlotViewGUI
handles.output = hObject;

%Save figure to be accessed by other GUIs
setappdata(0,'plotGui',gcf);
plotGui = getappdata(0,'plotGui');
setappdata(plotGui,'fhplot2d',@plot2d);
setappdata(plotGui,'fhplot3d',@plot3d);
setappdata(plotGui,'fhplotSlices',@plotSlices);
%needs to be initialized so the user can't crash the program
setappdata(plotGui,'Notes1','');
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = PlotViewGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in newFigure.
function newFigure_Callback(hObject, eventdata, handles)
% hObject    handle to newFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Another GUI that has options for a new figure plot
NewFigureGUI

% --- Executes on selection change in NumPlots.
function NumPlots_Callback(hObject, eventdata, handles)
% hObject    handle to NumPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function NumPlots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in choosePlots.
function choosePlots_Callback(hObject, eventdata, handles)
% hObject    handle to choosePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the number of plots
NumPlots = get(handles.NumPlots,'Value');
plotGui = getappdata(0,'plotGui');
%set the figure handles to GUI data
setappdata(plotGui,'axesFull', handles.axes9);
setappdata(plotGui,'axesHalf1',handles.axes6);
setappdata(plotGui,'axesHalf2',handles.axes7);
setappdata(plotGui,'axesQuart1',handles.axes1);
setappdata(plotGui,'axesQuart2',handles.axes3);
setappdata(plotGui,'axesQuart4',handles.axes4);
setappdata(plotGui,'axesQuart3',handles.axes5);

%switch on the # of plots
switch NumPlots
    case 1 % one plot
        
        %remove all colorbars from potential previous plots
        axes(handles.axes1);
        colorbar('off');
        axes(handles.axes3);
        colorbar('off');
        axes(handles.axes4);
        colorbar('off');
        axes(handles.axes5);
        colorbar('off');
        axes(handles.axes6);
        colorbar('off');
        %idk why this is needed but it created a warning the other way
        axes(getappdata(plotGui,'axesHalf2'));
        colorbar('off');
        
        %adjust the visibility so only the large axes are visible
        set(handles.axes1,'visible','off');
        set(handles.axes3,'visible','off');
        set(handles.axes4,'visible','off');
        set(handles.axes5,'visible','off');
        set(handles.axes6,'visible','off');
        set(handles.axes7,'visible','off');
        set(handles.axes9,'visible','on');
        
        %set the notes to only one choice
        NotesChoices = {'---'};
        set(handles.NotesType,'String',NotesChoices);
        
        %clear all axes except the big one
        cla(handles.axes1);
        cla(handles.axes3);
        cla(handles.axes4);
        cla(handles.axes5);
        cla(handles.axes6);
        cla(handles.axes7);
        
        if(get(handles.addPlot,'Value') == 1),
            hold on
        else,
            hold off
        end
        
        
        %Open the GUI with options for plotting one figure
        OnePlotGUI
 
    case 2 % 2 plots
        
        %remove all colorbars from potential previous plots
        axes(handles.axes1);
        colorbar('off');
        axes(handles.axes3);
        colorbar('off');
        axes(handles.axes4);
        colorbar('off');
        axes(handles.axes5);
        colorbar('off');
        axes(handles.axes9);
        colorbar('off');
        
        
        %adjust the visibility so only the 2 Top/Bottom axes are visible
        set(handles.axes1,'visible','off');
        set(handles.axes3,'visible','off');
        set(handles.axes4,'visible','off');
        set(handles.axes5,'visible','off');
        set(handles.axes6,'visible','on');
        set(handles.axes7,'visible','on');
        set(handles.axes9,'visible','off');
        
        % Notes section has 2 choices here
        NotesChoices = {'Top';'Bottom'};
        set(handles.NotesType,'String',NotesChoices);
        
        %clear all axes other than Top/Bottom ones
        cla(handles.axes1);
        cla(handles.axes3);
        cla(handles.axes4);
        cla(handles.axes5);
        cla(handles.axes9);
        
        if(get(handles.addPlot,'Value') == 1),
            hold on
        else,
            hold off
        end
        
        
        
        %Launch the GUI with options for plotting 2 graphs
        TwoPlot

    case 3 %4 plots
        
        % remove all colobars from potential previous plots
        axes(handles.axes6);
        colorbar('off');
        axes(getappdata(plotGui,'axesHalf2'));
        colorbar('off');
        axes(handles.axes9);
        colorbar('off');
        
        %set the visibility so only the 4 small axes can be seen
        set(handles.axes1,'visible','on');
        set(handles.axes3,'visible','on');
        set(handles.axes4,'visible','on');
        set(handles.axes5,'visible','on');
        set(handles.axes6,'visible','off');
        set(handles.axes7,'visible','off');
        set(handles.axes9,'visible','off');   
        
        % 4 different graphs with note
        NotesChoices = {'Top Left' ; 'Top Right' ; 'Bottom Left' ;...
                                                           'Bottom Right'};
        
        set(handles.NotesType,'String',NotesChoices);
        
        %clear other axes so they can't be seen
        cla(handles.axes6);
        cla(handles.axes7);
        cla(handles.axes9);
        
        
        if(get(handles.addPlot,'Value') == 1),
            hold on
        else,
            hold off
        end
        
        
        
        %call the GUI that has options for plotting 4 graphs
        plot4
end


% --- Executes during object creation, after setting all properties.
function axes9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% This function will create a 2d plot and plot on the axes given in the the
% axesPlot section of data saved in the main figure. This function will
% also load any notes if they are of the form filename_notes.txt and
% display them
function plot2d
    %prompt user to select file
    [filename, pathname] = uigetfile('*','select file');
    %read in file
    data_read = dlmread([pathname,filename]);
    %get axes
    plotGui = getappdata(0,'plotGui');
    axesType = getappdata(plotGui,'axesPlot');
    %clear axes if it is not a new figure
    if axesType ~= 0,
        axes(axesType);
        if(getappdata(plotGui,'plotMore') == 0)
            cla(axesType);
        else
            hold on
        end
    else
        figure(getappdata(plotGui,'newFigureGraph'));
    end 
    %Plot the data the correct way (could be either way depending on the
    %orientation of the arrays when recorded in other programs
    data_size = size(data_read);
    
    %remove 0's
    %ind = find(data_read(:,2),1,'last');
    %plot(data_read(1:ind,1),abs(data_read(1:ind,2)).^2);
    plot(data_read(:,1),abs(data_read(:,2:end)).^2);
    
        
    
    
    
    %get notes if there are any
    Notes = '';
    [token, remain] = strtok(filename,'.'); %#ok<NASGU>
    notesFile = strcat(token,'_notes.txt');
    %if the file exists it will equal 2
    if exist(strcat(pathname,notesFile),'file') ~= 0,
       fp = fopen(strcat(pathname,notesFile),'r');
       tline = fgets(fp);
       %while there is another line
       while ischar(tline),
           %if the line is just whitespace, skip it
           if any(isstrprop(tline,'wspace') == 0)
               Notes = sprintf('%s%s',Notes,tline);
           end
           %get the next line
           tline = fgets(fp);
       end
       %close connection
       fclose(fp);
    end
    
    %get the location as to what graph this is:
    %           1 == Value 1 in the popupmenu (big graph for 1, top for 2,
    %           top left for 4)
    %           2 == Value 2 in the popupmenu (bottom for 2, top right for
    %           4)
    %           3 == Value 3 in popup menu (bottom left for 4)
    %           4 == Value 4 in popupmenu (bottom right for 4)
    Location = getappdata(plotGui,'plotLocation');
    %switch on location
    switch Location
        case 1
            setappdata(plotGui,'Notes1',Notes);
        case 2
            setappdata(plotGui,'Notes2',Notes);
        case 3
            setappdata(plotGui,'Notes3',Notes);
        case 4
            setappdata(plotGui,'Notes4',Notes);
    end

    %label the figure based on data chosen in appropriate GUI 
    xlabel(getappdata(plotGui,'xLabel'));
    ylabel(getappdata(plotGui,'yLabel'));
    titleLabel = getappdata(plotGui,'title');
    %If the user did not specify a title then set it to be the filename
    if isempty(titleLabel),
        titleLabel = filename;
    end
    title(titleLabel);
    figure(getappdata(plotGui,'plotFigure'));

    
    
% This function will plot a 3d data (based on how they are saved in
% PizeoControl GUI funcitons. They are assumed to be saved as a .mat and
% with the appropriate variables. 
function plot3d
    %prompt user to select file
    [filename, pathname] = uigetfile('*','select file');
    %load in the file
    data_read = load(sprintf('%s/%s',pathname,filename));
    
    plotGui = getappdata(0,'plotGui');
    axesType = getappdata(plotGui,'axesPlot');
    %clear axes or open new figure if appropriate
    if axesType ~= 0,
        axes(axesType);
        cla(axesType);
    else
        figure(getappdata(plotGui,'newFigureGraph'));
    end
    %plot the 3d graph
    surf(data_read.YMatrix2,data_read.ZMatrix2,data_read.PMMatrix);
    xlabel(getappdata(plotGui,'xLabel'));
    ylabel(getappdata(plotGui,'yLabel'));
    zlabel(getappdata(plotGui,'zLabel'));
    %If the user did not specify a title then set it to be the filename
    titleLabel = getappdata(plotGui,'title');
    if isempty(titleLabel),
        titleLabel = filename;
    end
    title(titleLabel);
    figure(getappdata(plotGui,'plotFigure'));
    
    %get notes if there are any
    Notes = '';
    [token, remain] = strtok(filename,'.'); %#ok<NASGU>
    notesFile = strcat(token,'_notes.txt');
    %if the file exists it will equal 2
    if exist(strcat(pathname,notesFile),'file') ~= 0,
       fp = fopen(strcat(pathname,notesFile),'r');
       tline = fgets(fp);
       %While there is another line in the file
       while ischar(tline),
           %if the line is just whitespace, skip it.
           if any(isstrprop(tline,'wspace') == 0)
               Notes = sprintf('%s%s',Notes,tline);
           end
           %get next line
           tline = fgets(fp);
       end
       %close connection
       fclose(fp);
    end
    
    %get the location as to what graph this is:
    %           1 == Value 1 in the popupmenu (big graph for 1, top for 2,
    %           top left for 4)
    %           2 == Value 2 in the popupmenu (bottom for 2, top right for
    %           4)
    %           3 == Value 3 in popup menu (bottom left for 4)
    %           4 == Value 4 in popupmenu (bottom right for 4)
    Location = getappdata(plotGui,'plotLocation');
    switch Location
        case 1
            setappdata(plotGui,'Notes1',Notes);
        case 2
            setappdata(plotGui,'Notes2',Notes);
        case 3
            setappdata(plotGui,'Notes3',Notes);
        case 4
            setappdata(plotGui,'Notes4',Notes);
    end
    
    
% This function will plot the slices (image scan) data saved in the
% PiezoControl program. This function also requires data stored to the
% main GUI.
function plotSlices
    %prompt user to select data file
    [filename, pathname] = uigetfile('*','select file');
    %load data
    data_read = load(sprintf('%s%s',pathname,filename));
    %size is needed to know how many slices to plot
    temp = size(data_read.PMMatrix3);
    plotGui = getappdata(0,'plotGui');
    axesType = getappdata(plotGui,'axesPlot');
    %Clear the appropriate axes or open a new figure
    if axesType ~= 0,
        axes(axesType);
        cla(axesType);
    else
        figure(getappdata(plotGui,'newFigureGraph'));
    end
    %plot the slices
    for j=1:1:temp(3),
        if axesType ~= 0,
            axes(axesType);
        end
        surface(data_read.XMatrix3(:,:,j), data_read.YMatrix3(:,:,j),data_read.ZMatrix3(:,:,j), data_read.PMMatrix3(:,:,j));
        alpha(.8); 

    end
    %label the axes
    xlabel(getappdata(plotGui,'xLabel'));
    ylabel(getappdata(plotGui,'yLabel'));
    zlabel(getappdata(plotGui,'zLabel'));
    
    %If the user did not specify a title then set it to be the filename
    titleLabel = getappdata(plotGui,'title');
    if isempty(titleLabel),
        titleLabel = filename;
    end
    title(titleLabel);
    %colorbar, view direction
    colorbar;
    view(3);
    drawnow;
    figure(getappdata(plotGui,'plotFigure'));

    %get notes if there are any
    Notes = '';
    [token, remain] = strtok(filename,'.'); %#ok<NASGU>
    notesFile = strcat(token,'_notes.txt');
    %if the file exists it will equal 2
    if exist(strcat(pathname,notesFile),'file') ~= 0,
       fp = fopen(strcat(pathname,notesFile),'r');
       tline = fgets(fp);
       while ischar(tline),
           if any(isstrprop(tline,'wspace') == 0)
               Notes = sprintf('%s%s',Notes,tline);
           end
           tline = fgets(fp);
       end
       fclose(fp);
    end
    
    %get the location as to what graph this is:
    %           1 == Value 1 in the popupmenu (big graph for 1, top for 2,
    %           top left for 4)
    %           2 == Value 2 in the popupmenu (bottom for 2, top right for
    %           4)
    %           3 == Value 3 in popup menu (bottom left for 4)
    %           4 == Value 4 in popupmenu (bottom right for 4)
    Location = getappdata(plotGui,'plotLocation');
    switch Location
        case 1
            setappdata(plotGui,'Notes1',Notes);
        case 2
            setappdata(plotGui,'Notes2',Notes);
        case 3
            setappdata(plotGui,'Notes3',Notes);
        case 4
            setappdata(plotGui,'Notes4',Notes);
    end
    

% --- Executes during object creation, after setting all properties.
function graphNotes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graphNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function graphNotes_Callback(hObject, eventdata, handles)
% hObject    handle to graphNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in NotesType.
function NotesType_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to NotesType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotGui = getappdata(0,'plotGui');
contents = get(hObject,'Value');
%switch on the value of the popupbar, to know which notes to display
switch contents
    case 1 %Either Top of 2 or Top Left of 4
        Notes = getappdata(plotGui,'Notes1');
    case 2 % Either Bottom of 2 or Top Right of 4
        Notes = getappdata(plotGui,'Notes2');
    case 3 % Bottom Left
        Notes = getappdata(plotGui,'Notes3');
    case 4 % Bottom Right
        Notes = getappdata(plotGui,'Notes4');
    otherwise
        return;
end
%Set the notes to be displayed
set(handles.graphNotes,'String',Notes);

% --- Executes during object creation, after setting all properties.
function NotesType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NotesType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addPlot.
function addPlot_Callback(hObject, eventdata, handles)
% hObject    handle to addPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of addPlot
plotGui = getappdata(0,'plotGui');
if( get(hObject,'Value') == 0),
    setappdata(plotGui,'plotMore',0);
else
    setappdata(plotGui,'plotMore',0);
end


% --- Executes on button press in clearAxes.
function clearAxes_Callback(hObject, eventdata, handles)
% hObject    handle to clearAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        %clear all axes
        cla(handles.axes1);
        cla(handles.axes3);
        cla(handles.axes4);
        cla(handles.axes5);
        cla(handles.axes6);
        cla(handles.axes9);


% --- Executes on button press in newFigSave.
function newFigSave_Callback(hObject, eventdata, handles)
% hObject    handle to newFigSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %get axes
 plotGui = getappdata(0,'plotGui');
 axesType = getappdata(plotGui,'axesPlot');
 newFig=figure;
 axesObject2=copyobj(axesType,newFig);
 %set(newFig,'Position',[100 200 300 400]);
 %set(axesObject2,'Position',[1 1 60 60]);


% --- Executes on button press in saveNotes.
function saveNotes_Callback(hObject, eventdata, handles)
% hObject    handle to saveNotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 %get the location as to what graph this is:
    %           1 == Value 1 in the popupmenu (big graph for 1, top for 2,
    %           top left for 4)
    %           2 == Value 2 in the popupmenu (bottom for 2, top right for
    %           4)
    %           3 == Value 3 in popup menu (bottom left for 4)
    %           4 == Value 4 in popupmenu (bottom right for 4)
    Location = getappdata(plotGui,'plotLocation');
    %switch on location
    switch Location
        case 1
            Notes = getappdata(plotGui,'Notes1');
        case 2
            Notes = getappdata(plotGui,'Notes2');
        case 3
            Notes = getappdata(plotGui,'Notes3');
        case 4
            Notes = getappdata(plotGui,'Notes4');
    end
    
    

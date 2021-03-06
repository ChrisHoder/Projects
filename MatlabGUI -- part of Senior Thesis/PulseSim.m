function varargout = PulseSim(varargin)
% PULSESIM MATLAB code for PulseSim.fig
%      PULSESIM, by itself, creates a new PULSESIM or raises the existing
%      singleton*.
%
%      H = PULSESIM returns the handle to a new PULSESIM or the handle to
%      the existing singleton*.
%
%      PULSESIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PULSESIM.M with the given input arguments.
%
%      PULSESIM('Property','Value',...) creates a new PULSESIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PulseSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PulseSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PulseSim

% Last Modified by GUIDE v2.5 11-Nov-2012 11:21:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PulseSim_OpeningFcn, ...
                   'gui_OutputFcn',  @PulseSim_OutputFcn, ...
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


% --- Executes just before PulseSim is made visible.
function PulseSim_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for PulseSim
handles.output = hObject;

%this saves the pulsesim figure to the desktop of matlab, this will allow
%us to save data to the figure and access  it easily. especially if we want
%to expand to different popup windows
setappdata(0,'hMainGui',gcf);
hMainGui = getappdata(0,'hMainGui');

%we set some initial values to this to prevent errors if the user presses
%the wrong buttons
setappdata(hMainGui,'plotCount',0);
setappdata(hMainGui,'y_end',-1);
setappdata(hMainGui,'plotQ',true);
setappdata(hMainGui,'dList',{});

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = PulseSim_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

function maxN_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function maxN_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function eta_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function eta_CreateFcn(hObject, eventdata, handles)


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function wA_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function wA_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function phiNot_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function phiNot_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function wm_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function wm_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function whf_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function whf_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function theta_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function theta_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Tp_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Tp_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_Run.
function push_Run_Callback(hObject, eventdata, handles)
% This method wil run the numerical approximation and determine both the
% probabilities of the states as a function of time as well as the final
% endstate probabilies. 

    %get the window variable
    hMainGui = getappdata(0,'hMainGui');
    %set the info bar to say that we are running the simulation
    set(handles.Running,'String','Running...');
    guidata(hObject, handles);
    
   
        
    'runing numerical approximation'
    
    %get the input data from the user
    nMax   = str2num(get(handles.maxN,'String'));
    eta    = str2num(get(handles.eta,'String'));
    wA     = str2num(get(handles.wA,'String'));
    phiNot = str2num(get(handles.phiNot,'String'));
    wm     = str2num(get(handles.wm,'String'));
    whf    = str2num(get(handles.whf,'String'));
    Theta   = str2num(get(handles.theta,'String'));
    Tp     = str2num(get(handles.Tp,'String'));
    alpha     = str2num(get(handles.Alpha,'String'));
    
    %handle the initial values for this simualtion.
    % 1 here means that we have a multipulse and want to take the output of
    % the pervious run and use it as an input
    if( get(handles.multiPulse,'Value') == 1),
       y_init = getappdata(hMainGui,'y_end');
       %check for no initialized end
       if(y_init == -1),
           y_init = generateCoherent(nMax,alpha)
       end
    % we are generating new initial conditions
    else
        %check initial condition type
        inCondValue = get(handles.InitialConditions,'Value');
        %chose a coherent state
        if( inCondValue == 1), 
            y_init = generateCoherent(nMax,alpha);
        else %put all the probability in |0>|down>
            y_init = zeros(1,2*nMax+2);
            y_init(1) = 1.0;
            
        end
    end
    
    Ho = generate_noTime_matrix(nMax,eta);
    timeInt = [-5*Tp,5*Tp];
    %run the numerical simulation
    [t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',Tp/200));
    %save the finished values for later use
    setappdata(hMainGui,'y_end',y);
    
    
    'finished'
    nValues = linspace(0,nMax*2+1,nMax*2+2);
    %save for latter use
    setappdata(hMainGui,'nValues',nValues);
    setappdata(hMainGui,'y_init',y_init);
    %print the sum
    A = sum(abs(y(end,:)).^2)
    set(handles.Sum,'String',num2str(A));
    
    %this is an internal boolean to know if we should be plotting (this
    %will not be plotted when you use the run both callback).
    plotQ = getappdata(hMainGui,'plotQ');
    if( plotQ ),
        axes(handles.axes1);
        plot(t,abs(y).^2);
        xlabel('Time');
        axes(handles.axes2);
        %y_init = y_init';
        semilogy(nValues(1:nMax+1),abs(y(end,1:(nMax+1))).^2,nValues(1:nMax+1),abs(y(end,(nMax+2):end)).^2 ...
           , nValues(1:nMax+1),abs(y_init(end,1:(nMax+1))).^2,nValues(1:nMax+1),abs(y_init(end,(nMax+2):end)).^2);
        %semilogy(nValues(1:nMax+1),abs(y_init(end,1:(nMax+1))).^2,nValues(1:nMax+1),abs(y_init(end,(nMax+2):end)).^2);
        xlabel('nValue');
        legend('downEnd','upEnd','downInitial','upInitial','location','Best');
    end
    %if the user wants to save the data
    if( get(handles.saveNumerical,'Value') == 1),
        data_out = [t, y];
        %data_out = ['function', 'overlap';data_out];
        path = pwd;
        folder = strcat(path,'/data/',datestr(now,10),datestr(now,5),datestr(now,7),'/');
        %make a folder if it doesn't exist
        if exist(folder,'dir') ~= 7,
                mkdir(folder);
        end
        %find the number of files in the folder
        sizeFolder = size(dir(folder));
        %make the size the filename
        theFileName = strcat(num2str(sizeFolder(1)),'.csv');
        fileName = num2str(sizeFolder(1));
        filePath = strcat(folder,theFileName);
        
        %dlmwrite(filePath,["function","overlap"]);
        %write the dataout
        dlmwrite(filePath,data_out);
        
        %the following is for creating the meta-data notes file
        nMax   = str2num(get(handles.maxN,'String'));
        eta    = str2num(get(handles.eta,'String'));
        wA     = str2num(get(handles.wA,'String'));
        phiNot = str2num(get(handles.phiNot,'String'));
        wm     = str2num(get(handles.wm,'String'));
        whf    = str2num(get(handles.whf,'String'));

        Theta   = str2num(get(handles.theta,'String'));
        Tp     = str2num(get(handles.Tp,'String'));

        alpha     = str2num(get(handles.Alpha,'String'));

        %save the meta-data
        fileTypeNotes = '_notes.txt';
        notesPath = strcat(folder,fileName,fileTypeNotes);
        notesOutput = sprintf('Numerical values as a function of time with following input parameters \n nMax: %s\n eta: %s \n  wA:%s \n phiNot: %s \n wm: %s \n whf: %s \n Tp: %s \n alpha: %s \n pulseArea: %s', nMax, eta,wA, phiNot,wm,whf,Tp,alpha, Theta);
        fp = fopen(notesPath,'w');
        fprintf(fp,'%s',notesOutput);
        fclose(fp);
    end
    
    
    
    set(handles.Running,'String','Ready...');


function min_Value_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function min_Value_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function max_Value_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function max_Value_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function points_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function points_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in push_Func.
function push_Func_Callback(hObject, eventdata, handles)

%this method will run the approximate and the numerical solutions as a
%function of the input parameters. The data will be generated and saved to
%the GUI so that it can be accessed later for plotting and analysis.

   %get GUI
   hMainGui = getappdata(0,'hMainGui');
   %clear the axes
   axes(handles.axes3);
   cla;

   %parameters --min/max values and points
   minValue = str2num(get(handles.min_Value,'String'));
   maxValue= str2num(get(handles.max_Value,'String'));
   points  = str2num(get(handles.points,'String'));
   
   %input parameters from the user
   nMax   = str2num(get(handles.maxN,'String'));
   eta    = str2num(get(handles.eta,'String'));
   wA     = str2num(get(handles.wA,'String'));
   phiNot = str2num(get(handles.phiNot,'String'));
   wm     = str2num(get(handles.wm,'String'));
   whf    = str2num(get(handles.whf,'String'));
   Tp     = str2num(get(handles.Tp,'String'));
   type   = get(handles.functionMenu,'Value');
   alpha  = str2num(get(handles.Alpha,'String'));
   mMax   = str2num(get(handles.mMax,'String'));
   Theta  = str2num(get(handles.theta,'String'));

   %generate the time-independent Ho matrix
   Ho = generate_noTime_matrix(nMax,eta);
   timeInt = [-5*Tp,5*Tp];
   %set inital values
   y_init = generateCoherent(nMax,alpha);
   
    
   %the list of all of the values that will be tested
   Values = linspace(minValue,maxValue,points);
   
   %create a waitbar so that the user knows how much time is left on the
   %calculation
     %Begin Data collection
    disp('Running...');
    %create progress bar
    h = waitbar(0,'-','Name','Acquiring Data...','CreateCancelBtn',...
                                   'setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0)
    
    
    % switch on the function type
   switch type,
       % pulse Area
       case 1,
        setappdata(hMainGui,'function','Pulse Area');
        %for each point
        for n = 1:points,
            %set param
            Theta = Values(n);
            [t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',Tp/100));
            waitbar((n)/(points),h,...
                              sprintf('%d / %d',n,points));
            
            output = makeApproximation(nMax,eta,phiNot,Theta,mMax,alpha);
            %add to the results matrices              
            if n == 1,
                results  = y(end,:)';
                results2 = output;
            else
                results = [results y(end,:)'];
                results2 = [results2 output];
            end
            
            
            
        
            %If somebody tries to cancel
            if getappdata(h,'canceling')
                 break
            end
        
        end
       
          
       %pulse width
       case 2,
           setappdata(hMainGui,'function','Pulse Width');
           output = makeApproximation(nMax,eta,phiNot,Theta,mMax,alpha);
           for n = 1:points,
                Tp = Values(n);
                timeInt = [-5*Tp,5*Tp];
                [t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',Tp/100));
                waitbar((n)/(points),h,...
                                  sprintf('%d / %d',n,points));

                %output = makeApproximation(nMax,eta,phiNot,Theta,mMax,alpha);
                %add to the results matrices              
                if n == 1,
                    results  = y(end,:)';
                    results2 = output;
                else
                    results = [results y(end,:)'];
                    results2 = [results2 output];
                end




                %If somebody tries to cancel
                if getappdata(h,'canceling')
                     break
                end
           end
       % Alpha
       case 3,
            setappdata(hMainGui,'function','Alpha');
            for n = 1:points,
                alpha = Values(n);
                y_init = generateCoherent(nMax,alpha);
                [t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',Tp/100));
                waitbar((n)/(points),h,...
                                  sprintf('%d / %d',n,points));
                
                output = makeApproximation(nMax,eta,phiNot,Theta,mMax,alpha);
                if n == 1,
                    results  = y(end,:)';
                    results2 = output;
                    
                else
                    results = [results y(end,:)'];
                    results2 = [results2 output];
                end

                %If somebody tries to cancel
                if getappdata(h,'canceling')
                     break
                end

            end   
       
       % phiNot
       case 4,
            setappdata(hMainGui,'function','phiNot');
            for n = 1:points,
                phiNot = Values(n);
                [t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',Tp/100));
                waitbar((n)/(points),h,...
                                  sprintf('%d / %d',n,points));
                output = makeApproximation(nMax,eta,phiNot,Theta,mMax,alpha);
                if n == 1,
                    results  = y(end,:)';
                    results2 = output;
                else
                    results = [results y(end,:)'];
                    results2 = [results2 output];
                end

                %If somebody tries to cancel
                if getappdata(h,'canceling')
                     break
                end

            end
           
 
       % eta
       case 5,
            setappdata(hMainGui,'function','eta');
            for n = 1:points,
                eta = Values(n);
                [t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',Tp/100));
                waitbar((n)/(points),h,...
                                  sprintf('%d / %d',n,points));
                output = makeApproximation(nMax,eta,phiNot,Theta,mMax,alpha);
                if n == 1,
                    results  = y(end,:)';
                    results2 = output;
                else
                    results = [results y(end,:)'];
                    results2 = [results2 output];
                end

                %If somebody tries to cancel
                if getappdata(h,'canceling')
                     break
                end

            end
       %function of omega_m     
       case 6,
           setappdata(hMainGui,'function','omega_m');
           output = makeApproximation(nMax,eta,phiNot,Theta,mMax,alpha); 
           for n = 1:points,
                wm = Values(n);
                [t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',Tp/100));
                waitbar((n)/(points),h,...
                                  sprintf('%d / %d',n,points));
                
                if n == 1,
                    results  = y(end,:)';
                    results2 = output;
                else
                    results = [results y(end,:)'];
                    results2 = [results2 output];
                end

                %If somebody tries to cancel
                if getappdata(h,'canceling')
                     break
                end

           end  
       %mmax function
       case 7,
           setappdata(hMainGui,'function','mMax');
           [t, y] = ode45(@(t,y) dxdt(t,y,nMax,Ho,eta,wA,phiNot,whf,wm,Theta,Tp),timeInt,y_init,odeset('MaxStep',Tp/100));
           for n = 1:points,
                mMax = Values(n);
                waitbar((n)/(points),h,...
                                  sprintf('%d / %d',n,points));
                output = makeApproximation(nMax,eta,phiNot,Theta,mMax,alpha); 
                if n == 1,
                    results  = y(end,:)';
                    results2 = output;
                else
                    results = [results y(end,:)'];
                    results2 = [results2 output];
                end

                %If somebody tries to cancel
                if getappdata(h,'canceling')
                     break
                end

           end
       
           
    
           
       
   end
   

    %remove waitbar
    delete(h)
   
  
   
   
   
   
   %results is the numerical solution, while result2 is the approximate
   %value
   setappdata(hMainGui,'results',results);
   setappdata(hMainGui,'results2',results2);
   setappdata(hMainGui,'Values',Values);
   
       
function nValue_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function nValue_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in up_Checkbox.
function up_Checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in push_addN.
function push_addN_Callback(hObject, eventdata, handles)
%This method will graph a specific n energy state of the output
%as a function of the input variable


A = ['-c';'-m'; '-y'; '-k'; '-r'; '-g'; '-b'];
%get values from the user
hMainGui = getappdata(0,'hMainGui');
n = str2num(get(handles.nValue,'String'));
nLabel = strcat(num2str(n),' down');
nMax = str2num(get(handles.maxN,'String'));
results = getappdata(hMainGui,'results');
results2 = getappdata(hMainGui,'results2');
Values = getappdata(hMainGui,'Values');
%determine the number plotteds
count = getappdata(hMainGui,'plotCount');
index = mod(count,7)+1;
setappdata(hMainGui,'plotCount',(count+1));
%if it is the up spin state, we want to increment the n number
if( get(handles.up_Checkbox,'Value') == 1),
    nLabel = strcat(num2str(n), ' up');
    n = nMax+n+2; 
end
%create a legend label
nLabelApprox = strcat(nLabel , ' approx');
nLabel = strcat(nLabel , ' num');
nValues = results(n+1,:);
nValues2 = results2(n+1,:);
axes(handles.axes3);
%add plot
hold on
semilogy(Values,abs(nValues).^2,A(index,:),'DisplayName',nLabel, Values,abs(nValues2).^2,A(index,:),'DisplayName',nLabelApprox);
legend('-DynamicLegend');
hold off
%label
xlabel(getappdata(hMainGui,'function'));



% --- Executes on button press in push_clear.
function push_clear_Callback(hObject, eventdata, handles)
%this method will clear axes3

axes(handles.axes3);
hMainGui = getappdata(0,'hMainGui');
setappdata(hMainGui,'plotCount',0);
cla

function Alpha_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Alpha_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in MakeCoherent.
function MakeCoherent_Callback(hObject, eventdata, handles)
%This method will make a coherent state with the given alpha and graph it
%on axes2

    
    hMainGui = getappdata(0,'hMainGui');
    set(handles.Running,'String','Running...');
    guidata(hObject, handles);
    

    nMax   = str2num(get(handles.maxN,'String'));
    alpha     = str2num(get(handles.Alpha,'String'));

    y_init = generateCoherent(nMax,alpha)
%     %generate initial values
%     y_init = zeros(2*nMax+2,1)';
%     for n = 0:nMax,
%         exp(-0.5*abs(alpha)^2)*alpha^n/sqrt(factorial(n))
%        y_init(n+1) = exp(-0.5*abs(alpha)^2)*alpha^n/sqrt(factorial(n));
%        n
%     end
    setappdata(hMainGui,'y_init',y_init);
%    y_init
%    P_init = y_init.^2
    nValues = linspace(0,nMax*2+1,nMax*2+2);
    A = sum(abs(y_init(end,:)).^2)
    set(handles.Sum,'String',num2str(A));
    axes(handles.axes1);
    xlabel('Time');
    axes(handles.axes2);
    %print out the coherent state
    y_init
    semilogy(nValues(1:nMax+1),abs(y_init(end,1:(nMax+1))).^2,nValues(1:nMax+1),abs(y_init(end,(nMax+2):end)).^2);
    axis([0 nMax 0.0001 1])
    xlabel('nValue');
    legend('down','up', 'location','Best');
    
    


% --- Executes on button press in multiPulse.
function multiPulse_Callback(hObject, eventdata, handles)

% --- Executes on selection change in InitialConditions.
function InitialConditions_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function InitialConditions_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function to_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function to_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function mMax_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function mMax_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Approx.
function Approx_Callback(hObject, eventdata, handles)
% This method will run a simulation using the approximate solution to
% generate the end state coefficients based on the users input values.

    hMainGui = getappdata(0,'hMainGui');
    nMax   = str2num(get(handles.maxN,'String'));
    %end values
    values = zeros(2*nMax+2,1);
    eta    = str2num(get(handles.eta,'String'));
    phiNot = str2num(get(handles.phiNot,'String'));
    theta   = str2num(get(handles.theta,'String'));
    
    mMax = str2num(get(handles.mMax,'String'));
    

    alpha     = str2num(get(handles.Alpha,'String'));

    % For now this is unimportant and will not be used
    
    %handle the initial values for this simualtion.
    if( get(handles.multiPulse,'Value') == 1),
       y_init = getappdata(hMainGui,'y_end');
       %check for no initialized end
       if(y_init == -1),
           y_init = generateCoherent(nMax,alpha);
       end
       
    else
        %check initial condition type
        inCondValue = get(handles.InitialConditions,'Value');
        %chose a coherent state, as the starting value
        if( inCondValue == 1), 
            %y_init = generateCoherent(nMax,alpha);
            %get the current dList from the window
%             dList = getappdata(hMainGui,'dList');
%             there is no list, create it
%             if(size(dList) == 0)
%                 dList = createDList(mMax,eta,nMax);
%                 setappdata(hMainGui,'dList',dList);
%             end
%             
            %run the simulation
            %values = UtoOperator(y_init,values,nMax,mMax,phiNot,theta,dList);
            
            wavepacket = [1 1 0 alpha];
            endValues = LaserPulseEvolution(mMax,eta,theta/2,phiNot, wavepacket)
            y_end = zeros(2*nMax+2,1);
            for m = 1:(2*mMax+1)
                row = endValues(m,:);
                nBasis = generateCoherent(nMax,row(4));
                for n = 0:nMax,
                    y_end(n+1) = y_end(n+1) + nBasis(n+1)*row(2)*row(1);
                    y_end(nMax+2+n) =y_end(nMax+2+n) + nBasis(n+1)*row(3)*row(1);
                end
            end
            values = y_end;
            
         %do initial condition in the 1,down state
        else
            y_init = zeros(2*nMax+2,1);
            y_init(1) = 1.0;
            %generate the answer
            % for each value of m ( each SHO state both up and down spin state will
            % be computed in the same loop)
            for n = 0:1:nMax,
                nDown = 0;
                nUp = 0;
                %we have a sum to calculate each value
                for m=-mMax:1:mMax,
                    %this part of each term is the same for both even and odd values
                    temp = ((1i)^m)*exp(1i*m*phiNot)*besselj(m,theta/2)*exp(-abs(m*eta)^2)*(1i*m*eta)^n*(1/(sqrt(factorial(n))));
                    if( mod(m,2) == 0),
                        %even values form the down final spin states
                        nDown = nDown + temp;
                    else
                        %up values form the up final spin states
                        nUp = nUp + temp; 
                    end

                end
                %down spin terms
                values(n+1) = nDown;
                %up spin terms
                values(nMax+2+n) = nUp;
            end
        end
    end
    

    
    
    
    %save the data
    setappdata(hMainGui,'approx',values);
    %determine if we are plotting
    plotQ = getappdata(hMainGui,'plotQ');
    if( plotQ ),
        nValues = linspace(0,nMax*2+1,nMax*2+2);
        y = abs(values).^2';
        axes(handles.axes2);
        semilogy(nValues(1:nMax+1),y(end,1:(nMax+1)),nValues(1:nMax+1),y(end,(nMax+2):end));
    end
    sumValues = sum(abs(values).^2)
    setappdata(handles.approx_sum, 'String', num2str(sumValues));
    % Update handles structure
    guidata(hObject, handles);
    
    
       


% --- Executes on button press in runBoth.
function runBoth_Callback(hObject, eventdata, handles)
% hObject    handle to runBoth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %get data
    hMainGui = getappdata(0,'hMainGui');
    nMax = str2num(get(handles.maxN,'String'));
    
    nMaxString   = get(handles.maxN,'String');
    eta    = get(handles.eta,'String');
    wA     = get(handles.wA,'String');
    phiNot = get(handles.phiNot,'String');
    wm     = get(handles.wm,'String');
    whf    = get(handles.whf,'String');
    Tp     = get(handles.Tp,'String');
    alpha  = get(handles.Alpha,'String');
    mMax   = get(handles.mMax,'String');
    Theta  = get(handles.theta,'String');
    %make the functions not plot
    setappdata(hMainGui,'plotQ',false);
    
    push_Run_Callback(hObject, eventdata, handles)
    Approx_Callback(hObject, eventdata, handles)
    %restor boolean
    setappdata(hMainGui,'plotQ',true);
    
    %retrieve data
    approxOrig = getappdata(hMainGui,'approx');
    approx = abs(approxOrig).^2';
    y_initOrig = getappdata(hMainGui,'y_init');
    y_init = abs(y_initOrig).^2;
    y_endOrig = getappdata(hMainGui,'y_end');
    y_end  = abs(y_endOrig).^2;
    endNs = y_endOrig(end,:);
    overlap = dot(approxOrig,conj(endNs)');
    overlap = abs(overlap).^2;
    o = num2str(overlap);
    set(handles.overlapAmount,'String',num2str(overlap));
    nValues = getappdata(hMainGui,'nValues');
    axes(handles.axes2);
    cla
    semilogy(nValues(1:nMax+1),approx(end,1:(nMax+1)),nValues(1:nMax+1),approx(end,(nMax+2):end),...
            nValues(1:nMax+1),y_init(end,1:(nMax+1)),nValues(1:nMax+1),y_init(end,(nMax+2):end),...
            nValues(1:nMax+1),y_end(end,1:(nMax+1)),nValues(1:nMax+1),y_end(end,(nMax+2):end));
    axes(handles.axes2);
    legend('approx down','approx up','downInitial','upInitial','numerical down','numerical up', 'location','Best');
  
    if(get(handles.saveBoth,'Value') == 1),
        %values = [nValues(1:nMax+1)';nValues(1:nMax+1)'];
        nValues2 = nValues';
        y_init2 = y_initOrig(end,:)';
        y_endData = y_endOrig(end,:)';
        data_out = [nValues2, y_init2, approxOrig,y_endData];
        %data_out = ['function', 'overlap';data_out];
        path = pwd;
        folder = strcat(path,'/data/',datestr(now,10),datestr(now,5),datestr(now,7),'/');
        %make a folder if it doesn't exist
        if exist(folder,'dir') ~= 7,
                mkdir(folder);
        end
        
        sizeFolder = size(dir(folder));
        theFileName = strcat(num2str(sizeFolder(1)),'.csv');
        fileName = num2str(sizeFolder(1));
        filePath = strcat(folder,theFileName);
        
        %dlmwrite(filePath,["function","overlap"]);
        dlmwrite(filePath,data_out);

        %save the meta-data
        fileTypeNotes = '_notes.txt';
        notesPath = strcat(folder,fileName,fileTypeNotes);
        notesOutput = sprintf('Final end states for single pulse with following input parameters \n nMax: %s\n eta: %s \n  wA:%s \n phiNot: %s \n wm: %s \n whf: %s \n Tp: %s \n alpha: %s \n mMax: %s \n pulseArea: %s', nMaxString, eta,wA, phiNot,wm,whf,Tp,alpha,mMax,Theta);
        fp = fopen(notesPath,'w');
        fprintf(fp,'%s',notesOutput);
        fclose(fp);
        
        
        
    end
    %axis([0 nMax 1e-10 1])


% --- Executes on button press in generateMatrices.
function generateMatrices_Callback(hObject, eventdata, handles)
% hObject    handle to generateMatrices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    hMainGui = getappdata(0,'hMainGui');
    nMax = str2num(get(handles.maxN,'String')); 
    mMax = str2num(get(handles.mMax,'String'));
    eta = str2num(get(handles.eta,'String'));
    dList = createDList(mMax,eta,nMax);
    setappdata(hMainGui,'dList',dList);
    'Created'


% --- Executes during object creation, after setting all properties.
function Approx_CreateFcn(hObject, eventdata, handles)

% --- Executes on selection change in functionMenu.
function functionMenu_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function functionMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to functionMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in funcRunBoth.
function funcRunBoth_Callback(hObject, eventdata, handles)

% --- Executes on button press in overlap.
function overlap_Callback(hObject, eventdata, handles)

% --- Executes on button press in plotOverlap.
function plotOverlap_Callback(hObject, eventdata, handles)
% hObject    handle to plotOverlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%A = ['-c';'-m'; '-y'; '-k'; '-r'; '-g'; '-b'];

hMainGui = getappdata(0,'hMainGui');
minValue = (get(handles.min_Value,'String'));
maxValue= (get(handles.max_Value,'String'));


nMax   = (get(handles.maxN,'String'));
eta    = (get(handles.eta,'String'));
wA     = (get(handles.wA,'String'));
phiNot = (get(handles.phiNot,'String'));
wm     = (get(handles.wm,'String'));
whf    = (get(handles.whf,'String'));
Tp     = (get(handles.Tp,'String'));
alpha  = (get(handles.Alpha,'String'));
mMax   = (get(handles.mMax,'String'));
Theta  = (get(handles.theta,'String'));


results = getappdata(hMainGui,'results');
results2 = getappdata(hMainGui,'results2');
Values = getappdata(hMainGui,'Values');
points = str2num(get(handles.points,'String'));
overlap = zeros(points,1);

%generate an overlap for each value of the function and then plot the
%overlap
for i = 1:points,
    vector1 = results(:,i);
    vector2 = results2(:,i);
    overlap(i) = dot(vector1,(vector2)');
end
axes(handles.axes3);
plot(Values,abs(overlap).^2,'DisplayName', 'overlap');

if(get(handles.saveOverlap,'Value') == 1),
    data_out = [Values',overlap];
    %data_out = ['function', 'overlap';data_out];
    path = pwd;
    folder = strcat(path,'/data/',datestr(now,10),datestr(now,5),datestr(now,7),'/');
    %make a folder if it doesn't exist
    if exist(folder,'dir') ~= 7,
            mkdir(folder);
    end
    if( strcmp(get(handles.fileName,'String'), '-') ==1)
        sizeFolder = size(dir(folder));
        theFileName = strcat(num2str(sizeFolder(1)),'.csv');
        fileName = num2str(sizeFolder(1));
        filePath = strcat(folder,theFileName);
    else
        fileName = get(handles.fileName,'String');
        filePath = strcat(folder,get(handles.fileName,'String'),'.csv');
    end
    %dlmwrite(filePath,["function","overlap"]);
    dlmwrite(filePath,data_out);
    
    %save the meta-data
    fileTypeNotes = '_notes.txt';
    notesPath = strcat(folder,fileName,fileTypeNotes);
    notesOutput = sprintf('function of: %s \n nMax: %s\n eta: %s \n  wA:%s \n phiNot: %s \n wm: %s \n whf: %s \n Tp: %s \n alpha: %s \n mMax: %s \n pulseArea: %s \n minValue: %s \n maxValue: %s \n points: %s',getappdata(hMainGui,'function'), nMax, eta,wA, phiNot,wm,whf,Tp,alpha,mMax,Theta,minValue,maxValue,get(handles.points,'String'));

%     notesOutput = sprintf('function of: ',getappdata(hMainGui,'function'),'\n'...
%         ,'nMax: ',nMax,'\n eta: ', eta,'\n  wA:',wA,'\n phiNot: ',phiNot,' \n wm:'...
%     , wm,'\n whf: ' , whf,'\n Tp: ', Tp,'\n alpha: ', alpha, '\n mMax: ',mMax,...
%     '\n pulseArea: ', Theta,'\n minValue: ',minValue,'\n maxValue: ',...
%     maxValue,'\n points: ', get(handles.points,'String'));
    fp = fopen(notesPath,'w');
    fprintf(fp,'%s',notesOutput);
    fclose(fp);
        
end


% --- Executes during object creation, after setting all properties.
function runBoth_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in saveOverlap.
function saveOverlap_Callback(hObject, eventdata, handles)

function fileName_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in saveBoth.
function saveBoth_Callback(hObject, eventdata, handles)

% --- Executes on button press in saveNumerical.
function saveNumerical_Callback(hObject, eventdata, handles)

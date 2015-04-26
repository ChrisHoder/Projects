%This method will give you the output states for the approximate solution
%with the given input values. This assumes that the initial condition will
%be a coherent state, alpha. 

function out = makeApproximation(nMax,eta,phiNot,theta,mMax,alpha)
        
    wavepacket = [1 1 0 alpha];
    endValues = LaserPulseEvolution(mMax,eta,theta/2,phiNot, wavepacket);
    y_end = zeros(2*nMax+2,1);
    for m = 1:(2*mMax+1)
        row = endValues(m,:);
        nBasis = generateCoherent(nMax,row(4));
        for n = 0:nMax,
            y_end(n+1) = y_end(n+1) + nBasis(n+1)*row(2)*row(1);
            y_end(nMax+2+n) =y_end(nMax+2+n) + nBasis(n+1)*row(3)*row(1);
        end
    end
    out = y_end;
            
       
end
    

    
    
    
%     save the data
%     setappdata(hMainGui,'approx',values);
%     plotQ = getappdata(hMainGui,'plotQ');
%     if( plotQ ),
%         nValues = linspace(0,nMax*2+1,nMax*2+2);
%         y = abs(values).^2';
%         axes(handles.axes2);
%         semilogy(nValues(1:nMax+1),y(end,1:(nMax+1)),nValues(1:nMax+1),y(end,(nMax+2):end));
%     end
%     sumValues = sum(abs(values).^2)
%     setappdata(handles.approx_sum, 'String', num2str(sumValues));
%     Update handles structure
%     guidata(hObject, handles);
%     
% hMainGui = getappdata(0,'hMainGui');
%     nMax   = str2num(get(handles.maxN,'String'));
%     %end values
%     values = zeros(2*nMax+2,1);
%     eta    = str2num(get(handles.eta,'String'));
%     phiNot = str2num(get(handles.phiNot,'String'));
%     theta   = str2num(get(handles.theta,'String'));
%     
%     mMax = str2num(get(handles.mMax,'String'));
%     
% 
%     alpha     = str2num(get(handles.Alpha,'String'));
function mainLoop(hObject, eventdata, handles)
    hMainGui = getappdata(0,'hMainGui');
    set(handles.text3,'String',0);
    set(handles.pushbutton1,'String','Stop');
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
             set(handles.text4,'String',sprintf('%d',count));
%         end
         secTime = etime(clock(),startTime);
         set(handles.text3,'String',sprintf('%d',round(secTime)));
    end
    setappdata(hMainGui,'STOPPED',1);
    set(handles.pushbutton1,'String','Start');
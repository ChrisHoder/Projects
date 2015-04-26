%mMax is the simulation size for the double infinite sum
%nMax is the number of energy states simulting (i.e. matrix size)
function out = createDList(mMax,r,nMax)
    h = waitbar(0,sprintf('0 / %d ',2*mMax+1),'Name','Generating matrices...','CreateCancelBtn',...
                                       'setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0)
    out = cell(1,2*mMax+1);
    for i = -mMax:mMax,
        %index off of 1->2*nMax+1
        out{i+mMax+1} = generateDisplacementMatrix(nMax,r*i);
        waitbar((i+mMax+1)/(2*mMax+1),h,...
                              sprintf('%d / %d',i+mMax+1,2*mMax+1));
        if getappdata(h,'canceling')
            break
        end
    end
    delete(h)
    
function out = xBeeInit(comport)
    % check to see if there are any connections to this com port
    old = instrfind('port',comport);
    if( ~isempty(old))
        fclose(old);
        delete(old);
    end
    
    out = serial(comport);
    out.Terminator = 'LF';
    %out.Terminator = 'CR';
    
    %try to open the port
    try
        fopen(out);
    catch
        warndlg(sprintf('Cannot open %s! Try Again!',comport))
        throw(exception);
    end
        
    
    % check to see if there are bytes available, if there are clear them
    if ( out.BytesAvailable > 0)
        
        fscanf(out,'%s',out.BytesAvailable);  
    end
        
       
    
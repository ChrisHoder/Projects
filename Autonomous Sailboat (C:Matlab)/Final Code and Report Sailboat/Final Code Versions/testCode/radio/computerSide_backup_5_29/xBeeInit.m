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
    fopen(out);
    
    % check to see if there are bytes available, if there are clear them
    if ( ~isempty(out))
        fscanf(out);  
    end
        
       
    
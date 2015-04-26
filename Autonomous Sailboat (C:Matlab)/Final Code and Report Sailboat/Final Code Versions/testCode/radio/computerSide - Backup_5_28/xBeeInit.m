function out = xBeeInit(comport)
    % check to see if there are any connections to this com port
    old = instrfind('Port','COM5');
    if( ~isempty(old))
        fclose(old);
        delete(old);
    end
    out = serial(comport);
    out.Terminator = 'CR';
    fopen(out);
    
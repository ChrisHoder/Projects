

    nMax   = 10;
    %end values
    values = zeros(2*nMax+2,1);
    eta    = 0.1;
    phiNot = 0;
    theta   = pi/2;
    
    mMax = 50;
    

    alpha     = pi/4;

    
    wavepacket = [1 1 0 alpha];
    %mMax
    for i = 1:100
        mMax = i;
        tic;
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
        values = y_end;
        
        mMaxApprox(i,1) = toc;
        mMaxApprox(i,2) = mMax;
    
    
    end
    
    
%     mMax =50;
%     
%     for j = 1:100,
%         nMax = j;
%         tic;
%         
%         endValues = LaserPulseEvolution(mMax,eta,theta/2,phiNot, wavepacket);
%         y_end = zeros(2*nMax+2,1);
%         for m = 1:(2*mMax+1)
%             row = endValues(m,:);
%             nBasis = generateCoherent(nMax,row(4));
%             for n = 0:nMax,
%                 y_end(n+1) = y_end(n+1) + nBasis(n+1)*row(2)*row(1);
%                 y_end(nMax+2+n) =y_end(nMax+2+n) + nBasis(n+1)*row(3)*row(1);
%             end
%         end
%         values = y_end;
%        
%         nMaxApprox(i,1) = toc;
%         nMaxApprox(i,2) = nMax;
%         
%     end
    
    

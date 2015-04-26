function out = generateDisplacementMatrix(nMax,r)
    %initialize the matrix
    values = zeros(nMax+1,nMax+1);
    for n=0:nMax,
        for m = 0:nMax
            %boundary case if r is zero and there is no kick
            if( r == 0)
                %if there is no kick then it is just evalutating <n|m>
                %which is 0 unless they are the same
                if( n==m)
                    value = 1;
                else
                    value = 0;
                end
                values(n+1,m+1) = value; 
            else
                values(n+1,m+1) = generateDisplacementElement(n,m,r);
        
            end
        end
    end

out = values;
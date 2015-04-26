%dList holds a list of all of the displacement operator matrixes for each
%kick value

%dMatrix is the displacement matrix which should already have been
%generated earlier

%mMax is the simulation extent for the double sum. while nMax is the number
%of energy states to simulate with.

function out = UtoOperator(y_init,values,nMax,mMax,phiNot,theta,dList)

    for L=0:nMax,
       LValueUp = 0;
       LValueDown = 0;
       for m = 0:nMax, 
            
            for n = -mMax:1:mMax,
                %we have to index off of 1 -> 2*nMax+1
                dMatrix = dList{n+mMax+1};
                %temp2 = (exp(1i*n*phiNot))*besselj(n,theta/2)*dMatrix(L+1,m+1);
                temp2 = ((1i)^n)*(exp(1i*n*phiNot))*besselj(n,theta/2)*dMatrix(L+1,m+1);
                %even values, no spin flips
                if( mod(n,2) == 0),
                   temp = temp2*y_init(m+1);
                   temp3 = temp2*y_init(nMax+2+m);
                   LValueUp = LValueUp + temp;
                   LValueDown = LValueDown + temp3;
                else
                    %odd values, spin flips
                    temp = temp2*y_init(nMax+2+m);
                    temp3 = temp2*y_init(m+1);
                    LValueUp = LValueUp + temp;
                    LValueDown = LValueDown + temp3;
                end

            end
       end
       values(L+1) = LValueDown;
       values(nMax+2+L) = LValueUp;
        
 
    end
    out = values;



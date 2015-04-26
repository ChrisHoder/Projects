
    nMax = 10;
    mMax = 50;
    alpha = pi/4;
    eta = 0.1;
    wA = 1;
    phiNot = 0;
    y_init = generateCoherent(nMax,alpha);
    y_approx = zeros(2*nMax+2,1);

    %y_init = [1,0,0,0];
    wm = 2*pi/10000;
    whf = 2*pi;

    Theta = 100*pi; %pulse area
    Tp = 0.2; %pulse width
    Ho = generate_noTime_matrix(nMax,eta);
    timeInt = [-5*Tp,5*Tp];
% 
    Ho = generate_noTime_matrix(nMax,eta);
    timeInt = [-5*Tp,5*Tp];
    %set inital values
    y_init = generateCoherent(nMax,alpha);
   
    %run points from 1 -> 50
    
    minValue = pi/10;
    maxValue = 3*pi;
    
    type = 1;
    
    for i = 1:50,
        points = i;
        tic;
        %the list of all of the values that will be tested
        Values = linspace(minValue,maxValue,points);

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
            for n = 1:points,
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

       end


        %remove waitbar
        delete(h)
   
  
        parameterFunction(i,1) = toc;
        parameterFunction(i,2) = i;
   
    end
   
  
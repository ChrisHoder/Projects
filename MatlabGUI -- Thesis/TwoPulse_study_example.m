clear all;
close all;

%Here will be a first stab at simulating an experiment wherein we send in
%two pairs of overlapped lin-perp-lin pulses and vary the time between them
%to try to see a collapse and revival.

%NumOrders is the number of diffracted orders to keep track of.
NumOrders = 1;

%The initial spin state is given by c0 |0> + c1 |1>.
c0Initial = 1;
c1Initial = 0;

%Initially all of the population is in a single coherent state
AmplitudeInitial = 1;

%And for now we'll take that coherent state to be the ground state for
%simplicity
AlphaInitial = 3;

%Initially there is a single wavepacket as follows:
%(AmplitudeInitial is really the amplitude of a given coherent state.
%So we should always have sum of abs(amplitude)^2 = 1 and |c0|^2 + |c1|^2 = 1.)
InitialWavePacket = [AmplitudeInitial c0Initial c1Initial AlphaInitial];

%There are other experimental parameters we care about:
%(times in ns and frequencies in GHz)
Eta = 0.1;
RabiAngle = pi/2;
%wAOM = 2*pi*0.42;
fTrap = 0.001;
wTrap = 2*pi*fTrap;
% wHF = 2*pi*12.642815;
wHF = 2*pi*10;
wAOM = 2*pi*0.42;
%wAOM = 0;
AomStartPhase = 0;

% StartRabiAngle = 0;
% StopRabiAngle = 2*pi;
% NumAngleSteps = 100;
% RabiAngles = linspace(StartRabiAngle, StopRabiAngle, NumAngleSteps);

% DelayTime = 0;
% SecondAomPhaseStart = 0;
% SecondAomPhaseStop = 2*pi;
% NumPhaseSteps = 100;

% SecondAomPhases = linspace(SecondAomPhaseStart,SecondAomPhaseStop,NumPhaseSteps);

SecondAomPhase = pi;

StartTime = 0;
StopTime = 5; 
NumTimeSteps = 1000;

DelayTimes = linspace(StartTime, StopTime, NumTimeSteps);

Brightnesses = zeros(NumTimeSteps,1);

tic;

for j = 1:NumTimeSteps
    
    WavePackets = LaserPulseEvolution(NumOrders, Eta, RabiAngle, AomStartPhase, InitialWavePacket);
    
%    FinalWavePackets = WavePackets;
    
%     %We evolve the wavepackets for a certain delay time:
    IntermediateWavePackets = FreeEvolve(WavePackets, wTrap ,wHF, DelayTimes(j));
    
    %Then we apply a second pulse to each wavepacket, which further splits
    %up the motional state:
%     FinalWavePackets = LaserPulseEvolution(NumOrders, Eta, RabiAngle, ...
%         wAOM*DelayTimes(j)+SecondAomPhase, WavePackets(1,:));

% This takes the component of the state vector that is in the lowest
% momentum coherent state and acts on it with a laser pulse time evolution
        FinalWavePackets = LaserPulseEvolution(NumOrders, Eta, RabiAngle, ...
            wAOM*DelayTimes(j)+SecondAomPhase, IntermediateWavePackets(1,:));
 
% now we continue for all of the other momentum states; each one is in turn called
% NthWavePackets" and is then stacked onto the array of state vectors in FinalWavePackets  
% CC Comment:  Why not just add the 
    for n = 2:2*NumOrders+1
        
        NthWavePackets = LaserPulseEvolution(NumOrders, Eta, RabiAngle, ...
            wAOM*DelayTimes(j)+SecondAomPhase, IntermediateWavePackets(n,:));
        FinalWavePackets = [FinalWavePackets; NthWavePackets];
        
    end
    
    %     SecondAomPhase = pi;
    %
    %     FinalWavePackets = WavePackets;
    
    %And now we have the final state, represented by FinalWavePackets. Now
    %we need to figure out how bright this state will be.
    
    CoherentStateAmplitudes = FinalWavePackets(:,1) .* FinalWavePackets(:,3);
    CoherentStateAlphas= FinalWavePackets(:,4);
    
    sizeOfArray = size(FinalWavePackets);
    length = sizeOfArray(1);
    
    %Below we will calculate TotalOverlapBrightProjection, which is the overlap
    %<psi|psi>, where |psi> is the projection of the final state onto the
    %bright state, i.e. <1|psi_final>. This is accomplished by calculating the
    %overlap of each coherent state contributing to the motional state with
    %every other coherent state (while also keeping track of their relative
    %amplitudes).
    TotalOverlapBrightProjection = 0;
    NumWavepackets = length;
    for n = 1:NumWavepackets
        %Below, I have replaced the commented-out code within the for loop with
        %a more vectorized version that should do the same thing. The more
        %vectorized version is roughly 22 times faster than the more clearly
        %written version (benchmarked by timing how long it takes to run this
        %loop 1000 times -- 55 seconds for the old version and 2.4 seconds for
        %the vectorized version).
        %Note: now there is a double-commented section of code, which the
        %singly-commented section of code was meant to replace, and which was
        %(to me) more transparent than the singly-commented code.
        alphaN = CoherentStateAlphas(n);
        amplitudeN = CoherentStateAmplitudes(n);
        
        alphaMs = CoherentStateAlphas(n+1:NumWavepackets);
        amplitudeMs = CoherentStateAmplitudes(n+1:NumWavepackets);
        
        CoefficientMNs = conj(amplitudeMs)*amplitudeN;
        ExpFactorMNs = exp(conj(alphaMs)*alphaN - (abs(alphaN)^2)/2 - ...
            (alphaMs .* conj(alphaMs))/2);
        AmplitudeMNs = CoefficientMNs .* ExpFactorMNs;
        
        ProbabilityBrightN = abs(amplitudeN)^2 + sum(AmplitudeMNs) ...
            + sum(conj(AmplitudeMNs));
        
        TotalOverlapBrightProjection = TotalOverlapBrightProjection + ...
            ProbabilityBrightN;
        
        
        %         ProbabilityBrightN = abs(CoherentStateAmplitudes(n))^2;
        %
        %         for m = n+1:NumWavepackets
        %             alphaM = CoherentStateAlphas(m);
        %             alphaN = CoherentStateAlphas(n);
        %             AmplitudeMN = CoherentStateAmplitudes(m)' * ...
        %                 CoherentStateAmplitudes(n) * ...
        %                 exp(alphaM' * alphaN - (abs(alphaM)^2)/2 - (abs(alphaN)^2)/2);
        %             ProbabilityBrightN = ProbabilityBrightN + AmplitudeMN + AmplitudeMN';
        %
        %
        %         end
        %         TotalOverlapBrightProjection = TotalOverlapBrightProjection + ...
        %             ProbabilityBrightN;
        
        % %                 ProbabilityBrightN = 0;
        % %                 for m = 1:NumWavepackets
        % %                     alphaM = CoherentStateAlphas(m);
        % %                     alphaN = CoherentStateAlphas(n);
        % %                     AmplitudeMN = CoherentStateAmplitudes(m)' * ...
        % %                         CoherentStateAmplitudes(n) * ...
        % %                         exp(alphaM' * alphaN - (abs(alphaM)^2)/2 - (abs(alphaN)^2)/2);
        % %                     ProbabilityBrightN = ProbabilityBrightN + AmplitudeMN;
        % %
        % %
        % %                 end
        % %                 TotalOverlapBrightProjection = TotalOverlapBrightProjection + ...
        % %                     ProbabilityBrightN;
        
    end
    %   Brightness = abs(TotalOverlapBrightProjection)^2;
    Brightnesses(j) = TotalOverlapBrightProjection;
    
end

toc

zeroAmplitudes = FinalWavePackets(:,1).*FinalWavePackets(:,2);
oneAmplitudes = FinalWavePackets(:,1).*FinalWavePackets(:,3);

 darkPercent = sum(abs(zeroAmplitudes).*abs(zeroAmplitudes))
 brightPercent = sum(abs(oneAmplitudes).*abs(oneAmplitudes))
 totalAmplitude = darkPercent+brightPercent

FinalWavePackets;


% sum(abs(FinalAmplitudes).*abs(FinalAmplitudes))
%
plot(DelayTimes,Brightnesses)

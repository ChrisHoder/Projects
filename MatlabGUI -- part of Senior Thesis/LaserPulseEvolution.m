function [matrixout] = LaserPulseEvolution(NumOrders, Eta, RabiAngle, AomPhase, WavePacket)

%This function is given an initial wavepacket consisting of (amplitude, c0,
%c1, alpha), where c0 and c1 are the relative amplitudes of the |0> and |1>
%states, alpha indexes the coherent state, and amplitude is the relative
%amplitude of the coherent state (compared to other coherent states
%contributing to the motional wavefunction). It then computes the effect of
%a single lin-perp-lin pulse pair, i.e. Bessel diffraction into multiple
%wavepackets etc.

%NumOrders is the number of Bessel diffraction orders to keep track of.
%Eta is the Lamb-Dicke parameter (DeltaK dot x).
%RabiAngle is the effective Rabi angle of the impinging pulses.
%AomPhase is the phase of the AOM at the time of the pulse.
%WavePacket contains information about the input spin and motional state,
%as described above.

%Below, the code before the dashed line accomplishes the same thing as the
%commented out code below the dashed line, but in a vectorized manner,
%making it nearly 10 times faster.

DiffractionOrders = [-NumOrders:NumOrders]';

amplitude = WavePacket(1,1);
c0 = WavePacket(1,2);
c1 = WavePacket(1,3);
alpha = WavePacket(1,4);

%AmplitudePhaseComponents = exp(1i * DiffractionOrders * ...
%    (AomPhase + real(alpha)*Eta + pi/2));
% AmplitudeBesselComponents = amplitude*besselj(DiffractionOrders, RabiAngle)';
% AmplitudesOut = AmplitudeBesselComponents*AmplitudePhaseComponents;

AmplitudesOut = amplitude * ... 
    exp(1i * DiffractionOrders * (AomPhase + real(alpha)*Eta + pi/2)) .* ...
   besselj(DiffractionOrders, RabiAngle);

c0s = zeros(2*NumOrders+1,1);
c1s = zeros(2*NumOrders+1,1);

for n = -NumOrders:NumOrders
    m = n + NumOrders + 1;
   if mod(n,2) == 0
      c0s(m) = c0;
      c1s(m) = c1;
   else
      c0s(m) = c1;
      c1s(m) = c0;
   end
   %attempt to make it a cosine pulse (doesn't work, appears to be included
   % above as a pi/2
   %c0s(m) = (1i)^n * c0s(m);
   %c1s(m) = (1i)^n * c1s(m);
   
end

AlphasOut = alpha + DiffractionOrders * 1i * Eta;

WavePacketsOut = [AmplitudesOut c0s c1s AlphasOut];

%----------------------------------------------------------

% WavePacketsOut = zeros(2*NumOrders+1,4);
% 
% amplitude = WavePacket(1,1);
% c0 = WavePacket(1,2);
% c1 = WavePacket(1,3);
% alpha = WavePacket(1,4);
% 
%     function [coeff] = DiffractionCoeff(n)
%        coeff = 1i^n * exp(1i*n*AomPhase) * besselj(n,RabiAngle);
%     end
% 
% for n = -NumOrders:NumOrders
%     
%    if mod(n,2) == 0
%        Nthc0 = c0;
%        Nthc1 = c1;
%    else
%        Nthc0 = c1;
%        Nthc1 = c0;
%    end
%    
%    NthAlpha = alpha + n*1i*Eta;
%    NthAmplitude = amplitude * DiffractionCoeff(n) * exp(1i * Eta * real(alpha) * n);
%    
%    WavePacketsOut(n+NumOrders+1,:) = [NthAmplitude Nthc0 Nthc1 NthAlpha];
%     
% end

matrixout = WavePacketsOut;

end
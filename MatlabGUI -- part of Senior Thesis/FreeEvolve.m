function [matrixout] = FreeEvolve(WavePackets, wTrap, wHF, DeltaT)

matrixout = [WavePackets(:,1) WavePackets(:,2)*exp(1i*wHF*DeltaT/2) ...
    WavePackets(:,3)*exp(-1i*wHF*DeltaT/2) WavePackets(:,4)*exp(-1i*wTrap*DeltaT)];
end
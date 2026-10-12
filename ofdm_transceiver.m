
%% OFDM Transceiver: Pilot Estimation + ZF vs MMSE
% Base MATLAB implementation
% QPSK | OFDM | Multipath | AWGN | LS Channel Estimation
% Zero-Forcing and MMSE Equalization

clear;
clc;
close all;
rng(42);

%% 1. System Parameters
Nfft = 64;
Ncp = 16;
numSymbols = 2000;

pilotSpacing = 4;
pilotIdx = 1:pilotSpacing:Nfft;
dataIdx = setdiff(1:Nfft, pilotIdx);

numPilots = numel(pilotIdx);
numData = numel(dataIdx);
SNRdB = 0:2:24;

numBits = 2 * numData * numSymbols;

fprintf('========================================\n');
fprintf(' OFDM: ZF vs MMSE Equalization\n');
fprintf('========================================\n');
fprintf('FFT size           : %d\n', Nfft);
fprintf('Cyclic prefix      : %d\n', Ncp);
fprintf('Pilot subcarriers  : %d\n', numPilots);
fprintf('Data subcarriers   : %d\n', numData);
fprintf('Information bits   : %d\n\n', numBits);

%% 2. Multipath Channel
h = [0.9; 0.4*exp(1j*0.5); 0.2*exp(-1j*0.8)];
h = h / norm(h);

channelLength = length(h);

if Ncp < channelLength - 1
    error('Cyclic prefix is too short for this channel.');
end

H = fft(h, Nfft);

%% 3. Generate Information Bits
txBits = randi([0 1], numBits, 1);

bI = txBits(1:2:end);
bQ = txBits(2:2:end);

% Unit-average-power QPSK
dataSymbols = ((1 - 2*bI) + 1j*(1 - 2*bQ)) / sqrt(2);
dataSymbols = reshape(dataSymbols, numData, numSymbols);

%% 4. Insert Known Pilot Symbols
% BPSK pilots with unit power
pilotSymbols = ones(numPilots, numSymbols);

X = zeros(Nfft, numSymbols);
X(dataIdx,:) = dataSymbols;
X(pilotIdx,:) = pilotSymbols;

%% 5. OFDM Modulation
x = ifft(X, Nfft, 1) * sqrt(Nfft);

% Add cyclic prefix to every OFDM symbol
xCP = [x(end-Ncp+1:end,:); x];

%% 6. Multipath Channel
% Process each OFDM symbol separately.
% This avoids inter-symbol boundary effects in the simulation.

rxClean = zeros(Nfft, numSymbols);

for n = 1:numSymbols
    yBlock = conv(xCP(:,n), h);

    % Remove cyclic prefix after channel propagation
    rxClean(:,n) = yBlock(Ncp+1:Ncp+Nfft);
end

%% 7. Initialize BER Arrays
BER_ZF = zeros(size(SNRdB));
BER_MMSE = zeros(size(SNRdB));
BER_Perfect = zeros(size(SNRdB));

signalPower = mean(abs(rxClean(:)).^2);

%% 8. SNR Sweep
for k = 1:numel(SNRdB)

    snrLinear = 10^(SNRdB(k)/10);

    % Complex AWGN variance per complex sample
    noiseVar = signalPower / snrLinear;

    noise = sqrt(noiseVar/2) .* ...
        (randn(size(rxClean)) + 1j*randn(size(rxClean)));

    rx = rxClean + noise;

    %% 9. OFDM Demodulation
    Y = fft(rx, Nfft, 1) / sqrt(Nfft);

    %% 10. Pilot-Based LS Channel Estimation
    Hpilot = Y(pilotIdx,:) ./ pilotSymbols;

    Hest = zeros(Nfft, numSymbols);

    for n = 1:numSymbols
        Hest(:,n) = interp1( ...
            pilotIdx, Hpilot(:,n), ...
            (1:Nfft).', 'linear', 'extrap');
    end

    %% 11. Zero-Forcing Equalization
    HestSafe = Hest;
    HestSafe(abs(HestSafe) < 1e-8) = 1e-8;

    X_ZF = Y ./ HestSafe;

    %% 12. MMSE Equalization
    % For unit-power data symbols:
    % W = conj(H) / (abs(H)^2 + noiseVar)
    W_MMSE = conj(Hest) ./ ...
        (abs(Hest).^2 + noiseVar);

    X_MMSE = Y .* W_MMSE;

    %% 13. Perfect Channel Knowledge Reference
    Hperfect = repmat(H, 1, numSymbols);

    X_Perfect = Y ./ Hperfect;

    %% 14. Extract Data Subcarriers
    zZF = X_ZF(dataIdx,:);
    zMMSE = X_MMSE(dataIdx,:);
    zPerfect = X_Perfect(dataIdx,:);

    zZF = zZF(:);
    zMMSE = zMMSE(:);
    zPerfect = zPerfect(:);

    %% 15. QPSK Demodulation: ZF
    bitsZF = zeros(numBits,1);

    bitsZF(1:2:end) = real(zZF) < 0;
    bitsZF(2:2:end) = imag(zZF) < 0;

    %% 16. QPSK Demodulation: MMSE
    bitsMMSE = zeros(numBits,1);

    bitsMMSE(1:2:end) = real(zMMSE) < 0;
    bitsMMSE(2:2:end) = imag(zMMSE) < 0;

    %% 17. QPSK Demodulation: Perfect CSI
    bitsPerfect = zeros(numBits,1);

    bitsPerfect(1:2:end) = real(zPerfect) < 0;
    bitsPerfect(2:2:end) = imag(zPerfect) < 0;

    %% 18. BER Calculation
    BER_ZF(k) = mean(txBits ~= bitsZF);
    BER_MMSE(k) = mean(txBits ~= bitsMMSE);
    BER_Perfect(k) = mean(txBits ~= bitsPerfect);

    fprintf(['SNR = %2d dB | ZF = %.6g | ' ...
        'MMSE = %.6g | Perfect CSI = %.6g\n'], ...
        SNRdB(k), BER_ZF(k), BER_MMSE(k), BER_Perfect(k));

end

%% 19. Plot BER Comparison
% Display a small positive floor for zero-error points.
% The floor is a plotting aid, not a measured BER.

berFloor = 1/numBits;

figure('Name','OFDM Equalizer BER Comparison');

semilogy(SNRdB, max(BER_ZF,berFloor), 'o-', ...
    'LineWidth',1.7, 'MarkerSize',6);
hold on;

semilogy(SNRdB, max(BER_MMSE,berFloor), 's-', ...
    'LineWidth',1.7, 'MarkerSize',6);

semilogy(SNRdB, max(BER_Perfect,berFloor), 'd-', ...
    'LineWidth',1.7, 'MarkerSize',6);

grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('OFDM: ZF vs MMSE vs Perfect Channel Knowledge');

legend('Pilot-based ZF', ...
       'Pilot-based MMSE', ...
       'Perfect CSI + ZF', ...
       'Location','southwest');

%% 20. Plot True and Estimated Channel
figure('Name','Channel Estimation');

plot(1:Nfft, abs(H), 'k-', 'LineWidth',1.8);
hold on;

plot(1:Nfft, abs(Hest(:,end)), 'b--', 'LineWidth',1.5);

plot(pilotIdx, abs(Hpilot(:,end)), 'ro', ...
    'MarkerSize',5);

grid on;
xlabel('Subcarrier Index');
ylabel('Channel Magnitude');
title('True Channel vs Pilot-Based Estimate');

legend('True Channel', ...
       'Interpolated Estimate', ...
       'Pilot Estimates', ...
       'Location','best');

%% 21. Plot Channel Frequency Response
figure('Name','Channel Frequency Response');

subplot(2,1,1);
plot(0:Nfft-1, 20*log10(abs(H)+1e-12), ...
    'LineWidth',1.5);
grid on;
xlabel('Subcarrier Index');
ylabel('Magnitude (dB)');
title('Multipath Channel Magnitude');

subplot(2,1,2);
plot(0:Nfft-1, unwrap(angle(H)), ...
    'LineWidth',1.5);
grid on;
xlabel('Subcarrier Index');
ylabel('Phase (rad)');
title('Multipath Channel Phase');

%% 22. Final Summary
fprintf('\nSimulation completed successfully.\n');
fprintf('Channel taps        : %d\n', channelLength);
fprintf('Channel estimation  : Pilot-based LS\n');
fprintf('Equalizers          : ZF and MMSE\n');
fprintf('Channel variation   : Static across OFDM symbols\n');
fprintf('Receiver timing     : Ideal synchronization\n');
fprintf('Channel knowledge   : Estimated for ZF/MMSE; perfect for reference\n');

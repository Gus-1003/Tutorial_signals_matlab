%% DETECÇÃO DE RUÍDO E ARTEFATOS EM SINAIS
% Objetivo: entender como ruído/artefatos alteram o espectro do sinal

% Ruído (noise):
% variação aleatória, geralmente contínua (parte do sistema + erro de medição)

% Artefato (artifact):
% perturbação não desejada e estruturada

% OBS.: Todo artefato "suja" o sinal, mas nem todo ruído é um artefato

clc
clear
close all

%% =========================================
% 1. PARÂMETROS
% =========================================

samplingFrequencyHz = 1000;   % taxa de amostragem
timeStep = 1 / samplingFrequencyHz;
signalDuration = 5;           % segundos

timeVector = 0:timeStep:signalDuration-timeStep;

%% =========================================
% 2. SINAL LIMPO (SEM RUÍDO)
% =========================================
% Um sinal pode ser composto por múltiplas frequências

signal8Hz = sin(2*pi*8*timeVector);
signal30Hz = sin(2*pi*30*timeVector);

cleanSignal = signal8Hz + signal30Hz;

figure
plot(timeVector, cleanSignal)
title('Sinal limpo (8 Hz + 30 Hz)')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])

%% =========================================
% 3. ADICIONANDO RUÍDOS / ARTEFATOS
% =========================================

% White noise (ruído aleatório)
whiteNoise = randn(size(timeVector));

% Brown noise (drift lento)
brownNoise = cumsum(randn(size(timeVector)));

% Artefato tipo spike (evento abrupto)
artifactSpike = zeros(size(timeVector));
artifactSpike(2000:2010) = 10;

% Sinais contaminados
signalWhite = cleanSignal + 0.5*whiteNoise;
signalBrown = cleanSignal + 0.01*brownNoise;
signalSpike = cleanSignal + artifactSpike;

%% Visualização

figure

subplot(3,1,1)
plot(timeVector, signalWhite)
title('Sinal + White noise')
xlim([0 1])

subplot(3,1,2)
plot(timeVector, signalBrown)
title('Sinal + Brown noise (drift)')
xlim([0 1])

subplot(3,1,3)
plot(timeVector, signalSpike)
title('Sinal + Artefato (spike)')
xlim([0 1])

%% =========================================
% 4. PSD (POWER SPECTRAL DENSITY)
% =========================================
% PSD mostra como a energia do sinal está distribuída nas frequências

windowLength = samplingFrequencyHz;
nFFT = 1000;

[psdClean, f] = pwelch(cleanSignal, windowLength, [], nFFT, samplingFrequencyHz);
[psdWhite, ~] = pwelch(signalWhite, windowLength, [], nFFT, samplingFrequencyHz);
[psdBrown, ~] = pwelch(signalBrown, windowLength, [], nFFT, samplingFrequencyHz);
[psdSpike, ~] = pwelch(signalSpike, windowLength, [], nFFT, samplingFrequencyHz);

%% Visualização da PSD

figure

subplot(4,1,1)
plot(f, psdClean)
title('PSD - Sinal limpo')
xlim([0 100])

subplot(4,1,2)
plot(f, psdWhite)
title('PSD - White noise')
xlim([0 100])

subplot(4,1,3)
plot(f, psdBrown)
title('PSD - Brown noise')
xlim([0 100])

subplot(4,1,4)
plot(f, psdSpike)
title('PSD - Artefato (spike)')
xlim([0 100])

%% =========================================
% 5. CONCEITO: SLOPE ESPECTRAL
% =========================================
% Em escala log-log, a PSD revela padrões:
% White noise → slope ~ 0
% Pink noise → slope ~ -1
% Brown noise → slope ~ -2

%% Função para calcular slope

computeSlope = @(psd, freq) ...
    polyfit(log10(freq(freq>0)), log10(psd(freq>0)), 1);

%% Calculando slopes

slopeClean = computeSlope(psdClean, f);
slopeWhite = computeSlope(psdWhite, f);
slopeBrown = computeSlope(psdBrown, f);
slopeSpike = computeSlope(psdSpike, f);

%% Visualização log-log

figure

logFreq = log10(f(f>0));

subplot(2,2,1)
plot(logFreq, log10(psdClean(f>0)))
title(['Clean | slope=' num2str(slopeClean(1),2)])

subplot(2,2,2)
plot(logFreq, log10(psdWhite(f>0)))
title(['White | slope=' num2str(slopeWhite(1),2)])

subplot(2,2,3)
plot(logFreq, log10(psdBrown(f>0)))
title(['Brown | slope=' num2str(slopeBrown(1),2)])

subplot(2,2,4)
plot(logFreq, log10(psdSpike(f>0)))
title(['Spike | slope=' num2str(slopeSpike(1),2)])

%% =========================================
% 6. DETECÇÃO DE PICOS NA PSD
% =========================================
% Picos indicam frequências dominantes no sinal

figure
plot(f, psdWhite)
hold on

[peakValues, peakLocations] = findpeaks(psdWhite, f, ...
    'MinPeakHeight', mean(psdWhite)*3);

plot(peakLocations, peakValues, 'ro')

title('Detecção de picos na PSD')
xlabel('Frequência (Hz)')
ylabel('PSD')
xlim([0 100])
grid on

%% =========================================
% 7. DETECÇÃO DE BURSTS (EVENTOS TRANSITÓRIOS)
% =========================================
% Bursts são aumentos rápidos de energia no tempo

signalPower = signalSpike.^2;

threshold = 5 * mean(signalPower);

burstIndices = find(signalPower > threshold);

figure

subplot(2,1,1)
plot(timeVector, signalSpike)
hold on
plot(timeVector(burstIndices), signalSpike(burstIndices), 'ro')
title('Detecção de burst no sinal')

subplot(2,1,2)
plot(timeVector, signalPower)
hold on
yline(threshold, 'r--')
title('Energia do sinal + threshold')

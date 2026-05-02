%% POWER SPECTRAL DENSITY (PSD) - MÉTODO DE WELCH
% Objetivo: analisar o conteúdo espectral de sinais

clc
clear
close all

%% =========================================
% 1. IMPORTAÇÃO DE DADOS
% =========================================

dataFolder = 'dados_da_aula';
dataFile = fullfile(dataFolder, 'complexSignals.mat');

load(dataFile)
% Esperado:
% complexSignal, signal10Hz, signal30Hz, signal100Hz, timeVector, noiseSignal

addpath('libs') % funções auxiliares (ex: eegfilt)

%% =========================================
% 2. PARÂMETROS
% =========================================

samplingFrequencyHz = 1000;

%% =========================================
% 3. VISUALIZAÇÃO DO SINAL NO TEMPO
% =========================================
% Sinais no tempo mostram variação ao longo do tempo,
% mas não revelam claramente as frequências presentes

figure
plot(timeVector, complexSignal)
xlabel('Tempo (s)')
ylabel('Amplitude')
title('Sinal complexo (domínio do tempo)')
xlim([0 1])

%% =========================================
% 4. CONCEITO: POWER SPECTRAL DENSITY (PSD)
% =========================================
% PSD indica quanta energia (potência) existe em cada frequência
% Diferente da FFT, a PSD é mais estável e robusta para sinais reais
%
% O método de Welch divide o sinal em janelas e calcula a média dos espectros

%% =========================================
% 5. PSD DO SINAL COMPLEXO
% =========================================

signalInput = complexSignal;

windowLength = samplingFrequencyHz; % tamanho da janela
overlapSamples = [];                % sem sobreposição
nFFTPoints = 1000;

[powerSpectralDensity, frequencyAxis] = pwelch( ...
    signalInput, ...
    windowLength, ...
    overlapSamples, ...
    nFFTPoints, ...
    samplingFrequencyHz);

figure
plot(frequencyAxis, powerSpectralDensity)
xlabel('Frequência (Hz)')
ylabel('PSD (Amplitude²/Hz)')
title('PSD - Sinal complexo')
xlim([0 150])
grid on

%% =========================================
% 6. PSD COM RUÍDO
% =========================================
% Ruído adiciona energia distribuída em várias frequências

signalWithNoise = complexSignal + 10 * noiseSignal;

[psdNoise, frequencyAxis] = pwelch( ...
    signalWithNoise, ...
    windowLength, ...
    overlapSamples, ...
    nFFTPoints, ...
    samplingFrequencyHz);

figure
plot(frequencyAxis, psdNoise)
xlabel('Frequência (Hz)')
ylabel('PSD (Amplitude²/Hz)')
title('PSD - Sinal com ruído')
xlim([0 150])
grid on

%% =========================================
% 7. AVALIAÇÃO DE BANDAS DE FREQUÊNCIA
% =========================================
% Podemos quantificar a potência em bandas específicas

band10Hz_idx = find(frequencyAxis >= 8 & frequencyAxis <= 12);
band30Hz_idx = find(frequencyAxis >= 20 & frequencyAxis <= 40);
band100Hz_idx = find(frequencyAxis >= 90 & frequencyAxis <= 110);

power10Hz = sum(psdNoise(band10Hz_idx));
power30Hz = sum(psdNoise(band30Hz_idx));
power100Hz = sum(psdNoise(band100Hz_idx));

%% Identificação de picos

[peakPower, peakIndex] = max(psdNoise);
peakFrequency = frequencyAxis(peakIndex);

[peakPower30Hz, idx30] = max(psdNoise(band30Hz_idx));
peakFrequency30Hz = frequencyAxis(band30Hz_idx(idx30));

[peakPower100Hz, idx100] = max(psdNoise(band100Hz_idx));
peakFrequency100Hz = frequencyAxis(band100Hz_idx(idx100));

%% Plot com marcação dos picos

figure
plot(frequencyAxis, psdNoise)
hold on

plot(peakFrequency, peakPower, 'ro')
plot(peakFrequency30Hz, peakPower30Hz, 'ro')
plot(peakFrequency100Hz, peakPower100Hz, 'ro')

text(peakFrequency, peakPower, num2str(peakPower))
text(peakFrequency30Hz, peakPower30Hz, num2str(peakPower30Hz))
text(peakFrequency100Hz, peakPower100Hz, num2str(peakPower100Hz))

xlabel('Frequência (Hz)')
ylabel('PSD')
title('PSD com identificação de picos')
xlim([0 150])
grid on

%% =========================================
% 8. TIPOS DE RUÍDO
% =========================================
% Diferentes ruídos têm distribuições espectrais diferentes

whiteNoise = 100 * noiseSignal;          % energia uniforme
brownNoise = cumsum(noiseSignal);        % energia concentrada em baixas frequências

nSamples = length(timeVector);
randomPhase = exp(1i * 2 * pi * rand(1, nSamples/2));
decay = exp(-(1:nSamples/2)/50);
pinkSpectrum = randomPhase .* (0.1 + decay);
pinkSpectrum = [pinkSpectrum pinkSpectrum(end:-1:1)];
pinkNoise = real(ifft(pinkSpectrum)) * nSamples;

%% PSD dos ruídos

[psdWhite, f] = pwelch(whiteNoise, windowLength, overlapSamples, nFFTPoints, samplingFrequencyHz);
[psdBrown, ~] = pwelch(brownNoise, windowLength, overlapSamples, nFFTPoints, samplingFrequencyHz);
[psdPink, ~] = pwelch(pinkNoise, windowLength, overlapSamples, nFFTPoints, samplingFrequencyHz);

figure

subplot(3,2,1)
plot(timeVector, whiteNoise)
title('White noise')

subplot(3,2,2)
plot(f, psdWhite)
title('PSD - White noise')
xlim([0 150])

subplot(3,2,3)
plot(timeVector, brownNoise)
title('Brown noise')

subplot(3,2,4)
plot(f, psdBrown)
title('PSD - Brown noise')
xlim([0 50])

subplot(3,2,5)
plot(timeVector, pinkNoise)
title('Pink noise')

subplot(3,2,6)
plot(f, psdPink)
title('PSD - Pink noise')
xlim([0 50])

%% =========================================
% 9. PSD DE SINAL FILTRADO
% =========================================
% Filtragem altera o conteúdo espectral do sinal

filteredSignal10Hz = eegfilt(complexSignal, samplingFrequencyHz, 5, 15);

[psdFiltered10Hz, f] = pwelch( ...
    filteredSignal10Hz, ...
    windowLength, ...
    overlapSamples, ...
    nFFTPoints, ...
    samplingFrequencyHz);

figure
plot(frequencyAxis, powerSpectralDensity)
hold on
plot(f, psdFiltered10Hz, '--')

xlabel('Frequência (Hz)')
ylabel('PSD')
title('PSD - Antes vs Após Filtragem (10 Hz)')
xlim([0 120])
legend({'Original','Filtrado'})
grid on
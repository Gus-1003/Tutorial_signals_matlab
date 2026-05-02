%% INTRODUÇÃO AO PROCESSAMENTO DE SINAIS - FILTRAGEM
% Objetivo: carregar dados, explorar sinais e aplicar filtros

clc
clear
close all

%% =========================================
% 1. IMPORTAÇÃO DE DADOS
% =========================================
% Aqui mostramos como reutilizar dados previamente salvos

dataFolder = 'dados_da_aula';
dataFile = fullfile(dataFolder, 'complexSignals.mat');

load(dataFile)

%% =========================================
% 2. PARÂMETROS
% =========================================

samplingFrequencyHz = 1000; % frequência de amostragem (Hz)

%% =========================================
% 3. EXPLORAÇÃO DO SINAL
% =========================================
% Um sinal complexo pode conter múltiplas frequências (bandas)

figure
plot(timeVector, complexSignal, 'G')
title('Sinal complexo (domínio do tempo)')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])

%% =========================================
% 5. CONCEITO: BANDAS DE FREQUÊNCIA
% =========================================
% Um sinal pode ser decomposto em diferentes bandas de frequência
% Ex: 10 Hz, 30 Hz, 100 Hz → componentes do sinal
%
% Essa decomposição é a base de:
% - Exemplos clássicos de bandas:
%   + Delta (≈ 1–4 Hz)
%   + Theta (≈ 4–8 Hz)
%   + Alpha (≈ 8–12 Hz)
%   + Beta (≈ 13–30 Hz)
%   + Gamma (>30 Hz)
% - análise espectral (Fourier)

%% =========================================
% 5.1 ANÁLISE NO DOMÍNIO DA FREQUÊNCIA (FFT)
% =========================================
% A Transformada de Fourier (FFT) converte um sinal do tempo → frequência
% Ela mostra "quais frequências existem no sinal"

signalFFT = fft(complexSignal);

nSamples = length(complexSignal);

% vetor de frequências
frequencyAxis = (0:nSamples-1) * (samplingFrequencyHz / nSamples);

% magnitude do espectro
magnitudeFFT = abs(signalFFT) / nSamples;

%% Plot do espectro

figure

plot(frequencyAxis, magnitudeFFT)
xlim([0 150]) % focando nas frequências relevantes
title('Espectro de Frequência do Sinal')
xlabel('Frequência (Hz)')
ylabel('Magnitude')

%% =========================================
% 6. FILTRO PASSA-BANDA (BAND-PASS)
% =========================================
% Um filtro passa-banda mantém apenas uma faixa de frequências
% e remove o restante do sinal

addpath('libs') % garante acesso às funções de filtro

filtered10Hz = eegfilt(complexSignal, samplingFrequencyHz, 1, 15);
filtered30Hz = eegfilt(complexSignal, samplingFrequencyHz, 20, 40);
filtered100Hz = eegfilt(complexSignal, samplingFrequencyHz, 90, 110);

%% Visualização dos filtros passa-banda

figure

subplot(3,1,1)
plot(timeVector, filtered10Hz, 'G')
hold on
plot(timeVector, signal10Hz, 'k', 'LineWidth', 2)
title('Banda ~10 Hz')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])
legend({'Filtrado','Original 10Hz'})

subplot(3,1,2)
plot(timeVector, filtered30Hz, 'G')
hold on
plot(timeVector, signal30Hz, 'k', 'LineWidth', 2)
title('Banda ~30 Hz')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])

subplot(3,1,3)
plot(timeVector, filtered100Hz, 'y')
hold on
plot(timeVector, signal100Hz, 'k', 'LineWidth', 2)
title('Banda ~100 Hz')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])

%% =========================================
% 7. CONCEITO: O QUE É UM FILTRO?
% =========================================
% Um filtro é um sistema que modifica o conteúdo espectral do sinal
%
% Em termos simples:
% - passa-banda → mantém frequências específicas
% - notch → remove frequências específicas
%
% Por trás disso:
% - convolução no tempo
% - multiplicação no domínio da frequência

%% =========================================
% 8. FILTRO NOTCH
% =========================================
% Remove uma faixa específica de frequência (ex: ruído de rede)

windowSize = 5 * samplingFrequencyHz;

notch10Hz = notch_eegfilt(complexSignal, samplingFrequencyHz, 5, 15, windowSize, [], 1);
notch30Hz = notch_eegfilt(complexSignal, samplingFrequencyHz, 20, 40, windowSize, [], 1);
notch100Hz = notch_eegfilt(complexSignal, samplingFrequencyHz, 90, 110, windowSize, [], 1);

%% Visualização do filtro notch

figure

subplot(3,1,1)
plot(timeVector, notch10Hz, 'y')
hold on
plot(timeVector, signal10Hz, 'G', 'LineWidth', 2)
title('Notch removendo ~10 Hz')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])
legend({'Sinal sem 10Hz','Original 10Hz'})

subplot(3,1,2)
plot(timeVector, notch30Hz, 'y')
hold on
plot(timeVector, signal30Hz, 'G', 'LineWidth', 2)
title('Notch removendo ~30 Hz')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])

subplot(3,1,3)
plot(timeVector, notch100Hz, 'y')
hold on
plot(timeVector, signal100Hz, 'G', 'LineWidth', 2)
title('Notch removendo ~100 Hz')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])
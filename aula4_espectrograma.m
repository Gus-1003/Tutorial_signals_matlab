clc
clear
close all

%% =========================================
% 1. IMPORTAÇÃO DE DADOS
% =========================================

dataFolder = 'dados_da_aula';
dataFile = fullfile(dataFolder, 'complexSignals.mat');

load(dataFile)

addpath('libs')

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
ylabel('Voltage(mV)')
title('Sinal complexo (domínio do tempo)')
xlim([0 1])

%% =========================================================
% 4. ESPECTROGRAMA (ANÁLISE TEMPO-FREQUÊNCIA)
% =========================================================
% O espectrograma aplica FFT em pequenas janelas do sinal.
%
% Objetivo:
%   "Descobrir uais frequências existem ao longo do tempo?"
%
% Isso é chamado:
%   Short-Time Fourier Transform (STFT)

%% ---------------------------------------------------------
% TAMANHO DA JANELA
% ---------------------------------------------------------
% Janela de 1 segundo.
%
% Quanto maior a janela:
%   + melhor resolução em frequência
%   - pior resolução temporal
%
% Quanto menor:
%   + melhor resolução temporal
%   - pior resolução espectral
window = 1 * samplingFrequencyHz;

%% ---------------------------------------------------------
% SOBREPOSIÇÃO ENTRE JANELAS
% ---------------------------------------------------------
% 50% overlap:
%
% melhora continuidade temporal
% reduz mudanças abruptas entre janelas
overlap = window/2;

%% ---------------------------------------------------------
% NÚMERO DE PONTOS DA FFT
% ---------------------------------------------------------
% nfft controla:
%   - densidade dos bins de frequência
%   - suavidade visual do espectro
%
% OBS:
% aumentar nfft NÃO aumenta resolução física real.
%
% A resolução real depende da janela temporal.
nfft = 5*samplingFrequencyHz;

[all_espectro, frequency_vector, time_vector_spec, spectralPower] = spectrogram(complexSignal, window, overlap, nfft,samplingFrequencyHz);

figure(2), clf
imagesc(time_vector_spec, frequency_vector, spectralPower)
xlabel('Time (s)')
ylabel('Frequency(Hz)')
colorbar 
axis xy
ylim([0 150])

%% =========================================================
% 5. SINAL COM MUDANÇA TEMPORAL
% =========================================================
% Aqui criamos artificialmente um sinal que muda ao longo do tempo.
%
% Primeiros 10 segundos:
%   sinal original
%
% Últimos 10 segundos:
%   sinal original + senoide de 60 Hz
%
% Isso simula:
%   - ruído de linha
%   - surgimento de oscilação neural
%   - mudança fisiológica

signal_composition2 = [complexSignal complexSignal + 3*sin(timeVector*60*2*pi)];
timeVector2 = (0:length(signal_composition2)-1)/samplingFrequencyHz;

figure(3), clf
plot(timeVector2, signal_composition2, 'k')
hold on
xlabel('Time (s)')
ylabel('Voltage (mV)')
title('Complex signal')

%% ---------------------------------------------------------
% ESPECTROGRAMA DO NOVO SINAL
% ---------------------------------------------------------
% Agora o espectrograma deve mostrar:
%
% ausência de 60 Hz no início
% presença forte de 60 Hz após 10 s

window = 1 * samplingFrequencyHz;
overlap = window/2; % %2^12
nfft = 5*samplingFrequencyHz;
[all_espectro2, frequency_vector2, time_vector_spec2, spectralPower2] = spectrogram(signal_composition2,window,overlap,nfft,samplingFrequencyHz);

figure(4),clf
imagesc(time_vector_spec2,frequency_vector2,spectralPower2)
xlabel('Time (s)')
ylabel('Frequency(Hz)')
colorbar
axis xy
ylim([0 150])

%% =========================================================
% 6. COMPARAÇÃO ENTRE PRE E POST
% =========================================================
% Aqui dividimos o espectrograma em:
%
% PRE:
%   antes da senoide de 60 Hz
%
% POST:
%   depois da senoide de 60 Hz
Win1 = 1:19;
Win2 = 20:39;

figure(5),clf
plot(frequency_vector2,mean(spectralPower2(:,Win1),2),'k','linewidth',2)
hold on
plot(frequency_vector2,mean(spectralPower2(:,Win2),2),'r','linewidth',2)
xlim([0 110])
xlabel('Frequency(Hz)')
ylabel('Power Spectral Density(mV²/Hz)')

%% =========================================================
% 7. MÉDIA DE POTÊNCIA
% =========================================================
% Aqui armazenamos os valores médios
% para análise posterior.
MeanPowerPRE = mean(spectralPower2(:,Win1),2);
MeanPowerPOST = mean(spectralPower2(:,Win2),2);

% StdPowerPRE = std(potencial_vector2(:,Win1)')./sqrt(20);
% StdPowerPOST = std(potencial_vector2(:,Win2)')./sqrt(20);
% 
% plot(frequency_vector2,MeanPowerPRE + StdPowerPRE,'k--')
% plot(frequency_vector2,MeanPowerPRE - StdPowerPRE,'k--')
% 
% plot(frequency_vector2,MeanPowerPOST + StdPowerPOST,'r--')
% plot(frequency_vector2,MeanPowerPOST - StdPowerPOST,'r--')

%% =========================================
% 7. Normalization by "PRE" Interval
% =========================================
DiffPRE_POST = MeanPowerPOST-MeanPowerPRE;
figure(6),clf
plot(frequency_vector2,DiffPRE_POST,'b')
xlim([0 110])
ylim([0 3.5])

%% =========================================================
% 9. EVOLUÇÃO TEMPORAL DA POTÊNCIA
% =========================================================
% Aqui percorremos cada janela temporal
% do espectrograma.
%
% Objetivo:
% visualizar dinamicamente:
%
% "como o espectro muda ao longo do tempo"
for step = 1:39
    figure(6),clf
    plot(frequency_vector2,spectralPower2(:,step),'k','linewidth',2)
    xlim([0 110])
    ylim([0 3.5])
    xlabel('Frequency(Hz)')
    ylabel('Power Spectral Density(mV²/Hz)')
    pause(2)
end
%% INTRODUÇÃO AO PROCESSAMENTO DE SINAIS - AULA 2
% Este script demonstra como sinais são gerados, combinados e visualizados

clc
clear
close all

%% =========================================
% CONCEITO 0: TEOREMA DE NYQUIST
% =========================================
% Para representar corretamente um sinal digitalmente:
% A frequência de amostragem (fs) deve ser pelo menos 2x maior que frequência do
% sinal que esperamos analisar;
% fs >= 2 * f_max
%
% Exemplo: para detectar 100 Hz → precisamos de pelo menos 200 Hz

% Um sinal de eletrofisiologia tem ao todo 30000 Hz.
% Como geralmente analisamos eventos em até 500 HZ precisamos de 
% uma amostragem de no minimo 1000 Hz

samplingFrequency = 1000;  % Taxa de amostragem: quantas amostras por segundo

%% ================================
% 1. PARÂMETROS DE AMOSTRAGEM
% ================================

timeStep = 1 / samplingFrequency; % Intervalo entre amostras
signalDuration = 10;              % Duração total do sinal (Segundos)

%% ================================
% 2. VETOR DE TEMPO
% ================================
% Um sinal digital é representado como uma sequência de valores ao longo do tempo

timeVector = 0:timeStep:signalDuration - timeStep;

%% ================================
% 3. RUÍDO (NOISE)
% ================================
% Ruído é um sinal aleatório, frequentemente modelado como distribuição normal

noiseSignal = randn(1, length(timeVector));

numberOfTrials = 50;
noiseTrialsMatrix = randn(numberOfTrials, length(timeVector));

%% Visualização do ruído

figure

subplot(2,1,1)
plot(timeVector, noiseSignal)
title('Ruído - única realização')
xlabel('Tempo (s)')
ylabel('Amplitude')

subplot(2,1,2)
plot(timeVector, noiseTrialsMatrix(1:5,:)) % primeiras realizações
hold on
plot(timeVector, mean(noiseTrialsMatrix,1), 'k', 'LineWidth', 2)

title('Múltiplas realizações + média')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([0 1])

%% ================================
% 4. SINAIS SENOIDAIS
% ================================
% Uma senoide é um sinal periódico definido por frequência, amplitude e fase
% Frequência indica quantos ciclos ocorrem por segundo (Hz)

frequency10Hz = 10;
frequency30Hz = 30;
frequency100Hz = 100;

signal10Hz = sin(2 * pi * frequency10Hz * timeVector);
signal30Hz = sin(2 * pi * frequency30Hz * timeVector);
signal100Hz = sin(2 * pi * frequency100Hz * timeVector);

%% ================================
% 5. MANIPULAÇÃO DE AMPLITUDE
% ================================
% A amplitude controla a "altura" do sinal

signal10HzAmplitude2 = 2 * sin(2 * pi * frequency10Hz * timeVector);

%% ================================
% 6. SINAL COMPLEXO (SUPERPOSIÇÃO)
% ================================
% Um sinal complexo pode ser visto como a soma de múltiplas componentes

complexSignal = signal10Hz + signal30Hz + signal100Hz;
complexSignalModified = signal10HzAmplitude2 + signal30Hz + signal100Hz;

%% ================================
% 7. VISUALIZAÇÃO DOS SINAIS
% ================================

figure

signalsToPlot = {
    signal10Hz
    signal30Hz
    signal100Hz
    signal10HzAmplitude2
    complexSignal
    complexSignalModified
};

titlesList = {
    'Sinal 10 Hz'
    'Sinal 30 Hz'
    'Sinal 100 Hz'
    'Sinal 10 Hz (Amplitude x2)'
    'Sinal complexo (soma)'
    'Sinal complexo (modificado)'
};

for i = 1:length(signalsToPlot)
    subplot(6,1,i)
    plot(timeVector, signalsToPlot{i})
    title(titlesList{i})
    xlabel('Tempo (s)')
    ylabel('Amplitude')
    xlim([0 1])
end

%% ================================
% 8. SALVAMENTO
% ================================

outputFolder = 'C:\Users\ariog\Downloads\aulas_matlab\dados_da_aula';

% Garante que a pasta existe
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Caminhos completos
dataFilePath = fullfile(outputFolder, 'complexSignals.mat');
imageFilePath = fullfile(outputFolder, 'complexSignals.jpg');

% Salvando dados
save(dataFilePath, ...
    'signal10Hz', 'signal30Hz', 'signal100Hz', ...
    'noiseSignal', 'complexSignal', 'complexSignalModified', 'timeVector')

% Salvando figura
saveas(gcf, imageFilePath)
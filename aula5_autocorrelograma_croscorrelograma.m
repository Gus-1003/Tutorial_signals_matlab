clc
clear
close all

%% =========================================================
% CORRELOGRAMAS EM PROCESSAMENTO DE SINAIS
% =========================================================
%
% Correlação mede similaridade entre sinais.
%
% A ideia principal é:
%
%   "Quanto dois sinais se parecem?"
%
% ou:
%
%   "O sinal se repete ao longo do tempo?"
%
% ---------------------------------------------------------
% TIPOS DE CORRELAÇÃO
% ---------------------------------------------------------
%
% 1) AUTOCORRELOGRAMA (ACG)
%
%    Correlação do sinal com ele mesmo.
%
%    Objetivo:
%       detectar periodicidade e ritmos.
%
%    Muito usado para:
%       - ritmos neurais
%       - oscilação theta
%       - análise cardíaca
%       - padrões repetitivos
%
% ---------------------------------------------------------
% 2) CROSSCORRELOGRAMA (CCG)
%
%    Correlação entre DOIS sinais diferentes.
%
%    Objetivo:
%       medir sincronização temporal.
%
%    Muito usado para:
%       - conectividade neural
%       - sincronização entre regiões
%       - alinhamento temporal
%
% ---------------------------------------------------------
% 3) INTERPRETAÇÃO DOS LAGS
%
%    "lag" = deslocamento temporal.
%
%    Exemplo:
%
%    lag positivo:
%       sinal 2 ocorre depois do sinal 1
%
%    lag negativo:
%       sinal 2 ocorre antes do sinal 1
%
% ---------------------------------------------------------
% 4) NORMALIZAÇÃO
%
%    A opção:
%
%       'coeff'
%
%    normaliza a correlação entre:
%
%       -1 e +1
%
%    facilitando comparação entre sinais.
%
% =========================================================
% 1. IMPORTAÇÃO DE DADOS
% =========================================================
%
% O arquivo .mat contém:
%
%   complexSignal -> sinal temporal
%   timeVector    -> vetor temporal
%   samplingrate  -> frequência de amostragem

dataFolder = 'dados_da_aula';

dataFile = fullfile(dataFolder, 'complexSignals.mat');

load(dataFile)

addpath('libs')

%% =========================================================
% 2. VISUALIZAÇÃO DO SINAL ORIGINAL
% =========================================================
%
% Antes de qualquer análise espectral ou temporal,
% é importante visualizar o sinal bruto.
%
% Isso ajuda a identificar:
%
%   - ruído
%   - artefatos
%   - oscilações
%   - mudanças abruptas

figure(1), clf

plot(timeVector, complexSignal, 'k')

xlabel('Time(s)')
ylabel('Voltage(mV)')

title('Complex Signal')

%% =========================================================
% 3. AUTOCORRELOGRAMA (ACG)
% =========================================================
%
% Aqui correlacionamos:
%
%   sinal vs ele mesmo
%
% Objetivo:
%
% detectar padrões repetitivos.
%
% Se houver oscilação periódica:
% o ACG apresentará picos repetidos.
%
% ---------------------------------------------------------
% FUNÇÃO xcorr()
% ---------------------------------------------------------
%
% Sintaxe:
%
%   xcorr(x,y,maxlag,'coeff')
%
% x:
%   sinal 1
%
% y:
%   sinal 2
%
% maxlag:
%   deslocamento máximo analisado
%
% 'coeff':
%   normalização da correlação
%
% ---------------------------------------------------------
% INTERPRETAÇÃO
% ---------------------------------------------------------
%
% Pico central:
%   correlação perfeita do sinal com ele mesmo.
%
% Picos laterais:
%   repetição temporal / periodicidade.

figure(2), clf

[ACG, lags] = xcorr( ...
    complexSignal, ...
    complexSignal, ...
    1000, ...
    'coeff');

subplot(121)

plot(lags, ACG)

xlim([-500 500])
ylim([-1 1])

ylabel('ACG')

grid on

title('Autocorrelograma', ...
    'FontSize',13)

%% =========================================================
% 4. AUTOCORRELOGRAMA DO SINAL FILTRADO
% =========================================================
%
% Aqui filtramos o sinal entre:
%
%   5–15 Hz
%
% Isso corresponde aproximadamente
% à banda theta.
%
% Em neurociência:
%
% theta está associado a:
%   - navegação espacial
%   - memória
%   - hipocampo
%
% ---------------------------------------------------------
% FILTRAGEM
% ---------------------------------------------------------
%
% eegfilt():
%
% remove frequências fora da banda desejada.
%
% Resultado:
%
% apenas oscilações theta permanecem.
%
% ---------------------------------------------------------
% EXPECTATIVA
% ---------------------------------------------------------
%
% O ACG do sinal filtrado tende a:
%
%   - ficar mais periódico
%   - apresentar oscilações mais claras
%
% porque frequências irrelevantes foram removidas.

thetaSignal = eegfilt( ...
    complexSignal, ...
    1000, ...
    5, ...
    15);

[ACG2, lags] = xcorr( ...
    thetaSignal, ...
    thetaSignal, ...
    1000, ...
    'coeff');

subplot(122)

plot(lags, ACG2)

xlim([-500 500])
ylim([-1 1])

ylabel('ACG')

grid on

title('Autocorrelograma Theta FiltSig', ...
    'FontSize',13)

%% =========================================================
% 5. CROSSCORRELOGRAMA (CCG)
% =========================================================
%
% Agora correlacionamos:
%
%   sinal original
%
% com:
%
%   sinal original + senoide de 5 Hz
%
% Objetivo:
%
% verificar semelhança entre sinais.
%
% ---------------------------------------------------------
% INTERPRETAÇÃO
% ---------------------------------------------------------
%
% Quanto maior o pico:
%
% maior similaridade temporal.
%
% Oscilações no CCG:
%
% indicam componentes periódicos compartilhados.

figure(3), clf

sig_comp2 = ...
    complexSignal + ...
    3*sin(timeVector*5*2*pi);

[CCG, lags] = xcorr( ...
    complexSignal, ...
    sig_comp2, ...
    1000, ...
    'coeff');

plot(lags, CCG)

xlim([-500 500])
ylim([-1 1])

ylabel('CCG')

grid on

title('Crosscorrelograma', ...
    'FontSize',13)

%% =========================================================
% 6. CROSSCORRELOGRAMA COM RUÍDO
% =========================================================
%
% Agora criamos um sinal aleatório.
%
% randn():
% gera ruído gaussiano branco.
%
% Objetivo:
%
% demonstrar um caso onde NÃO existe
% correlação temporal.
%
% ---------------------------------------------------------
% EXPECTATIVA
% ---------------------------------------------------------
%
% O crosscorrelograma deve:
%
%   - ficar próximo de zero
%   - não apresentar periodicidade
%
% Isso indica ausência de relação temporal.

figure(4), clf

sig_noise = randn(1, 1000*10);

[CCGrs, lags] = xcorr( ...
    complexSignal, ...
    sig_noise, ...
    1000, ...
    'coeff');

plot(lags, CCGrs)

xlim([-500 500])
ylim([-1 1])

ylabel('CCG')

grid on

title('Crosscorrelograma Ruído', ...
    'FontSize',13)

%% =========================================================
% 7. AUTOCORRELOGRAMA AO LONGO DO TEMPO
% =========================================================
%
% Até agora calculamos UM único ACG.
%
% Agora queremos responder:
%
%   "Como o ACG muda ao longo do tempo?"
%
% Isso é muito importante em:
%
%   - estados cerebrais
%   - sono
%   - epilepsia
%   - comportamento
%
% =========================================================
% PARÂMETROS
% =========================================================

%% ---------------------------------------------------------
% PASSO TEMPORAL ENTRE JANELAS
% ---------------------------------------------------------
%
% timestep = 1 segundo
%
% A cada segundo:
% recalculamos o ACG.

timestep = 1;

%% ---------------------------------------------------------
% TAMANHO DA JANELA
% ---------------------------------------------------------
%
% Cada ACG será calculado
% usando 2 segundos de sinal.

windowlength = 2;

%% ---------------------------------------------------------
% VETOR TEMPORAL DOS ACGs
% ---------------------------------------------------------
%
% Guardará o tempo central
% de cada janela analisada.

timeVectorACG = [];

%% ---------------------------------------------------------
% FREQUÊNCIA DE AMOSTRAGEM
% ---------------------------------------------------------

srate = 1000;

%% =========================================================
% FILTRAGEM THETA
% =========================================================
%
% Criamos uma versão filtrada do sinal
% para comparar:
%
%   sinal bruto
%
% vs
%
%   sinal theta

sig_temp = eegfilt( ...
    complexSignal, ...
    srate, ...
    5, ...
    15);

%% =========================================================
% LOOP TEMPORAL
% =========================================================
%
% Aqui percorremos o sinal em janelas.
%
% Em cada janela:
%
%   1) calculamos o ACG
%   2) armazenamos o resultado
%
% Resultado final:
%
% matriz:
%
%   tempo x lag

for n_window = 1:( ...
        timeVector(end) ...
        - windowlength ...
        + timestep)

    %% -----------------------------------------------------
    % DEFINIÇÃO DA JANELA
    % -----------------------------------------------------
    %
    % Converte:
    %
    % segundos -> índices amostrais

    window = ...
        (1:(windowlength*srate)) + ...
        (n_window-1)*timestep*srate;

    %% -----------------------------------------------------
    % TEMPO CENTRAL DA JANELA
    % -----------------------------------------------------

    timeVectorACG(n_window) = ...
        median(window)/srate;

    %% -----------------------------------------------------
    % ACG DO SINAL BRUTO
    % -----------------------------------------------------

    [ACG, lags] = xcorr( ...
        complexSignal(window), ...
        complexSignal(window), ...
        0.5*srate, ...
        'coeff');

    ACGnotempo(n_window, :) = ACG;

    %% -----------------------------------------------------
    % ACG DO SINAL FILTRADO
    % -----------------------------------------------------

    [ACGfilt, lags] = xcorr( ...
        sig_temp(window), ...
        sig_temp(window), ...
        0.5*srate, ...
        'coeff');

    ACGfiltnotempo(n_window, :) = ACGfilt;
end

%% =========================================================
% 8. VISUALIZAÇÃO TEMPORAL DOS ACGs
% =========================================================
%
% imagesc():
%
% cria um mapa de calor.
%
% eixo X:
%   tempo
%
% eixo Y:
%   lag temporal
%
% cores:
%   intensidade da autocorrelação
%
% ---------------------------------------------------------
% INTERPRETAÇÃO
% ---------------------------------------------------------
%
% Bandas repetitivas:
%   indicam ritmos periódicos.
%
% Mudanças ao longo do tempo:
%   indicam mudanças dinâmicas do sinal.

figure(5), clf

%% ---------------------------------------------------------
% ACG TEMPORAL - SINAL BRUTO
% ---------------------------------------------------------

subplot(211)

imagesc( ...
    timeVectorACG, ...
    lags/srate*1000, ...
    ACGnotempo')

set(gca, 'fontsize', 12)

set(gcf, 'color', 'white')

xlabel('Time(s)')
ylabel('Lag(ms)')

title('Temporal ACG', ...
    'FontSize',13)

axis xy

xlim([1 ...
    (timeVector(end)-windowlength+timestep)])

%% ---------------------------------------------------------
% ACG TEMPORAL - SINAL FILTRADO
% ---------------------------------------------------------

subplot(212)

imagesc( ...
    timeVectorACG, ...
    lags/srate*1000, ...
    ACGfiltnotempo')

set(gca, 'fontsize', 12)

set(gcf, 'color', 'white')

xlabel('Time(s)')
ylabel('Lag(ms)')

title('Temporal ACG - filtrado', ...
    'FontSize',13)

axis xy

xlim([1 ...
    (timeVector(end)-windowlength+timestep)])
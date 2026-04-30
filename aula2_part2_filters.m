% Class2- part2 - Filters
clc % limpa "comand Window"
clear % limpa "workspace/memory"
close all % fechar todas as figuras

%% imports
addpath('C:\Users\ariog\Downloads\aulas_matlab\libs')
load('C:\Users\ariog\Downloads\aulas_matlab\dados_da_aula\complex_signals.mat')

%% parameters
sampling_rate = 1000;

%% band_pass
filt_10Hz = eegfilt(complex_signal_edit, sampling_rate, 1, 15);
filt_30Hz = eegfilt(complex_signal_edit, sampling_rate, 20, 40);
filt_100Hz = eegfilt(complex_signal_edit, sampling_rate, 90, 110);

%% plot band_pass representation
FIG1 = figure(1);clf
subplot(3,1,1)
plot(time_vector,filt_10Hz,'y')
hold on
plot(time_vector,signal_10Hz,'w')
xlim([0 1])
title '10Hz band pass'
legend({'filt10','sin10'})

subplot(3,1,2)
plot(time_vector,filt_30Hz,'y')
hold on
plot(time_vector,signal_30Hz,'w')
xlim([0 1])
title '30Hz band pass'

subplot(3,1,3)
plot(time_vector,filt_100Hz,'y')
hold on
plot(time_vector,signal_100Hz,'w')
xlim([0 1])
title '100Hz band pass'

%% notch_filter
winsize = 5*sampling_rate;
notch_10Hz = notch_eegfilt(complex_signal_edit,sampling_rate,5,15,winsize,[],1);
notch_30Hz = notch_eegfilt(complex_signal_edit,sampling_rate,20,40,winsize,[],1);
notch_100Hz = notch_eegfilt(complex_signal_edit,sampling_rate,90,110,winsize,[],1);

%% plot notch_filter representation
FIG2 = figure(2);clf
subplot(3,1,1)
plot(time_vector,notch_10Hz,'y')
hold on
plot(time_vector,signal_10Hz_edit1,'w','LineWidth',3)
xlim([0 1])
title '10Hz band pass'
legend({'notch10','sig10'})
subplot(3,1,2)
plot(time_vector,notch_30Hz,'y')
hold on
plot(time_vector,signal_30Hz,'w','LineWidth',3)
xlim([0 1])
subplot(3,1,3)
plot(time_vector,notch_100Hz,'y')
hold on
plot(time_vector,signal_100Hz,'w','LineWidth',1)
xlim([0 1])
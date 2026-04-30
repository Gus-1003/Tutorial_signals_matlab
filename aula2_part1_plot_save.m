% class2 - part1 - Introduction to Signal Processing - Generating an Artificial Signal
clc % limpa "comand Window"
clear % limpa "workspace/memory"
close all % fechar todas as figuras

%% parameters
sampling_rate = 1000;
delta_time = 1/sampling_rate;
finish_time = 10;

%% vectors
time_vector = delta_time:delta_time:finish_time;
signal_noise = randn(1, sampling_rate*finish_time);
signal_noise_trails = randn(100, sampling_rate*finish_time);

%% plot signal with noise
fig2 = figure(2);clf
plot(time_vector,signal_noise)
xlabel 'time s'
ylabel 'voltage mV'
title 'noise'

%% subplots base signals
fig3 = figure(3);clf

subplot(2,1,1)
plot(time_vector,signal_noise);
xlabel 'time s'
ylabel 'voltage mV'
title 'noise'

subplot(2,1,2)
plot(time_vector,signal_noise_trails);
hold on
plot(time_vector,mean(signal_noise_trails, 1),'w','LineWidth',3);

xlabel 'time s'
ylabel 'voltage mV'
title 'noise_trials'
xlim([0 1])

%% complex_signals
frequency1 = 10;
frequency2 = 30;
frequency3 = 100;

signal_10Hz = sin(time_vector*frequency1*2*pi);
signal_30Hz = sin(time_vector*frequency2*2*pi);
signal_100Hz = sin(time_vector*frequency3*2*pi);

signal_10Hz_edit1 = 2*sin(time_vector*frequency1*2*pi);

complex_signal = signal_10Hz + signal_30Hz + signal_100Hz;

complex_signal_edit = signal_10Hz_edit1 + signal_30Hz + signal_100Hz;

%% subplots for representation
fig4 = figure(4);clf

subplot(6,1,1)
plot(time_vector,signal_10Hz);
xlabel 'time s'
ylabel 'voltage mV'
title 'signal 10hz'
xlim([0 1])

subplot(6,1,2)
plot(time_vector,signal_30Hz);
xlabel 'time s'
ylabel 'voltage mV'
title 'signal 30hz'
xlim([0 1])

subplot(6,1,3)
plot(time_vector,signal_100Hz);
xlabel 'time s'
ylabel 'voltage mV'
title 'signal 100hz'
xlim([0 1])

subplot(6,1,4)
plot(time_vector,signal_10Hz_edit1);
xlabel 'time s'
ylabel 'voltage mV'
title 'signal 10hz edit1'
xlim([0 1])

subplot(6,1,5)
plot(time_vector,complex_signal);
xlabel 'time s'
ylabel 'voltage mV'
title 'complex signal'
xlim([0 1])

subplot(6,1,6)
plot(time_vector,complex_signal_edit);
xlabel 'time s'
ylabel 'voltage mV'
title 'complex signal edit'
xlim([0 1])

%% saves
save('C:\Users\ariog\Downloads\aulas_matlab\dados_da_aula\complex_signals.mat', 'sig*', 'time_vector', 'signal_noise', 'complex_signal_edit')
saveas(fig4,'C:\Users\ariog\Downloads\aulas_matlab\dados_da_aula\complex_signals_image', 'jpg')





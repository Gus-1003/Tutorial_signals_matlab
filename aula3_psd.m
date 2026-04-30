%% POWER SPECTRAL DENSITY (PSD) - pwelch
clear
close all
clc
addpath('C:\Users\hindi\OneDrive\Documentos\MATLAB\Matlab2026\Functions')
load('C:\Users\hindi\OneDrive\Documentos\MATLAB\Matlab2026\ComplexSignals.mat')
samplingrate = 1000;

%% PLOT SIGNALS
figure(1),clf
plot(timevector,sig_comp,'w')
hold on
xlabel 'Time(s)'
ylabel 'Voltage(mV)'
title 'Complex signal'

%% PSD - pwelch
x = sig_comp;
window = samplingrate;%length(x)
noverlap = [];%sobreposição de janelas
nfft = 1000;%num de freq da fast fourier transform
srate = samplingrate;
[pxx, f] = pwelch(x,window,noverlap,nfft,srate);

figure(2),clf
plot(f,pxx,'w')
xlabel 'Frequency(Hz)'
ylabel 'PSD(mV/Hz²)'
title 'Power Spectral Density - Complex signal'
xlim([0 250])
% ylim

%% PSD - pwelch - complex signal and noise
x = sig_comp + 10*sig_noise;
window = samplingrate;%length(x)
noverlap = [];%sobreposição de janelas
nfft = 1000;%num de freq da fast fourier transform
srate = samplingrate;
[pxx, f] = pwelch(x,window,noverlap,nfft,srate);

figure(3),clf
plot(f,pxx,'w')
xlabel 'Frequency(Hz)'
ylabel 'PSD(mV/Hz²)'
title 'Power Spectral Density - Complex signal'
grid on
xlim([0 250])
% ylim

%% AVALIAÇÃO DO PSD
clc
F10Hz_idx = find(f>=8 & f<=12);%indices das frequencias da banda de interesse
F30Hz_idx = find(f>=20 & f<=40);
F100Hz_idx = find(f>=90 & f<=110);

Power_10Hz = sum(pxx(F10Hz_idx));%soma da potencia nos valores de frequencia da banda de 10Hz
Power_30Hz = sum(pxx(F30Hz_idx));
Power_100Hz = sum(pxx(F100Hz_idx));

[potenciapico temp] = max(pxx);%valor e frequencia da maior potencia
frequenciapico = f(temp);

[potenciapico_30Hz temp] = max(pxx(F30Hz_idx));%valor e frequencia da maior potencia
frequenciapico_30Hz = f(F30Hz_idx(temp));

[potenciapico_100Hz temp] = max(pxx(F100Hz_idx));%valor e frequencia da maior potencia
frequenciapico_100Hz = f(F100Hz_idx(temp));

%% ILUSTRAR PICOS E VALORES NA FIGURA DE PSD
figure(3)
hold on
plot(frequenciapico,potenciapico,'oy')
plot(frequenciapico_30Hz,potenciapico_30Hz,'oy')
plot(frequenciapico_100Hz,potenciapico_100Hz,'oy')

text(frequenciapico,potenciapico,num2str(potenciapico))
text(frequenciapico_30Hz,potenciapico_30Hz,num2str(potenciapico_30Hz))
text(frequenciapico_100Hz,potenciapico_100Hz,num2str(potenciapico_100Hz))

%% RUIDO BRANCO
x_white = 100*sig_noise;%white noise
window = samplingrate;%length(x)
noverlap = [];%sobreposição de janelas
nfft = 1000;%num de freq da fast fourier transform
srate = samplingrate;
[pxx_white, f] = pwelch(x_white,window,noverlap,nfft,srate);

x_brown = cumsum(sig_noise);%brown noise
[pxx_brown, f] = pwelch(x_brown,window,noverlap,nfft,srate);

n=length(timevector);
ps = exp(1i*2*pi*rand(1,n/2)).* .1+exp(-(1:n/2)/50);
ps = [ps ps(:,end:-1:1)];
x_pink = real(ifft(ps)) * n;
[pxx_pink, f] = pwelch(x_pink,window,noverlap,nfft,srate);


figure(4),clf
subplot(321)
plot(timevector,x_white,'w')
title 'white noise'
xlabel 'Time(s)'
subplot(322)
plot(f,pxx_white,'w')
xlabel 'Frequency(Hz)'
ylabel 'PSD(mV/Hz²)'
title 'PSD - White noise'
grid on
xlim([0 250])

subplot(323)
plot(timevector,x_brown,'w')
title 'white noise'
xlabel 'Time(s)'
subplot(324)
plot(f,pxx_brown,'w')
xlabel 'Frequency(Hz)'
ylabel 'PSD(mV/Hz²)'
title 'PSD - Brown noise'
grid on
xlim([0 10])

subplot(325)
plot(timevector,x_pink,'w')
title 'pink noise'
xlabel 'Time(s)'
subplot(326)
plot(f,pxx_pink,'w')
xlabel 'Frequency(Hz)'
ylabel 'PSD(mV/Hz²)'
title 'PSD - Pink noise'
grid on
xlim([0 20])


%% PSD do FILTRADO
x = eegfilt(sig_comp,samplingrate,5,15);
window = samplingrate;%length(x)
noverlap = [];%sobreposição de janelas
nfft = 1000;%num de freq da fast fourier transform
srate = samplingrate;
[pxx_10Hzfilt, f] = pwelch(x,window,noverlap,nfft,srate);

figure(2)
hold on
plot(f,pxx_10Hzfilt,'y--')
xlabel 'Frequency(Hz)'
ylabel 'PSD(mV/Hz²)'
title 'PSD - Filt 10Hz - Complex signal'
xlim([0 120])
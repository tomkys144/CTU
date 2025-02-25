clear, clc, close all; 

% Vypocet LPC spektra v db pre AR model

% LPC urcit ako jednostranny odhad v 64 bodoch
% zobrazit prvych 8 spektralnych komponent vypocitaneho LPC spektra

% a = [1.00000 -2.54389 3.09003 -2.98049 2.61336 -1.54185 0.43826];  % Auroregresne koeficienty
a = [1.00000 -0.25622 0.47595 0.03518 0.03846 0.01822 -0.20387];
% E = 5.7446e-06;
E = 1.2384e-06; % vykon chyby predikcie

N = 64; % pocet vzorkov

H = freqz(sqrt(E), a, N);
LPspec = abs(H);


LPspec_db = 20*log10(LPspec);


%%
clear, clc, close all; 

% Define the parameters
fs = 200; % Sampling frequency (Hz)
p = 4; % Order of the MA process
mypoles = [ 0.9 0.8*exp(j*pi/4) 0.8*exp(-j*pi/4) ]
wlen = 512;

a = poly(mypoles);
b = 1;

% Load the Gaussian white noise from the binary file
gaussian_noise = loadbin('un-excitation.bin');

% Create the MA process
ma_signal = filter(b, a, gaussian_noise);

% Estimate the power spectral density (PSD) using Welch's method
[pxx, f] = pwelch(ma_signal, wlen, wlen/2, wlen, fs, 'twosided', 'psd');

% Convert PSD to decibels
psd_in_db = 10*log10(pxx);

% Plot the PSD
figure;
plot(f, psd_in_db);
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density (PSD)');


%% vykon chyby predikce

sig = loadbin('vm0-512.bin');
wlen = length(sig);

figure(7)
plot(sig)

sig = sig.*hamming(wlen);
S = fft(sig);
G = abs(S).^2/wlen;

p = 16;
[a,Ep] = lpc(sig,p);

%% Urcte vykonove spektrum v decibeloch, pred vahujte

sig = loadbin('vm0-512.bin');
wlen = length(sig);

figure(7)
plot(sig)

sig = sig.*hamming(wlen);
S = fft(sig);
G = abs(S).^2/wlen;

p = 16;
[a,Ep] = lpc(sig,p);
H = freqz(sqrt(Ep),a,wlen,"whole");

LPspec = abs(H);
LPspec_db = 20*log10(LPspec);


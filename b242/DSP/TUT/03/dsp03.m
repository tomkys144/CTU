clc
clear all
close all
%% Příprava modelovaných a reálných 2-kanálových signálů
cs0 = loadbin("SA001S01.CS0");
cs1 = loadbin("SA001S01.CS1");
cs2 = loadbin("SA001S01.CS2");
cs3 = loadbin("SA001S01.CS3");

fs = 16000;

%%%
sim1_1 = cs0;
sim1_2 = filter([zeros(20, 1); 1],[1], cs0);

figure
subplot(211)
plot(sim1_1);
hold on
plot(sim1_2, 'r');
hold off

%%%
M2 = 30;
b = fir1(M2, 0.05, "high");

scale = 0.005;

sim2_1 = cs0 + randn(size(cs0)) * scale;
sim2_2 = filter(b, 1, cs0) + randn(size(cs0)) * scale;

subplot(212)
plot(sim2_1);
hold on
plot(sim2_2, 'r');
hold off

figure
freqz(b,1,1000)

%% Analýza zpoždění 2-kanálových signálů pomocí vzájemné korelace 

coords = [40000, 41000];

x1 = sim1_1(coords(1) : coords(2));
x2 = sim1_2(coords(1) : coords(2));

[rxy, lags] = xcorr(x1, x2);

[~, tau_idx] = max(rxy);
tau = abs(lags(tau_idx))


figure
subplot(211)
plot([x1 x2]);

subplot(212)
plot(lags, rxy)

%% Analýza zpoždění 2-kanálových signálů ze vzájemné spektrální výkonové hustoty

coords = [40000, 41000];

winlen = 128;
noverlap = 3*winlen/4;
NFFT = 2*winlen;

x1 = sim2_1(coords(1) : coords(2));
x2 = sim2_2(coords(1) : coords(2));

figure
cpsd(x1, x2, winlen, winlen/2, NFFT, fs);

[Sxy, f] = cpsd(x1, x2,winlen, noverlap, NFFT, fs);

Sxy_phase = unwrap(angle(Sxy));
Sxy_mod = abs(Sxy);

figure()
subplot(211)
plot(f, 10*log10(Sxy_mod))

subplot(212)
plot(f, Sxy_phase)

clear all
close all

%% Generování nízkofrekvenčního barevného šumu AR modelem

% Generujte bílý šum s Gaussovským rozložením, nulovou střední hodnotou a
% jednotkovým rozptylem.
N = 10000;
un = randn([N, 1]);
%%
% Určete přenosovou funkci AR systému 1. řádu pro generování nízko-
% frekvenčního barevného šumu se šířkou pásma B = 300 Hz při vzorkovacím
% kmitočtu fs = 8000 Hz.
B = 300; % B = ln|p1|/(pi * Ts)
fs = 8000;
p1_abs = exp(-B * pi / fs);

a = [1, -p1_abs];
b = [1];

% Sledujte v MATLABu frekvenční charakteristiku daného systému (AR modelu).
freqz(b, a, 1000, fs);

% Generujte požadovaný NF barevný šum filtrací bílého šumu AR systémem
% (signál nc1). Sledujte vyhlazený odhad PSD generovaného šumu, jeho
% periodogram (nevyhlazený odhad) a spektrogram.
nc1 = filter(b, a, un);

figure
subplot(211)
plot(un)
title("noise")

subplot(212)
plot(nc1)
title("AR LF BW=300Hz")

figure
winlen = 512;
NFFT = winlen;

S = fft(nc1, NFFT);
Gx = abs(S).^2 / NFFT;

plot(10*log10(Gx))

figure

pwelch(nc1, winlen, winlen / 2, NFFT, fs)

figure
zplane(b,a)
%% Generování dalších barevných šumů AR resp. MA modelem 1. řádu

% Opakujte předchozí úlohu pro případ generování vysokofrekvenčního (VF) šumu AR modelem 1. řádu se stejnými parametry (signál nc2). 
a = [1, p1_abs];
b = [1];

freqz(b, a, 1000, fs)

nc2 = filter(b, a, un);

figure
subplot(211)
plot(un)
title("noise")

subplot(212)
plot(nc2)
title("AR HF BW=300Hz")

figure
winlen = 512;
NFFT = winlen;

S = fft(nc2, NFFT);
Gx = abs(S).^2 / NFFT;

plot(10*log10(Gx))

figure

pwelch(nc2, winlen, winlen / 2, NFFT, fs)

figure
zplane(b,a)

%% MA model LF

a = [1];
b = [1 p1_abs];

freqz(b, a, 1000, fs)

nc1ma = filter(b, a, un);

figure
subplot(211)
plot(un)
title("noise")

subplot(212)
plot(nc1ma)
title("MA LF BW=300Hz")

figure
winlen = 512;
NFFT = winlen;

S = fft(nc1ma, NFFT);
Gx = abs(S).^2 / NFFT;

plot(10*log10(Gx))

figure

pwelch(nc1ma, winlen, winlen / 2, NFFT, fs)

figure
zplane(b,a)

%% MA model HF

a = [1];
b = [1 -p1_abs];

freqz(b, a, 1000, fs)

nc2ma = filter(b, a, un);

figure
subplot(211)
plot(un)
title("noise")

subplot(212)
plot(nc2ma)
title("MA HF BW=300Hz")

figure
winlen = 512;
NFFT = winlen;

S = fft(nc2ma, NFFT);
Gx = abs(S).^2 / NFFT;

plot(10*log10(Gx))

figure

pwelch(nc2ma, winlen, winlen / 2, NFFT, fs)

figure
zplane(b,a)

%% LPC
a = [1, -p1_abs];
b = [1];

p = 1;
anc1 = lpc(nc1, p);
poles = roots(anc1);

figure
zplane(b,a);
hold on
plot(real(poles), imag(poles), 'rx')
hold off

%% Pasmovy sum

poles = 0.9 * exp(0.9i * [1, -1]);
b = [1];
a = poly(poles);

freqz(b, a, 1000, fs)

nc3 = filter(b, a, un);

figure
subplot(211)
plot(un)
title("noise")

subplot(212)
plot(nc3)
title("Band")

figure
winlen = 512;
NFFT = winlen;

S = fft(nc3, NFFT);
Gx = abs(S).^2 / NFFT;

plot(10*log10(Gx))

figure

pwelch(nc3, winlen, winlen / 2, NFFT, fs)

figure
zplane(b,a)

%% LPC2

p = 2;
anc3 = lpc(nc3, p);
poles = roots(anc3);

figure
zplane(b,a);
hold on
plot(real(poles), imag(poles), 'rx')
hold off

clear all
close all
clc

%%

s = loadbin('SA001S04.CS0');

fs = 16000;
t = linspace(0,length(s) - 1, length(s)) / fs;

wlen = 0.032 * fs;
wstep = 0.016 * fs;

figure
subplot(211)
plot(t, s)
axis tight

subplot(212)
spectrogram(s, wlen, wlen - wstep, wlen, fs, "yaxis")
colorbar('off')

cp = 12;
p = 16;
cr = vrceps(s, 1, cp, wlen, wstep);
ca = vaceps(s, 1, p, cp, wlen, wstep);
tt = (0:length(cr(:,1))-1) * wstep / fs;

figure
plot(tt,cr(:, 2:end))

figure
plot(tt, ca(:, 2:end))

%%

M = 30;

b = fir1(M, [0.3 0.7], "bandpass");
a = 1;

figure
freqz(b,a,1000)

s1 = filter(b, a, s);

figure
subplot(211)
spectrogram(s, wlen, wlen - wstep, wlen, fs, "yaxis")

subplot(212)
spectrogram(s1, wlen, wlen - wstep, wlen, fs, "yaxis")

cr1 = vrceps(s1, 1, cp, wlen, wstep);
ca1 = vaceps(s1, 1, p, cp, wlen, wstep);
tt1 = (0:length(cr1(:,1))-1) * wstep / fs;

dr = cde(cr, cr1, cp);
da = cde(ca, ca1, cp);

figure
plot(tt1, dr)

%%

[s, fs] = audioread('fletna_stupnice.wav');

t = linspace(0,length(s) - 1, length(s)) / fs;

wlen = 0.032 * fs;
% wstep = 0.016 * fs;
wstep = wlen;

figure
subplot(211)
plot(t, s)
axis tight

subplot(212)
spectrogram(s, wlen, wlen - wstep, wlen, fs, "yaxis")
colorbar('off')

cp = 12;
cr = vrceps(s, 1, cp, wlen, wstep);

d = cde(cr(3:end,:), cr(2:end-1,:));

figure
plot(d)
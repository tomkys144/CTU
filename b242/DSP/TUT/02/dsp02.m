clear all
close all

%%
nc4 = loadbin("nc4.bin");

winlen = 1000;
nfft = winlen;

figure
pwelch(nc4, winlen, winlen / 2, nfft)

p = 2;
a_nc4 = lpc(nc4, p);


%%

frame = loadbin("vm0-512.bin");

wlen = length(frame);
NFFT = wlen;

w = hamming(wlen);
frame_w = frame .* w;

K = fft(frame);
Gx = abs(K).^2/NFFT;

% LPC

p = 16;
[a, Ep] = lpc(frame, p);
H = freqz(sqrt(Ep), a, NFFT, "whole");

Gx_lpc = abs(H) .^ 2;

figure
subplot(211)
plot(Gx)

subplot(212)
plot(10 * log10(Gx))
hold on
plot(10 * log10(Gx_lpc))
hold off
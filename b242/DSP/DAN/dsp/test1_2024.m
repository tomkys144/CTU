clear; clc; close all
format long;

s = filter (1, [1   0   0.81], randn(1000,1) ) ;

% frame = loadbin('frame2.bin');
% win = hamming(length(frame));
% 
% frame = frame.*win;
% 
% S = 10*log10(abs(fft(frame)).^2);
% S(1:8)
% nfft = length(frame);
% S = abs(fft(frame, nfft));
% Gs = 10*log10(S.^2./nfft./win_pwr);

sig2 = loadbin("frame2.bin");

win = hamming(length(sig2));
[psd2_2,fff]=pwelch(sig2,win,[],[],[],'psd','twoside');
win_pwr = mean(win.^2);
sig2 = sig2.*win;
nfft = length(sig2);
S = abs(fft(sig2, nfft));
Gs = 10*log10(S.^2./nfft);
fftckem = Gs(1:8)
welchem = 10*log10(psd2_2(1:8))




a = [1 0 0.81];
b = 1;

zplane(b,a);
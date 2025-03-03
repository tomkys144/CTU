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

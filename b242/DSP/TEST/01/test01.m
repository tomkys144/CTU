format long

a = [ 1.00000 -0.65061 0.27425 0.15223 0.32457 -0.23301 0.22956 ];
E = 1.322e-06;

b = [1];

[Hlpc, ff]=freqz(b,a,64);

10*log10(abs(Hlpc).^2)

%%

sig = loadbin("sigar-008.bin");
frame = sig .* hamming(length(sig));
[~, Ep] = lpc(frame, 12)

%%
 fs = 200;

 mypoles = [0.8*exp(j*pi/4), 0.8*exp(-j*pi/4), 0.95*exp(j*5*pi/6), 0.95*exp(-j*5*pi/6) ];

 un = loadbin('un-excitation.bin');

 a = poly(mypoles);
 b = [1];

 frame = filter(b,a,un);

winlen = 512;

 pxx = pwelch(frame, winlen, winlen/2, winlen, fs, "twosided", 'psd');

 P = 10 * log10(pxx);
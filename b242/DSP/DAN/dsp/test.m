format long

a = [ 1.00000 0.13245 0.59856 0.08645 -0.04674 -0.16135 -0.06211 ];
E = 9.7586e-06;
X = freqz(sqrt(E),a,64,"half");
Gx = 20*log10(abs(X));
ans1 = Gx(1:8)


%%
sig=loadbin('sigar-009.bin');
p = 12;
w = hamming(length(sig));
sig = sig.*w;
a_lpc = lpc(sig,p);

%%
a2 = [ 1.00000 -2.54389 3.09003 -2.98049 2.61336 -1.54185 0.43826 ];
G = 0.0023968;
fs = 16000;
un=loadbin('un-excitation.bin');
wlen = 512;
nfft = wlen;
nover = wlen/2;
x2 = filter(G,a2,un);

X2 = pwelch(x2,wlen,nover,nfft,fs,"twosided","psd");
Gx2 = 10*log10(abs(X2));
ans2 = Gx2(1:8)
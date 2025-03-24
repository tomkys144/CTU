%%lpc spektrum
clear all
a = [1.00000 -2.45209 2.18820 -1.03447 1.01896 -1.11572 0.46416];
E = 8.2103e-06;
X = freqz(sqrt(E),a,64,"half");
Gx = 20*log10(abs(X));
ans1 = Gx(1:8)

%%AR modelování
N = 6;
fs = 200;
a2 = [ 0.9 0.8*exp(j*pi/4) 0.8*exp(-j*pi/4) ]
G = 1;
un = loadbin("un-excitation.bin");
wlen = 512;
nfft = wlen;
nover = wlen/2;
x2 = filter(G,a2,un);

X2 = pwelch(x2,wlen,nover,nfft,fs,"twosided","psd");
Gx2 = 10*log10(abs(X2));
ans2 = Gx2(1:8)

%určení AR koeficientů
sig = loadbin("sigar-001.bin");
p = 12;
w = hamming(length(sig));
sig = sig.*w;
a_lpc = lpc(sig,p)

%výkon signálu
sig2 = loadbin("frame.bin");

win = hamming(length(sig2));
[psd2_2,fff]=pwelch(sig2,win,[],[],[],'psd','twoside');
win_pwr = mean(win.^2);
sig2 = sig2.*win;
nfft = length(sig2);
S = abs(fft(sig2, nfft));
Gs = 10*log10(S.^2./nfft./win_pwr);
fftckem = Gs(1:8)
welchem = 10*log10(psd2_2(1:8))

% LPC spektrum (odhad spec. výk hustoty na bázi LPC) v dB pro AR model
a3 = [1.0 -2.54389 3.09003 -2.98049 2.61336 -1.54185 0.43826]; % autoregresní koeficienty
E3 = 5.7446e-06; %výkon predikce chyby
N = 64; % jednostranný odhad v 64 bodech
X3 = freqz(sqrt(E3),a3,N,"half");
Gx3 = 20*log10(abs(X3));
Gx3(1:8)

%modelování
sig4 = loadbin('un-excitation.bin')
fs4 = 200;
p4 = 4;
mypoles = [ 0.9 0.8*exp(j*pi/4) 0.8*exp(-j*pi/4) ];
wlen4 = 512;
nover4 = wlen4/2;
a = poly(mypoles);
sig = filter(1,a,un);
G4 = pwelch(sig4,hamming(wlen),nover4,wlen4,fs4,"twosided","psd");
Gdb4 = 10*log10(G4);
Gdb4(1:8)
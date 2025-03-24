% DSP cv1 - modelování

B=300; % šířka pásma
fs = 8000; % vzorkovací frekvence

% generování NF filtru AR 1. řádu
% a1 = -exp(-B*pi/fs);

% generování VF filtru AR 1.řádu
a1 = exp(-B*pi/fs);

b=1;
a=[1 a1];

figure(1);
n = 1000;
% freqz(B,a,n,fs,'whole');
 freqz(B,a,n,fs);
 
%% Generování pásmového šumu AR řádu 2
% signál bude sloupcový vektor!

N = 10000;

un=randn(N,1);

% NF nc1: 
nc1=filter(b, a, un);

figure(2);
subplot(211);
plot(un);

subplot(212);
plot(nc1);

wlen=512; % window length
noverlap = wlen/2; % wlen/2 = 50% překryv 
nfft= wlen; %počet bodů fourierky - ideálně teď délka toho okna

figure(3);
pwelch(nc1, wlen, noverlap, nfft, fs);

figure(4);
w=hamming(wlen); % okno je vždy sloupcový vektor - proto chcem oboje sloupcový vektor

frame=nc1(1:wlen).*w; % vybereme si první okno, přenásobíme oknem
% výpočet výkonového spektra
X=fft(frame);
Gx=(abs(X).^2)./wlen;
 plot(10*log10(Gx));

% spektrogram
figure(5);
spectrogram(nc1, wlen, noverlap, nfft, fs, 'yaxis');
colorbar off; % vypínáme sloupeček s barevnou škálou

%% MA filtr

b=[1 -a1];
a=1;

figure(6);
zplane(b,a);

% DU - nadefinovat proces 2. řádu se dvěma póly
% H(z) = (z^2)/((z-p1)(z-p2)) = 1/((1-p1z^-1)(1-p2z^-1)) = 1 / (1+a1z^-1 + a2z^-2)
% a = poly([p1 p2]);
% modifikovaný periodogram - pomůže help spectrogram (jiná měřítka grafů)
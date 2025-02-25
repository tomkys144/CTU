% pól AR p0 = -a1
% frekvence f0 = arg(p0)*fs/2pi
% šířka pásma B = (-ln(abs(p0))/pi)8*fs = (1- abs(p0)*fs/pi
% při odvození DTFT tam vznikne násobení TS ale to se standardně nepoužívá
% -> proto to vychází v pwelchu jinak, ten to může nebo nemusí škálovat Ts
% -> periodogram je z jedné realizace
% -> modifikovaný periodogram posouvá výkon tak, aby se potlačil vliv
% váhování na výkon
% -> twosided to mění taky - onesided není polovina twosided
% -> u onesided se celý výkon signálu nacpe do poloviny spektra
% -> u twosided každá komplexní exponenciála nese poloviční výkon
% -> aby to vyšlo stejně jako pwelchtak to musim dělit wlen, fs a výkonem okna
% -> v pwelchu option psd dá pryč škálování Ts
N = 10000;
un = randn(N,1);
B = 300;
fs = 8000;

a1 = exp(-B*pi/fs);
%nc1 (NF) AR 1.r
b = 1;
a = [1 -a1];

%nc2 AR VF 1.r
b2 = 1;
a2 = [1 a1];

%nc1ma MA NF 1.r
bma1 = [1 a1];
ama1 = 1;

%%model 2ř
p1 = 0.9*exp(j*0.9);
p2 = 0.9*exp(-j*0.9);
poles = [p1; p2];
a2r = poly(poles);
b2r = 1;


nc1 = filter(b,a,un);
nc2 = filter(b2,a2,un);
nc1ma = filter(bma1, ama1, un);
nc12r = filter(b2r,a2r,un);



wlen = 512;
noverlap = wlen/2;
NFFT = wlen;

figure(1)
freqz(b,a,1000,fs)

figure(2)
subplot(211)
plot(un)
subplot(212)
plot(nc1)

figure(3)
pwelch(nc1,wlen,noverlap,NFFT,fs)

frame = nc1(1:wlen);
ff = 0:fs/NFFT:fs/2;
N = fft(frame);
Gnc1 = 20*log10(abs(N)./NFFT);

figure(4)
plot(ff,Gnc1(1:NFFT/2+1))

figure(5)
spectrogram(nc1,wlen,[],[],fs,"yaxis")
colorbar off
colormap jet



%% LPC analýza - identifikace AR modelu
%LPC - linear predictive coding -> reprezentace signálu méně parametry
%kritérium - minimalizace výkonu chybového signálu
%normální rovnice
%[R0 .  Rp-1][a1]    [R1]
%[R1  .    .][. ] = -[. ]
%[Rp-1 .  R0][ap]    [Rp]
%řád prediktoru maximálně desítky (komprese)
%funkce [koeficienty, výkon chyby predikce]=lpc(signál,řád filtru)
p = 4; %řád filtru
sig = loadbin("nc4.bin");

a_lpc = lpc(sig(1:1000),p);

 figure(6)
 zplane(1,a_lpc)
% clf
% %zplane(bma1,ama1)
% poles=roots(a_lpc);
% hold on
% plot(real(poles),imag(poles), 'rx')
% plot(0,0,'ro')
% hold off

 %figure(1)
% freqz(bma1,ama1,1000,fs)
% hold on
% [H,F] = freqz(b,a_lpc,1000,fs);
% subplot(211)
% plot(F,20*log10(abs(H)), 'r')
% hold off
figure(7)
freqz(b,a_lpc,1000,fs)

figure(8)
pwelch(sig,wlen,noverlap,NFFT,fs)

frame = sig(1:wlen);
ff = 0:fs/NFFT:fs/2;
Gnc1 = 10*log10(abs(fft(frame)).^2./NFFT);

figure(9)
plot(ff,Gnc1(1:NFFT/2+1))

figure(10)
spectrogram(sig,wlen,[],[],fs,"yaxis")
colorbar off
colormap jet

%lpc spektrum je spektrum syntetizujícího filtru (1/A(z)), v syntetizátoru
%potřebuju výkon chyby predikce Ep -> přenosová fce sqrt(Ep)/A(z)

%% lpc analýza řeči
p = 16;
sig1 = loadbin('vm0-512.bin');
wlen = length(sig1);
w = hamming(wlen);
sig1 = sig1(:);
S = fft(sig1.*w);
Gs = (abs(S).^2)./wlen;

[a,Ep] = lpc(sig1.*w,p);

figure(11)
freqz(sqrt(Ep),a,wlen,"whole")

figure(12)
plot(10*log10(Gs))

H = freqz(sqrt(Ep),a,wlen,"whole");
hold on
plot(20*log10(abs(H)), "r")
hold off

figure(13)
plot(sig1)

figure(14)
zplane(1,a)
%rozdíl mezi LPC kepstrem a DFT kepstrem - DFT se počítá inverzní DFT ->
%konečné
%LPC se počítá inverzní Z transformací -> řada -> LPC kepstrum je nekonečné
%LPC spektrum je vyhlazené, chybí informace o šumovém charakteru a
%periodicitě -> nebudou ani v kepstru
%c0 nese informaci o energii, o tvaru nesou až další složky
close all
sig = loadbin("SA001S04.CS0");
fs = 16000;
%délka segmentu v s
tlen = 0.032;
%krok segmentace v čase
tstep = tlen/2;
%délka segmentu ve vzorcích
wlen = tlen*fs;
%krok segmentace ve vzorcích
wstep = tstep*fs;
%řád LPC
p = 16;
%počet kepstrálních koeficientů
cp = 12;
%výpočet dft a lpc kepster signálu
dft_ceps = vrceps(sig,1,cp,wlen,wstep); % + wind - vektor hammingova okna
LPC_ceps = vaceps(sig,1,p,cp,wlen,wstep);

%kepstrální koeficienty ze začátku ->šum
cbckg = mean(dft_ceps(1:20, :));

%kepstrální vzdálenost od šumu
bcg_dif = cde(dft_ceps, cbckg);

%filtrace
%řád filtru
M = 30;
Wc = 0.5;
b = fir1(M,Wc,'high');
sig2 = filter(b,1,sig);

%výpočet dft a lpc kepster filtrovaného signálu
dft_ceps2 = vrceps(sig2,1,cp,wlen,wstep);
LPC_ceps2 = vaceps(sig2,1,p,cp,wlen,wstep);
%kepstrální vzdálenost sig1 a sig2
ceps_dif_dft = cde(dft_ceps, dft_ceps2);
ceps_dif_lpc = cde(LPC_ceps, LPC_ceps2);

figure(1)
subplot(211)
plot(dft_ceps(:,(2:end)))
title("dft kepstrum")
subplot(212)
plot(LPC_ceps(:,(2:end)))
title("lpc kepstrum")

figure(2)
subplot(211)
plot(sig)
title("signal")
axis tight
subplot(212)
spectrogram(sig,wlen,[],[],fs,"yaxis")
colormap jet
colorbar off
axis tight

figure(3)
subplot(211)
plot(dft_ceps(105,(2:end)))
title("dft kepstrum 105. segment")
subplot(212)
plot(LPC_ceps(105,(2:end)))
title("lpc kepstrum 105. segment")

figure(4)
subplot(211)
plot(ceps_dif_dft)
title("kepstrální vzdálenost DFT")
subplot(212)
plot(ceps_dif_lpc)
title("kepstrální vzdálenost LPC")

figure(5)
subplot(211)
spectrogram(sig,wlen,[],[],fs,"yaxis")
title("spektrogram původního signálu")
colormap jet
colorbar off
axis tight
subplot(212)
spectrogram(sig2,wlen,[],[],fs,"yaxis")
title("spektrogram zkresleného signálu")
colormap jet
colorbar off
axis tight

figure(6)
plot(bcg_dif)
title("kepstrální vzdálenost od pozadí")

%%hranice segmentů
[sig3, fs2] = audioread("sinusovky.wav");
%kepstrum sinusovek - bez překryvu -> wstep = wlen
dft_ceps3 = vrceps(sig3,1,cp,wlen,wlen);
%kepstrální vzdálenost sousedních segmentů
dft_ceps_ndif = cde(dft_ceps3((2:end),:), dft_ceps3((1:end-1), :));
dft_ceps_ndif2 = cde(dft_ceps3((2:end),(2:end)), dft_ceps3((1:end-1), (2:end)));
figure(7)
subplot(311)
plot(dft_ceps3(:,(2:end)))
title("DFT kepstrum sinusovek")
subplot(312)
spectrogram(sig3,wlen,[],[],fs2,"yaxis")
title("spektrogram sinusovek")
subplot(313)
plot(dft_ceps_ndif)
title("DFT kepstrální vzdálenost sousedních segmentů")
hold on
plot(dft_ceps_ndif2,'r')
hold off

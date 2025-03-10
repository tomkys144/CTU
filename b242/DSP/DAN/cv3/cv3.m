close all; clc; clear;

% zpoždění mezi signály když snímáme např dvěma mikrofony
% oba signály budou mít šum navíc, každý jiný, šumy n1 a n2 budou nekorelované

% SIMULACE 1
% signál x1 = s[n] (+n1)
% signál x2 = s[n-D] (+n2) - zpožděný signál oproti x1

fs = 16000;
s = loadbin('SA001S01.CS0');
% zpožděný signál useknem  zepředu

xmin = 5.9e4; % oříznutí signálu;
xmax = 6.2e4;
s = s(xmin:xmax);
delay = 20;


x1 = s(1 + delay:end);
x2 = s(1:end - delay);


figure(1);
plot([x1 x2]);

[r, idx_posunu] = xcorr(x1, x2);

figure(2);
plot(r);

[~, delay_corr] = max(r);
delay_corr = idx_posunu(delay_corr);
% delay_corr = - (length(r)+1)/2 + delay_corr ;
% SIMULACE 2
% x1 = s[n] + n1
% x2 = s[n] konv H(z) + n2 - modifikovaný přenosovou funkcí H(z) - FIR filtr

% Sxy = cpsd(x1, x2, wlen, noverlap, NFFT, fs) fs jestli se nám chce
% po CPSD se zobrazí pouze modul, ale ne fáze, musíme tedy vykreslovat
% rucně abychom měli taky zobrazenou fázi
% takže: [Sxy, FF] = cpsd(x,y,wlen, noverlap, NFFT, fs);

% pwelch(x, wlen, noverlap, NFFT)
% překryv 50 %
% okno 512
% napočítáme cpsd

wlen = 512;
noverlap = wlen/2;

[Sxy, FF] = cpsd(x1,x2,wlen, noverlap, wlen, fs);

figure(3);
cpsd(x1, x2, wlen, noverlap, wlen);


% pokračování na 4. cvičení
% 2 grafy: plot(FF, 10*log10(abs(Sxy)) % už je to výkonová hustota, nebudeme mocnit
% na druhou
% grid;
% fáze: plot(FF, unwrap(angle(Sxy))) %angle dělá od -pi do pi, unwrap to
% rozbalí

figure(4);
subplot(211);
plot(FF, 10*log10(abs(Sxy)));
grid on;

subplot(212);
plot(FF, unwrap(angle(Sxy)));
grid on;



% řád filtru
M = 30;
Wc = 0.05; %"toto"/fs/2; normovaný mezní kmitočet
b = fir1(M, Wc, 'High');
a = 1;

x2 = filter(b,1,x1);
%přidávám šum
%bílý šum
n1 = randn(length(x1),1);
n2 = randn(length(x1),1);
%normovací konstanta 
K = 0.001;
n1 = n1.*K;
n2 = n2.*K;

x1 = x1 + n1;
x2 = x2 + n2;

[P12, ff] = cpsd(x1,x2,[],[],[],fs);

figure(5)
subplot(211)
plot(ff,20*log10(abs(P12)))
title('magnitude CPSD of sig1 and sig2_2 with noise')
subplot(212)
plot(ff, unwrap(angle(P12)))
title('phase CPSD of sig1 and sig2_2 with noise')

% koherence signálů
% mscohere
figure(6);
% subplot(211);
mscohere(x1,x2, wlen,noverlap,[],fs);

% odhad Sxy = průměr(XY*/N)

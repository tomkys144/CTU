% DCT - definované jenom na bázi kosinů
clear; clc; close all;
x = [10 7 4 1 -2 -5 -8 -5 -2 1];

Xc1 = dctxc1(x);


figure;
subplot(221);
stem(x);
title('Původní signál');

subplot(222);
plot(Xc1,'.-');
title('DCT-2');

% doplnění: sudé délky 2N-2
% stejnosměrná složka se vyskytuje pouze jednou
% doplněný signál- opakuje se jen část bez posledního a prvního vzorku

y = [x fliplr(x(2:end-1))];

y_fft = real(fft(y));

subplot(223);
stem(y);
title('Doplněný signál');

subplot(224);
plot(y_fft,'.-');
title('DFT 2N-1');

% sudé dct-2 délky 2N

x2N = [x flip(x)];

Xc2 = dctxc2(x);

X2 = fft(x2N);
k = 0:1:length(x2N) - 1;
% přenásobení exponencielou po provedení DFT
X2 = real(exp(-1j.*(k.*pi)./(length(x2N))).*X2);

figure;
subplot(221);
stem(x);
title('Původní signál');

subplot(222);
plot(Xc2,'.-');
title('DCT-2');

subplot(223);
stem(x2N);
title('Symetrický signál');

subplot(224);
plot(X2,'.-');
title('DFT 2N');

% kepstrum



frame = loadbin('frame.bin');
c1 = log(abs(fft(frame)));

c2 = rceps(frame);

N = length(c2);

k = 1:N/2+1;
c1=c1(k);
idct = idctxc1(c1);







figure;
subplot(221);
plot(c2);
xlim([0 N/2+1]);

subplot(222);
plot(idct);
xlim([0 N/2+1])
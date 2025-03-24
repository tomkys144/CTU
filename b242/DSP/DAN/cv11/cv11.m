clc; clear; close all


fs = 16000;
wlen = 200;
wstep = 50;
numreal = 20;
k = 0.0001;

slen = 2000;
f1 = 821;
t = 0:1/fs:(slen - 1)/f1;
t = t(:);
s1 = sin(2*pi*f1*t);
s1 = s1(:);

%načtení řečového signálu
r1 = loadbin('vm0.bin');
r1 = r1(:);

signal = s1;

slen = length(signal);
wnum=(slen-wlen)/wstep+1 ;

SS = zeros(numreal, wlen);

for i=1:numreal
    % short-time frame selection
    ii=(i-1)*wstep+1;
    jj=(i-1)*wstep+wlen;
    
    segment = signal(ii:jj);
    SS(i,:) = segment;
end

Rss = SS'*SS;

[V, D] = eig(Rss);
D = diag(D);

figure;

subplot(515);
plot(D,'ob');
title('Vlastní čísla');

subplot(511);
plot(V(:,(end - 3)));
title('vlastní vektor čtvrtý od konce');
subplot(512);
plot(V(:,(end - 2)));
title('vlastní vektor třetí od konce');
subplot(513);
plot(V(:,(end - 1)));
title('vlastní vektor druhý od konce');
subplot(514);
plot(V(:,(end)));
title('vlastní vektor poslední');

% vlastní vektory jsou dobrou bází pro KLT transformaci

WKLT1 = flipud(V');
% x1 = s1(110:309); % báze a signál si neodpovídá
x1 = SS(1,:)'; % báze a signál si odpovídá
XKLT1 = WKLT1*x1;
Xfft1 = fft(x1);
Xdct1 = dctxc1(x1);

% KLT má nejlepší kompresní vlastnosti
% Optimální transformace - báze není vždycky stejná, je závislá na datech z
% určité skupiny
figure();
subplot(311)
plot(XKLT1,'')
title('KLT spektrum s1')
subplot(312)
plot(abs(Xfft1))
title('fft spektrum s1')
subplot(313)
plot(Xdct1)
title('dct spektrum s1')
%% sim1
sig1 = loadbin("SA001S01.CS0");
sig1 = sig1(:);
wlen = 3000;
xmin = 24641;

xmax = xmin + wlen;
fs = 16000;

%delay filter
M = 20;
b = [zeros(1,M) 1];

%delayed signal
sig2 = filter(b,1,sig1);

%CCF of sig1 and sig2
[R12, lags] = xcorr(sig1(xmin:xmax),sig2(xmin:xmax));

%CPSD of sig1 and sig2
%zpoždění se dopočítá ze směrnice fáze 
[P12, ff] = cpsd(sig1(xmin:xmax),sig2(xmin:xmax),[],[],[],fs);

figure(1)
subplot(211)
plot([sig1 sig2])
%xlim([xmin xmax])
title('simulation ideal delay')
subplot(212)
plot(lags,R12)
title('CCF of sig1 and sig2')

figure(2)
subplot(211)
plot(ff,20*log10(abs(P12)))
title('magnitude CPSD of sig1 and sig2')
subplot(212)
plot(ff, unwrap(angle(P12)))
title('phase CPSD of sig1 and sig2')

%delay calculation from CPSD phase points
f1 = 1000;
f2 = 7000;
fi1 = 7.70486;
fi2 = 54.9817;
df = f2 - f1;
dfi = 54.9817 - 7.70468;
delay = dfi/df*fs/(2*pi);

%% sim2
%řád filtru
M1 = 30;
%mezní frekvence normovaná k fs/2
Wc = 0.05;
%návrh FIR filtru
b = fir1(M1,Wc,'high');
%bílý šum
n1 = randn(wlen,1);
n2 = randn(wlen,1);
%normovací konstanta 
K = 0.01;
n1 = n1.*K;
n2 = n2.*K;
%zpoždění filtrací
sig2_2 = filter(b,1,sig1);
%přidávám šum
sig1 = sig1(xmin:xmax - 1) + n1;
sig2_2 = sig2_2(xmin:xmax - 1) + n2;

[P12, ff] = cpsd(sig1,sig2_2,[],[],[],fs);

figure(3)
subplot(211)
plot(ff,20*log10(abs(P12)))
title('magnitude CPSD of sig1 and sig2_2 with noise')
subplot(212)
plot(ff, unwrap(angle(P12)))
title('phase CPSD of sig1 and sig2_2 with noise')

figure(4)
freqz(b,1,1000)
title("filter freq. char")

%% cv. 4 - koherenční funkce

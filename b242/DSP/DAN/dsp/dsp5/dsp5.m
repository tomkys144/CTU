%% kepstrální analýza
f = 500;
fs = 8000;
tau = 0.001;
N = 100;

%signal generation
tt = 0:1/fs:(N-1)/fs;
s1 = cos(2*pi*f*tt).*exp(-tt/tau);
s1 = s1(:);

%cepstrum calculation
c1 = rceps(s1);
c11 = ifft(log(abs(fft(s1))));

%filter parameters
m = 0.01;
M = 15;
%filter impulse response
h = zeros(N,1);
h = h(:);
h(1) = 1;
h(M+1) = m;

%filtering signal s1
s2 = filter(h,1,s1);

%s2 cepstrum
c2 = rceps(s2);

%h cepstrum
hc = rceps(h);

%amplitude spectrums
S1 = log(abs(fft(s1)));
S2 = log(abs(fft(s2)));
H  = log(abs(fft(h)));

%liftration
w = [ones(15,1);zeros(N - 29,1);ones(14,1)];
c21 = c2.*w;
S21 = real(fft(c21));

%complex cepstrum
cc1 = cceps(s1);
cc2 = cceps(s2);

%complex cepstrum liftration
w2 = [ones(15,1);zeros(N -15,1)];
cc21 = cc2.*w;
%from liftered cepstrum to signal
s22 = ifft(exp(fft(cc21)));

figure(1)
subplot(211)
plot(tt, s1)
title("signal s1")
subplot(212)
plot(c1)
title("s1 cepstrum")

figure(2)
subplot(211)
plot(tt,s2)
title("signal s2")
subplot(212)
plot(c2)
title("s2 cepstrum")

figure(3)
subplot(211)
plot(tt,h)
title("impulse response")
subplot(212)
plot(hc)
title("impulse response cepstrum")

figure(4)
subplot(311)
plot(S1)
title("s1 log spectrum")
subplot(312)
plot(S2)
title("s2 log spectrum")
subplot(313)
plot(H)
title("h log spectrum")

figure(5)
subplot(211)
plot(c21)
title("cepstrum after liftration")
subplot(212)
plot(S21)
title("spectrum after liftration")

figure(6)
subplot(211)
plot(cc1)
title("complex cepstrum of s1")
subplot(212)
plot(cc2)
title("complex cepstrum of s2")

figure(7)
plot(s22)
title("signal after inverse transformation")

%% part 2
x = loadbin("vm0.bin");
x = x(:);
wlen = 512;

%weighting window
win = hamming(wlen);
x = x(2000 -wlen +1: 2000);
x = x.*win;
X = log(abs(fft(x)));

%real cepstrum
cx = rceps(x);

%liftration
win2 = [ones(99,1);zeros(512-99-98,1) ;ones(98,1)];
cx2 = cx.*win2;
X2 = real(fft(cx2));


figure(8)
subplot(211)
plot(x)
subplot(212)
plot(X)

figure(9)
plot(cx)
title("real cepstrum")

figure(10)
plot(X2, 'r')
hold on
plot(X, 'b')
hold off


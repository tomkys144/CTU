clear; clc; close all;

N = 100;
fs = 8000;
f = 500;
t = 1:N;
t = t/fs;
tau = 0.001;
s = cos(2*pi*f*t).*exp(-t/tau);

H = fft(s);
F=linspace(0,fs-fs/N, N);

% kepstrum
ceps = ifft(log(abs(H).^2));

figure(1);
subplot(311);
plot(t, s);
xlabel('čas (s)');
ylabel('s [-]');

subplot(312);
plot(F, abs(H));
xlabel('frekvence (Hz)');
ylabel('spektrum [-]');

subplot(313);
plot(ceps);
xlabel('kvefrence (s)');
ylabel('kepstrum [-]');

% filter impulse response
m = 0.7;
M = 15;

h = zeros(N,1);
h = h(:);
h(1) = 1;
h(M+1) = m;

b = h;
a = 1;

% filtering signal s
s2 = filter(b,a,s);

H = fft(s2);

% kepstrum
ceps = ifft(log(abs(H).^2));

figure(3);
subplot(311);
plot(t, s2);
xlabel('čas (s)');
ylabel('s [-]');
title('Cosinus s odrazem');

subplot(312);
plot(F, abs(fft(h)));
xlabel('frekvence (Hz)');
ylabel('spektrum [-]');
title('Frekvenční odezva odrazového filtru');

subplot(313);
% plot(ceps);
plot(F, abs(H));
xlabel('kvefrence (s)');
ylabel('kepstrum [-]');
title('Spektrum cosinu s odrazem');
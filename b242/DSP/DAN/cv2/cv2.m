% DSP cv1 - modelování
nc1 = loadbin('nc4.bin');
B=300; % šířka pásma
fs = 8000; % vzorkovací frekvence

% generování NF filtru AR 1. řádu
% a1 = -exp(-B*pi/fs);

% generování VF filtru AR 1.řádu
a1 = exp(-B*pi/fs);

b=1;

p = 4;
a_lpc = lpc(nc1,p);

[Hlpc, ff]=freqz(b,a_lpc,length(nc1),fs);

figure;
subplot(211);
hold on
plot(ff,20*log10(abs(Hlpc)), 'r'); % na výkonové urovni
hold off

subplot(212);
plot(ff,angle(Hlpc));


poles = roots(a_lpc);

figure;
hold on
zplane(b, a_lpc);
% plot(real(poles), imag(poles), 'xr');
hold off

% figure(1);
n = 1000;
% freqz(B,a,n,fs,'whole');
% figure;
% freqz(B,a,n,fs);
%a=[1 a1]; 
%%

% AR, 2. rad
b=1;
a=poly([0.9*exp(-j*0.9) 0.9*exp(j*0.9)]);

[Hlpc, ff]=freqz(b,a,1000,fs);

figure;
subplot(211);
hold on
plot(ff,20*log10(abs(Hlpc)), 'r'); % na výkonové urovni
hold off

subplot(212);
hold on
plot(ff,angle(Hlpc));
hold off

poles = roots(a_lpc);

figure;
hold on
zplane(a,b);
hold off

% "DU" srovnávání vyhlazených odhadů na bázi Welchovy metody a na bázi lpc 
% vyhlazený odhad na bázi Welchovy metody nebo na bázi lpc
% Welch - musíme mít k dispozici pro průměrování vícero segmentů ze signálu
% LPC - lpc počítáme ronou ze signálu, není potřeba delší úsek a vícero
% realizací
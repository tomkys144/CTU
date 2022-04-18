clear all;
close all;
clc;

%% Generovani signalu
fs = 100;
T = 5;

% harmonický signál: y(t)=Y0+Ym*sin(2*pi*f0*t+fi)

f0 = 5;
fi = pi/4;
Ym = 2;
Y0 = 1;

tn1 = 0 : 1/fs : T-1/fs;

tn = linspace(0, T-1/fs, T*fs);

y=Y0+Ym*sin(2*pi*f0*tn+fi);

%% Vykresleni

figure(1);

subplot(311);
plot (tn, y);
xlabel('čas (s)');
ylabel('y[t_n]');

subplot(312);
n = 1:length(y);
plot(n, y);
xlabel('n (-)');
ylabel('y[n]');

subplot(313);
plot(n, y, ' .b');
xlabel('n (-)');
ylabel('y[n]');

%% Vliv vzorkování na interpretaci signálu

fs10=round(f0*10);
fs3=round(f0*3);
fs1_2=round(f0*1.2);

t10 = linspace (0, T-1/fs10, T*fs10);
y10 = Y0+Ym*sin(2*pi*f0*t10+fi);

t3 = linspace (0, T-1/fs3, T*fs3);
y3 = Y0+Ym*sin(2*pi*f0*t3+fi);

t1_2 = linspace (0, T-1/fs1_2, T*fs1_2);
y1_2 = Y0+Ym*sin(2*pi*f0*t1_2+fi);

figure(2);

subplot(411);
plot(tn, y, '-xc');
xlabel('čas (s)'); ylabel('y[t_n]'); title(['fs=' num2str(fs) 'Hz r=' num2str(fs/f0)]);

subplot(412);
plot(t10, y10, '-xr');
xlabel('čas (s)'); ylabel('y[t_n]'); title(['fs=' num2str(fs10) 'Hz r=' num2str(fs10/f0)]);

subplot(413);
plot(t3, y3, '-xm');
xlabel('čas (s)'); ylabel('y[t_n]'); title(['fs=' num2str(fs3) 'Hz r=' num2str(fs3/f0)]);

subplot(414);
plot(t1_2, y1_2, '-xb');
xlabel('čas (s)'); ylabel('y[t_n]'); title(['fs=' num2str(fs1_2) 'Hz r=' num2str(fs1_2/f0)]);

fprintf('Jaká frekvenci signálu f0 byla nastavena? %.0fHz\n', 5);
fprintf('Jakou frekvenci vidíme při nedodržení vzorkovacího kmitočtu? %.0fHz\n', 1);

%% Kvantizace

fs=50e3;
T = 2;
ta=linspace(0, 2-1/fs, T*fs);
a=sin(2*pi*440*ta);

figure(3);
subplot(421);
plot(ta,a);
xlabel('čas (s)');
xlim([0 (1/440)]);
title('64 bit (double)');

sound(a, fs)

%% 8 bit
q8 = 2^8;
a8 = round(a * (q8/2)) / (q8/2);

subplot(423)
plot(ta,a8)
xlabel('čas (s)')
xlim([0 (1/440)])
title('8 bit (256)');

sound(a8,fs)

e8=a-a8;

subplot(424)
plot(ta,e8)
xlabel('čas (s)')
xlim([0 (1/440)])
ylim([-0.2 0.2])
title('a(64 bit) - a(8 bit)')

A=sum(abs(a).^2);
E8=sum(abs(e8).^2);
SQNR8=10*log10(A/E8);
SQNR8_theory=20*log10(q8);

%% 4 bit
q4 = 2^4;
a4 = round(a * (q4/2)) / (q4/2);

subplot(425)
plot(ta,a4)
xlabel('čas (s)')
xlim([0 (1/440)])
title('4 bit (16)');

sound(a4,fs)

e4=a-a4;

subplot(426)
plot(ta,e4)
xlabel('čas (s)')
xlim([0 (1/440)])
ylim([-0.2 0.2])
title('a(64 bit) - a(4 bit)')

A=sum(abs(a).^2);
E4=sum(abs(e4).^2);
SQNR4=10*log10(A/E4);
SQNR4_theory=20*log10(q4);

%% 2 bit
q2 = 2^2;
a2 = round(a * (q2/2)) / (q2/2);

subplot(427)
plot(ta,a2)
xlabel('čas (s)')
xlim([0 (1/440)])
title('2 bit (4)');

sound(a2,fs)

e2=a-a2;

subplot(428)
plot(ta,e2)
xlabel('čas (s)')
xlim([0 (1/440)])
ylim([-0.2 0.2])
title('a(64 bit) - a(2 bit)')

A=sum(abs(a).^2);
E2=sum(abs(e2).^2);
SQNR2=10*log10(A/E2);
SQNR2_theory=20*log10(q2);

%% SQNR
bits = [8; 4; 2];
SQNR = [SQNR8; SQNR4; SQNR2];
SQNR_theory = [SQNR8_theory; SQNR4_theory; SQNR2_theory];

T = table(bits, SQNR, SQNR_theory);
T.Properties.VariableNames = {'Počet bitů', 'Změřená SQNR [dB]', 'Teoretická SQNR [dB]'};
disp(T);
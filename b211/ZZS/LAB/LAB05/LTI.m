beep off
close all
clear all
clc

%% gate
fs=500;
T=1;
x=zeros(fs,T);
x(1)=1;
t=linspace(0, T-1/fs, T*fs);

h=blackbox_2021(x,fs);

Nh=length(h);
H=fft(h);
F=linspace(0,fs-fs/Nh,Nh);

phi=angle(H);

figure('Name', 'Korelace', 'NumberTitle', 'off', 'Units', 'normalized', 'Position', [0 0 1 1]);

subplot(411);
plot(t,x);
xlabel('time(s)'); ylabel('\sigma[n]');
xlim([-0.1 T+0.1]); ylim([-0.1 1.1]);

subplot(412);
plot(t,h,'r');
xlabel('time(s)'); ylabel('h[n]');
xlim([-0.1 T+0.1]); ylim([-0.1 1.1]);

subplot(413);
stem(F,abs(H),'.g');
xlabel('f(Hz)'); ylabel('|H(f)|');
ylim([-0.1 1.1]);

subplot(414);
stem(F,phi, '.');
xlabel('f(Hz)'); ylabel('\phi(f)[rad]');

disp('1) Pásmová zádrž 50 a 150 Hz');

%% EKG
ecg=load('ecg_hum_fs500Hz.txt');
fs=500;
N=length(ecg);
T=N/fs;
t=linspace(0, T, N);

figure('Name', 'ECG', 'NumberTitle', 'off', 'Units', 'normalized', 'Position', [0 0 1 1]);
subplot(5,2,[1 2]);
plot(t, ecg);
xlim([0 t(length(t))]);
xlabel('time(s)'); ylabel('(mV)');

subplot(523);
plot(t, ecg);
xlim([0 5]);
xlabel('time(s)'); ylabel('(mV)');

subplot(524);
pwelch(ecg,fs,fs/2,[],fs);

subplot(525);
y=conv(ecg,h,'full');
Ty=length(y)/fs;
ty=linspace(0, Ty, length(y));
plot(ty, y);
xlim([0 5]);
xlabel('time(s)'); ylabel('(mV)'); title('Convolution');

subplot(526);
pwelch(y,fs,fs/2,[],fs);

subplot(527);
ybb=blackbox_2021(ecg,fs);
Nbb=length(ybb);
Tbb=Nbb/fs;
tbb=linspace(0, Tbb, Nbb);
plot(tbb, ybb);
xlim([0 5]);
xlabel('time(s)'); ylabel('(mV)'); title('Black box output');

subplot(528);
pwelch(ybb,fs,fs/2,[],fs);

Key=["Délka signálu [vzorků]";"Délka impulzní odezvy [vzorků]";"Délka výsledku konvoluce [vzorků]:"];
Value=[N; Nh; length(y)];
Tab=table(Key, Value);
Tab.Properties.VariableNames = {'Question', 'Answer'};
disp(Tab);

disp('2) Je odfiltrováno 50 Hz ze signálu');

subplot(529);
[Rxy, m] = xcorr(ecg, y);
tm = m/fs;

plot(tm, Rxy, 'r');
xlim([-3 3])
xlabel('\tau(s)'); ylabel('R_{ecg,y}(\tau)'); title('XCorr');

[~, I] = max(Rxy);
fprintf('3) Calculated: %.1fs \nManual: %.1fs\n', abs(tm(I)), 0.2);
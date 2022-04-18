close all
clear all
clc

%% Křížová korelace

figure('Name', 'Křížová korelace');

fs=1000;
delta=100;
start=100;

subplot(311);

x=zeros(fs,1);
x(start:start+50,1)=1;

plot(x);
ylim([0 1.1]);
xlabel('[n]'); ylabel('x[n]');

subplot(312);

y=zeros(fs,1);
y(start+delta:start+50+delta,1)=1;

plot(y);
ylim([0 1.1]);
xlabel('[n]'); ylabel('y[n]');

subplot(313);
[Rxy,m]=xcorr(x,y);

plot(m,Rxy);
ylim([0 60]);
xlabel('[m]'); ylabel('R_{xy}');

%% EKG

load('ECG_PSG.mat');
T=length(ecg)/fs;
t=linspace(0, T-1/fs, T*fs);

figure('Name', 'EKG');

subplot(411);
plot(t,ecg);
xlabel('time(s)'); ylabel('ECG');

subplot(412);
plot(t,psg);
xlabel('time(s)'); ylabel('PSG');

subplot(413);

[Rxy,m]=xcorr(ecg, psg);

tm = m/fs;
plot(tm, Rxy);
xlabel('\tau(s)'); ylabel('R_{xy}(\tau)');

[M,I]=max(Rxy);
tau=abs(tm(I));
v=L/tau;

fprintf('Vypočítejte rychlost pulzní vlny rychlost=dráha/čas: %0.3f m/s\n\n', L/abs(tau));

subplot(414)

Nr = length(Rxy);
rxy = abs(1/Nr * fft(Rxy));
F=linspace(0, fs-fs/Nr, Nr);
stem(F, rxy, '.');
xlim([0 15]);
xlabel('f(Hz)'); ylabel('PSD');

[K, If] = max(rxy);
f = F(If);
bpm = round(f*60);

BPM = [bpm; 15*6];
method = ["Křížová korelace"; "Počet R-špiček"];

T = table(method, BPM);
T.Properties.VariableNames = {' ', 'Počet cyklů za minutu (BPM)'};
disp(T);

%% Autokorelace

[s,fs]=audioread('Rozhlas_echo.m4a');
% sound(s,fs);
T=length(s)/fs;
t=linspace(0, T-1/fs, fs*T);

figure('Name', 'Autokorekce');

subplot(211);
plot(t,s);
xlabel('time(s)'); ylabel('audio');
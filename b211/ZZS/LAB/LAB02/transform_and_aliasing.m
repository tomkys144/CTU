clear all
close all
clc

fs=100;

f1=5;
f2=15;
A1=1;
A2=0.5;
fi1=0;
fi2=-pi/2;

T=2;
t=linspace(0,T-1/fs,fs*T);

y=A1*sin(2*pi*f1*t+fi1)+A2*sin(2*pi*f2*t+fi2);

%% Spektrum

N=length(y);
Y=(1/N)*fft(y);

% Frekvenční osa:
% k∈〈0,N-1〉→fk∈〈0,fs-fs/N〉
F=linspace(0,fs-fs/N,N);

figure('Name','Spectrum','NumberTitle','off');

subplot(311);
plot(t,y);
xlabel('time(s)'); ylabel('y[n]');

subplot(312);
stem(F, abs(Y), '.');
title('Spectrum (fs=100Hz)'); xlabel('f(Hz)'); ylabel('|Y(f)|');
hold on;
plot([fs/2 fs/2], [0 0.6], ':');

subplot(313);
stem(F, angle(Y), '.');
xlabel('f(Hz)'); ylabel('\phi (rad)');
hold on;
plot([fs/2 fs/2], [-4 4], ':');

k=find(abs(Y)>1e-6);
F(k);

y1=real(Y(k(1))*exp(1i*2*pi*F(k(1))*t));
y2=real(Y(k(2))*exp(1i*2*pi*F(k(2))*t));
y3=real(Y(k(3))*exp(1i*2*pi*F(k(3))*t));
y4=real(Y(k(4))*exp(1i*2*pi*F(k(4))*t));

figure('Name','Time course','NumberTitle','off');

subplot(611);
plot(t,y, ' r');
title('original signal fs=100'); xlabel('time(s)'); ylabel('y[n]');

subplot(612);
plot(t,y1);
xlabel('time(s)'); ylabel('y_{5Hz}[n]');

subplot(613);
plot(t,y2);
xlabel('time(s)'); ylabel('y_{15Hz}[n]');

subplot(614);
plot(t,y3);
xlabel('time(s)'); ylabel('y_{85Hz}[n]');

subplot(615);
plot(t,y4);
xlabel('time(s)'); ylabel('y_{95Hz}[n]');

subplot(616);
plot(t,(y1+y2+y3+y4));
title('sum:y_{5Hz}+y_{15Hz}+y_{85Hz}+y_{95Hz}');
xlabel('time(s)'); ylabel('y[n]');

disp('Proč komponenta 5Hz a 95 Hz (respektive 15 Hz a 85 Hz) vypadají stejně?');
disp('Jelikož fs/2 = 50Hz a je to převrácené');

%% aliasing preparation

fs100=100;
f0=95;

T=0.25;
t100=linspace(0,T-1/fs100,T*fs100);

y100=sin(2*pi*f0*t100);

figure('Name', 'Aliasing Preparation', 'NumberTitle', 'off');

plot(t100,y100,'-o');
xlabel('time(s)');ylabel('y_{95Hz}[n]');
hold on;
disp('Jaká je frekvence vzniklého signálu?');
disp('Nastavená: 95 HzOdečtená zgrafu(f0=T0-1): 5Hz');

fs_ok=400;
t_ok=linspace(0, T-1/fs_ok,T*fs_ok);
y_ok=sin(2*pi*f0*t_ok);

plot(t_ok,y_ok,'r');

disp('Nastavená: 95 HzOdečtená zgrafu(f0=T0-1): 91Hz');

%% aliasing

fs=3e3;
T=5;

t=linspace(0,T-1/fs,T*fs);

ch=chirp(t,50,T,750);
sound(ch,fs);
pause(T);

figure('Name', 'Aliasing', 'NumberTitle', 'off');

subplot(311)
plot(t,ch)
xlabel('time(s)');ylabel('y_{chirp}[n]');

subplot(312)
spectrogram(ch,0.1*fs,0.*fs/2,[],fs,'yaxis');

subplot(313)
ch_new=ch(1:3:end);
fs_new=fs/3;
spectrogram(ch_new,0.1*fs_new,0.*fs_new/2,[],fs_new,'yaxis');
ylim([0 fs/2])

sound(ch_new,fs_new);

%% filtrace ve spektru

ecg=load('ecg_hum_fs500Hz.txt');
fs=500;

N=length(ecg);
S=(1/N)*fft(ecg);
F=linspace(0,fs-fs/N,N);
T=N/fs;
t=linspace(0,T - 1/fs,T * fs);

f = figure('Name', 'Filtr', 'NumberTitle', 'off', 'Position', [0 0 1920 1080]);

subplot(321);
plot(t,ecg);
xlabel('time(s)'); ylabel('ECG(mV)'); title('ECG');

subplot(323);
stem(F, abs(S), '.');
xlabel('f(Hz)'); ylabel('|S(f)|'); title('Absolute spectrum(mV)');

subplot(325);
plot(F, 20*log10(abs(S)), '-');
xlabel('f(Hz)'); ylabel('|S_{dB}(f)|'); title('Absolute spectrum(dB)');

f50=50:50:fs;
for m=1:length(f50)
    idx=find( F>=m*50-1 & F<=m*50+1);
    S(idx)=0;
end

subplot(322);
stem(F, abs(S), '.r');
xlabel('f(Hz)');ylabel('|S(f)|');title('Absolute spectrum(mV) - attenuated n x 50hz');

subplot(324);
plot(F, 20*log10(abs(S)), '-r');
xlabel('f(Hz)'); ylabel('|S_{dB}(f)|'); title('Absolute spectrum(dB) - attenuated n x 50hz');

subplot(326);
ecg_f=real(N*ifft(S));
plot(t,ecg_f,'r');
xlabel('time(s)');ylabel('ECG_{ifft}(mV)'); title('reconstructed ECG by the IFFT');
beep off
close all
clear all
clc

load('ieeg_seizure.mat');
%% filters

Wp=(2*0.5)/fs;
Rp=0.1;
Ws=(2*0.1)/fs;
Rs=60;

[ne,Wp]=ellipord(Wp,Ws,Rp,Rs); % řád filtru
[bhp,ahp]=ellip(ne,Rp,Rs,Wp,'high');
% u HP se otáčí toleranční pole, tj. ´tlum Rs bude na kmitočtu Wp-Ws (zde 0
% Hz)

figure('Name', 'Filters', 'NumberTitle', 'off');

subplot(321);
zplane(bhp, ahp);

subplot(322);
[H,f]=freqz(bhp,ahp,20*fs,fs);
plot(f,20*log10(abs(H)));
xlim([0 2]);
xlabel('f [Hz]'); ylabel('|H(f)|'); title('Ellip High-pass');

Wp=2*600/fs;
Rp=0.1;
Ws=2*750/fs;
Rs=60;

[nb,Wn]=buttord(Wp,Ws,Rp,Rs); % řád filtru
[bdp,adp]=butter(nb,Wn);

subplot(323);
zplane(bdp, adp);

subplot(324);
[Hd,fd]=freqz(bdp,adp,20*fs,fs);
plot(fd,20*log10(abs(Hd)));
xlabel('f [Hz]'); ylabel('|H(f)|'); title('Butterworth Low-pass');

w50=2*50/fs;
R=1;
r=0.99;
[b50,a50]=zp2tf([R*exp(-1j*pi*w50);R*exp(+1j*pi*w50)],...
    [r*exp(-1j*pi*w50);r*exp(+1j*pi*w50)],1);

subplot(325);
zplane(b50, a50);

subplot(326);
[H50,f50]=freqz(b50,a50,20*fs,fs);
plot(f50,20*log10(abs(H50)));
xlim([0 100]);
xlabel('f [Hz]'); ylabel('|H(f)|'); title('Biquad notch');

%% iEEG filtering

y=filtfilt(bhp,ahp,eeg);
y=filtfilt(bdp,adp,y);


for f50=50:50:fs/2
    wn50=2*f50/fs;
    R=1;
    r=0.99;
    [b_n50,a_n50]=zp2tf([R*exp(-1j*pi*wn50);R*exp(+1j*pi*wn50)],...
    [r*exp(-1j*pi*wn50);r*exp(+1j*pi*wn50)],1);
    
    y=filtfilt(b_n50,a_n50,y);
    
end

figure('Name', 'iEEG', 'NumberTitle', 'off');

t=linspace(0, length(eeg)/fs-1/fs, length(eeg));

subplot(221);
plot(t, eeg);
xlabel('time [s]'); ylabel('[mV]'); title('raw iEEG');

subplot(222);
pwelch(eeg,fs);

subplot(223);
plot(t, y);
xlabel('time [s]'); ylabel('[mV]'); title('filtered iEEG');

subplot(224);
pwelch(y,fs);

%% gama band
nch=5;
Rs=60;
Wpp=2*[25 100]/fs;
[bpp,app] = cheby2(nch,Rs,Wpp,'bandpass');

figure('Name', 'gama band', 'NumberTitle', 'off');
subplot(311);
[Hpp,fpp]=freqz(bpp,app,20*fs,fs);
plot(fpp,20*log10(abs(Hpp)));
xlabel('f [Hz]'); ylabel('|H(f)|');

y=filtfilt(bpp,app,y);

subplot(312);
plot(t, y);
xlabel('time [s]'); ylabel('[mV]'); title('gamma-band iEEG');

subplot(313);
pwelch(y,fs);

disp('Kdy si myslíte, že začal záchvat? 30s');
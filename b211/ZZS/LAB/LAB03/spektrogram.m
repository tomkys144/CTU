close all
clear all
clc

%% Spektrum

fs=30;
T=2;
t=linspace(0, T-1/fs, T*fs);

a1=1;   f1=2;
a2=0.5; f2=7; p2=pi/4;
y=a1*sin(2*pi*f1*t)+a2*sin(2*pi*f2*t+p2);

figure('Name', 'Spektrum');

subplot(421);
plot(t,y); hold on;
plot(t+t(end),y,':k');
xlim([0 8]);
xlabel('time(s)'); ylabel('y(t)');

N=length(y);
S=(1/N)*fft(y);
T=linspace(0, fs-fs/N, N);

subplot(422);
stem(T, abs(S), '.');
ylim([0 0.5]);
xlabel('f(Hz)'); ylabel('|Y(f)|');

y=y(1:end-round(0.3*fs));
t=t(1:end-round(0.3*fs));

subplot(423);
plot(t,y); hold on;
plot(t+t(end),y,':k');
xlim([0 8]);
xlabel('time(s)'); ylabel('y(t)');

N=length(y);
S=(1/N)*fft(y);
T=linspace(0, fs-fs/N, N);

subplot(424);
stem(T, abs(S), '.');
ylim([0 0.5]);
xlabel('f(Hz)'); ylabel('|Y(f)|');

win=hamming(length(y));
y=y.*win(:)';

subplot(425);
plot(t,y); hold on
plot(t+t(end),y,':k');
plot(t,win,'r');
xlim([0 8]);
xlabel('time(s)'); ylabel('y(t)');
legend('y', 'periodization', 'hamming');

S=(1/N)*fft(y);
T=linspace(0, fs-fs/N, N);

subplot(426);
stem(T, abs(S), '.');
ylim([0 0.5]);
xlabel('f(Hz)'); ylabel('|Y(f)|');

y=[y zeros(1,2*fs)];
t=linspace(0,(length(y)-1)/fs,length(y));

subplot(427);
plot(t,y); hold on
plot(t+t(end),y,':k');
xlim([0 8]);
xlabel('time(s)'); ylabel('y(t)');

N=length(y);
S=(1/N)*fft(y);
T=linspace(0, fs-fs/N, N);

subplot(428);
stem(T, abs(S), '.');
ylim([0 0.5]);
xlabel('f(Hz)'); ylabel('|Y(f)|');

disp('1. Co způsobí periodizace signálu s neceločíselným poměrem harmonických?');
disp('   Napojení period není spojité');
disp('2. Co způsobí převážení signálu váhovacím oknem?');
disp('   Utlumí kraje periody => utlumení nespojitosti');
disp('3. Jaký efekt má doplnění signálu nulami?');
disp('   Zhustění spektra. Nezmění se energie, ale dostaneme více spektrálních čar');

%% Spektrogram

% Vygenerujte testovací signál (1# chirp, 2# krátký „zázněj“)
fs=1e3; 
T=5; % délka signálu v s
t=linspace(0,T-1/fs,T*fs); % časová osa

% 1#----
y=chirp(t,20,5,500)+0.05*sin(2*pi*50*t); % chirp(20-500Hz)+5% rušení 50 Hz

figure(2);
subplot(3,3,[1 2 3]);
plot(t,y);

% Parametry spektrogramu (např.):
ww=0.5*fs; % velikost okna 500 ms
nn=round(0.75*ww); % přesah 75% 
zz=2*ww; % doplnění nulami (3x hustější spektrum (ww+zz)=3×ww spekt. čar)

idx=1:ww-nn:length(y)-ww+1; % index začátků segmentů (zapamatovat!!!)

win=hamming(ww); % váhovací okno délky segmentu
S=zeros((ww+zz), length(idx));

for i=1:length (idx)
    yseg=y(idx(i):idx(i)+ww-1);
    yseg=yseg.*win(:)';
    yseg=[yseg zeros(1, zz)];
    spec = (1/length(yseg))*fft(yseg);
    S(:,i)=abs(spec');
end

Ti=t(idx+round(ww/2));

F=linspace(0,fs-fs/(ww+zz),(ww+zz));

subplot(334);
imagesc(Ti,F,S); axis xy;
c=colorbar; c.Label.String='Power';
xlabel('time(s)');ylabel('f(Hz)'); title('ww=0.5s');

subplot(337);
imagesc(Ti,F,10*log10(S)); axis xy;
c=colorbar; c.Label.String='dB';
xlabel('time(s)');ylabel('f(Hz)');

ww=2*fs; % velikost okna 2 s
nn=round(0.5*ww); % přesah 50% 
zz=2*ww; % doplnění nulami (3x hustější spektrum (ww+zz)=3×ww spekt. čar)

idx=1:ww-nn:length(y)-ww+1; % index začátků segmentů (zapamatovat!!!)

win=hamming(ww); % váhovací okno délky segmentu
S=zeros((ww+zz), length(idx));

for i=1:length (idx)
    yseg=y(idx(i):idx(i)+ww-1);
    yseg=yseg.*win(:)';
    yseg=[yseg zeros(1, zz)];
    spec = (1/length(yseg))*fft(yseg);
    S(:,i)=abs(spec)';
end

Ti=t(idx+round(ww/2));

F=linspace(0,fs-fs/(ww+zz),(ww+zz));

subplot(335);
imagesc(Ti,F,S); axis xy;
c=colorbar; c.Label.String='Power';
xlabel('time(s)');ylabel('f(Hz)'); title('ww=2s');

subplot(338);
imagesc(Ti,F,10*log10(S)); axis xy;
c=colorbar; c.Label.String='dB';
xlabel('time(s)');ylabel('f(Hz)');

ww=0.2*fs; % velikost okna 200 ms
nn=round(0.5*ww); % přesah 50% 
zz=2*ww; % doplnění nulami (3x hustější spektrum (ww+zz)=3×ww spekt. čar)

idx=1:ww-nn:length(y)-ww+1; % index začátků segmentů (zapamatovat!!!)

win=hamming(ww); % váhovací okno délky segmentu
S=zeros((ww+zz), length(idx));

for i=1:length (idx)
    yseg=y(idx(i):idx(i)+ww-1);
    yseg=yseg.*win(:)';
    yseg=[yseg zeros(1, zz)];
    spec = (1/length(yseg))*fft(yseg);
    S(:,i)=abs(spec)';
end

Ti=t(idx+round(ww/2));

F=linspace(0,fs-fs/(ww+zz),(ww+zz));

subplot(336);
imagesc(Ti,F,S); axis xy;
c=colorbar; c.Label.String='Power';
xlabel('time(s)');ylabel('f(Hz)'); title('ww=0.2s');

subplot(339);
imagesc(Ti,F,10*log10(S)); axis xy;
c=colorbar; c.Label.String='dB';
xlabel('time(s)');ylabel('f(Hz)');

disp("1. Proč je u chirpsignálu spektrogram zdánlivě rozmazaný i pro velké okno (2s), i když je velké spektrální rozlišení f= 0.5 Hz? ");
disp("   Jelikož jsme použili překrytí. Máme proto lepší časové rozlišení, zato horší frekvenční");
disp("2. Je pro 2s okno rozmazané i rušení 50 Hza proč?");
disp("   Není, jelikož je stále a nemění se v segmentech => překrytí nehorší vlastnosti");
disp("3. Najdete rušení 50 Hz zpohledu magnitudy lépe ve spektrogramu vlineární škále nebo vdB?");
disp("   V dB");

%% fce
fs=1e3;
T=5; % délka signálu v s
t=linspace(0,T-1/fs,T*fs); % časová osa

y=0.05*randn(1,length(t));
y(2*fs:2.5*fs)=sin(2*pi*100*t(2*fs:2.5*fs));

figure(3);
subplot(4,3,[1 2 3]);
plot(t, y);
xlabel('time(s)'); ylabel('y[m]');

ww=0.2*fs; % velikost okna 200 ms
nn=round(0.5*ww); % přesah 50% 
zz=2*ww; % doplnění nulami (3x hustější spektrum (ww+zz)=3×ww spekt. čar)

[S,F,Ti] = my_spectogram(y,ww,nn,zz,fs);

subplot(434);
imagesc(Ti,F,S); axis xy;
c=colorbar; c.Label.String='Power';
xlabel('time(s)');ylabel('f(Hz)'); title('ww=0.2s | nn=50%');

subplot(437);
imagesc(Ti,F,10*log10(S)); axis xy;
c=colorbar; c.Label.String='dB';
xlabel('time(s)');ylabel('f(Hz)');

subplot(4,3,10);
spectrogram(y,ww,nn,zz,fs,'yaxis');
title('MATLAB');

ww=0.5*fs; % velikost okna 200 ms
nn=round(0.75*ww); % přesah 75% 
zz=2*ww; % doplnění nulami (3x hustější spektrum (ww+zz)=3×ww spekt. čar)

[S,F,Ti] = my_spectogram(y,ww,nn,zz,fs);

subplot(435);
imagesc(Ti,F,S); axis xy;
c=colorbar; c.Label.String='Power';
xlabel('time(s)');ylabel('f(Hz)'); title('ww=0.5s | nn=75%');

subplot(438);
imagesc(Ti,F,10*log10(S)); axis xy;
c=colorbar; c.Label.String='dB';
xlabel('time(s)');ylabel('f(Hz)');

subplot(4,3,11);
spectrogram(y,ww,nn,zz,fs,'yaxis');
title('MATLAB');

ww=2*fs; % velikost okna 200 ms
nn=round(0.5*ww); % přesah 50% 
zz=2*ww; % doplnění nulami (3x hustější spektrum (ww+zz)=3×ww spekt. čar)

[S,F,Ti] = my_spectogram(y,ww,nn,zz,fs);

subplot(436);
imagesc(Ti,F,S); axis xy;
c=colorbar; c.Label.String='Power';
xlabel('time(s)');ylabel('f(Hz)'); title('ww=2s | nn=50%');

subplot(439);
imagesc(Ti,F,10*log10(S)); axis xy;
c=colorbar; c.Label.String='dB';
xlabel('time(s)');ylabel('f(Hz)');

subplot(4,3,12);
spectrogram(y,ww,nn,zz,fs,'yaxis');
title('MATLAB')

disp("1. Pro jaké nastavení dokážete ve spektru najít začátek a konec zázněje?  ww=0.2s, nn=50%");
disp("2. Pro jaké nastavení dokážete určit nejpřesněji frekvenci zázněje?  ww=2s,  nn=50%");
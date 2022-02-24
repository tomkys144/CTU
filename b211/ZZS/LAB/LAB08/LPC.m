beep off
clear all
close all
clc

%% syntetický signál
fs=60;
T=1;
t=linspace(0,T-1/fs,round(T*fs));
x=sin(2*pi*3*t)+0.5*sin(2*pi*5*t)+0.2*sin(2*pi*14*t);

figure();
subplot(421);
stem(t,x,'.');
hold on
plot(t,x,'r');
xlabel('time [s]'); ylabel('y(t)'); title('Original f_s = 60 Hz');

subplot(422);
S=fft(x)/length(x);
F=linspace(0,fs,length(S));
stem(F,abs(S),'.');
xlabel('f [Hz]'); ylabel('|Y(f)|');

%% decimace

fsdec=20; % nová fs
D=fs/fsdec; % decimační faktor
 
% anti-aliasing filtr
f0=round(fsdec/2.5); % f0<fs/2
[b,a]=butter(5, f0/(fs/2)); % IIR DP
 
xf=filtfilt(b,a,x); % omezení spektra
xd=xf(1:D:end); % každý D-tý vzorek
td=t(1:D:end); % časový vektor
subplot(423);
stem(td,xd,'.');
hold on
plot(td,xd,'r');
xlabel('time [s]'); ylabel('y(t)'); title('f_s = 20 Hz');

subplot(424);
Sd=fft(xd)/length(xd);
Fd=linspace(0,fsdec,length(Sd));
stem(Fd,abs(Sd),'.');
xlabel('f [Hz]'); ylabel('|Y(f)|'); % zobrazte signál a spektrum

disp('Kam zmizela složka 14 Hz? Byla vyfiltrovana DP');
disp('Co se stane s 14 Hz složkou, pokud nepoužijete DP? prida slozku v 5Hz');

%% interpolace

fsint=180; % nová fs
I=fsint/fs; % interpolační faktor
 
xi=zeros(1,I*length(x)); % nová délka signálu
xi(1:I:end)=x; % impulzy z původního signálu (expandér)
ti=linspace(0,(length(xi)-1)/fsint,length(xi));

subplot(425);
stem(ti,xi,'.');
hold on
plot(ti,xi,'r');
xlabel('time [s]'); ylabel('y(t)'); title('added zeros');

subplot(426);
Si=fft(xi)/length(xi);
Fi=linspace(0,fsint,length(Si));
stem(Fi,abs(Si),'.');
xlabel('f [Hz]'); ylabel('|Y(f)|'); % zobrazte signál a spektrum

% navrhněte DAC filtr pomocí sinc()
% konvoluční maska = impulzní odezva
M=30;
f0=fs/2;
T=(M+1)/fsint; % sinc() pro novou fs
tsinc=linspace(-T/2,T/2,M+1);
% sinc()  
bdac=sin(2*f0*pi.*tsinc)./(2*f0*pi.*tsinc); 
bdac(ceil(end/2))=1;
bdac=bdac(:).*hamming(length(bdac)); 


% interpolovaný signál:
xii=filtfilt(bdac,1,xi); % koeficienty DAC a=? (FIR)
K=sqrt(sum((x.^2)/length(x))/sum((xii.^2)/length(xii)));
xii=K*xii; % korekce amplitudy (Parsevalova rovnost)

subplot(427);
stem(ti,xii,'.');
hold on
plot(ti,xii,'r');
xlabel('time [s]'); ylabel('y(t)'); title('f_s = 180 Hz');

subplot(428);
Sii=fft(xii)/length(xii);
Fii=linspace(0,fsint,length(Sii));
stem(Fii,abs(Sii),'.');
xlabel('f [Hz]'); ylabel('|Y(f)|'); % zobrazte signál a spektrum


%% ekg

ekg=load('ECG_fs500Hz_iso.txt');
fs=500;
f0=0.5; % mezní kmitočet isolinie

t=linspace(0, length(ekg)/fs - 1/fs, length(ekg));

figure();
subplot(521)
plot(t,ekg);
xlim([0 length(ekg)/fs - 1/fs]);
xlabel('t [s]'); ylabel('[mV]'); title('f_s = 500Hz');

subplot(522);
S=fft(ekg)/length(ekg);
F=linspace(0,fs,length(S));
plot(F,20*log10(abs(S)));
xlabel('f [Hz]'); ylabel('|Y(f)| [dB]');

% decimace
fsdec=10*f0; % volíme cca 10*f0 (5 Hz)
 
R=fs/fsdec; % R=100 -> dvojstupňová 10x10
dec=resample(ekg,50,fs); % 500->50
dec=resample(dec,fsdec,50); % 50->5
tdec=linspace(0,(length(dec)-1)/fsdec,length(dec));

subplot(523);
plot(tdec,dec);
xlim([0 (length(dec)-1)/fsdec]);
xlabel('t [s]'); ylabel('[mV]'); title('f_s = 5Hz');

subplot(524);
Sdec=fft(dec)/length(dec);
Fdec=linspace(0,fsdec,length(Sdec));
plot(Fdec,10*log10(abs(Sdec)));
xlabel('f [Hz]'); ylabel('|Y(f)| [dB]');

subplot(525)
% navrhněte DP pro isolinii f0=0.5 Hz
[b,a]=butter(5, f0/(fsdec/2));
iso=filtfilt(b,a,dec);
% zobrazte signál a spektrum v dB:
plot(tdec,iso);
xlim([0 (length(dec)-1)/fsdec]);
xlabel('t [s]'); ylabel('[mV]'); title('Low-pass f_0=0.5 f_s = 5Hz');

subplot(526);
Siso=fft(iso)/length(iso);
Fiso=linspace(0,fsdec,length(Siso));
plot(Fiso,10*log10(abs(Siso)));
xlabel('f [Hz]'); ylabel('|Y(f)| [dB]');

iso_int=resample(iso,50,fsdec);
iso_int=resample(iso_int,fs,50);

subplot(5, 2, [7 8])
plot(t,ekg); 
hold on
plot(t,iso_int,'r');
legend('ECG','isoline');
xlabel('t [s]'); ylabel('[mV]'); title('Low-pass f_0=0.5 f_s = 500Hz');

ekg_f=ekg-iso_int;
subplot(5, 2, [9 10])
plot(t,ekg_f);
xlabel('t [s]'); ylabel('[mV]'); title('ecg(t)-isoline(t) f_s = 500Hz');

%% vocal

[vocal,fs]=audioread('AEIOU.m4a'); 
vocal=mean(vocal,2); % stereo->mono

vocal=resample(vocal, 8820, fs); % decimujte celočíselně signál na fs»(2x4,5kHz), tj. např. z 44100 Hz na 8820Hz.
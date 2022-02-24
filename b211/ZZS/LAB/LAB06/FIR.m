beep off
close all
clear all
clc

%% DP

fs=1000; % fs
M=10; % řád filtru
f0=250; % mezní kmitočet filtru
 
T=(M+1)/fs; % doba trvání impulzní odezvy
t=linspace(-T/2,T/2,M+1); % symetricky kolem 0

W0=2*pi*f0; % normovaný kmitočet 0 (rad) 
b=sin(W0*t)./(W0*t); % sinc(W0*t)
b(M/2+1)=1; %(sin(0)/0)=NaN; v limitě sinc(0)=1;

A=fs/(2*f0);
b=b/A; % normalizace na jednotkovou intenzitu A-1sinc(W0*t)
fir_plot(b, fs, t);

b=b.*hamming(M+1)'; % impulzní odezva zaoblena Hammingovým oknem (odkomentujte a porovnejte absolutní přenos)

fir_plot(b, fs, t);

type=["Bez váhování oknem";"S váhováním oknem"];
f0_val=[250;248];
d=[21;55];
fz=[163;273];

tab=table(type,f0_val,d,fz);
tab.Properties.VariableNames=["M=10, f0=250 Hz","Mezní kmitočet |H(f0)|= -3 dB", "Útlum (1. lalok) |H(fz)| [dB]","Kmitočet zádržného pásma fz"];
disp(tab);

M=100;

T=(M+1)/fs; % doba trvání impulzní odezvy
t=linspace(-T/2,T/2,M+1); % symetricky kolem 0

W0=2*pi*f0; % normovaný kmitočet 0 (rad) 
b=sin(W0*t)./(W0*t); % sinc(W0*t)
b(M/2+1)=1; %(sin(0)/0)=NaN; v limitě sinc(0)=1;

A=fs/(2*f0);
b=b/A; % normalizace na jednotkovou intenzitu A-1sinc(W0*t)
fir_plot(b, fs, t);

b=b.*hamming(M+1)'; % impulzní odezva zaoblena Hammingovým oknem (odkomentujte a porovnejte absolutní přenos)

fir_plot(b, fs, t);

f0_val=[247;220];
d=[25;44];
fz=[367;500];

tab=table(type,f0_val,d,fz);
tab.Properties.VariableNames=["M=100, f0=250 Hz","Mezní kmitočet |H(f0)|= -3 dB", "Útlum (1. lalok) |H(fz)| [dB]","Kmitočet zádržného pásma fz"];
disp(tab);

%% PZ

fs=1000; % fs
M=100; % řád filtru zadáváme sudý, ale pro HP a PZ musí být lichý, proto v kódech je M+1
f1=200; % začátek stop pásma
f2=300; % konec stop pásma
T=(M+1)/fs;
t=linspace(-T/2,T/2,M+1); 
% DP ----------
w1=2*pi*f1;
b_dp=sin(w1*t)./(w1*t);
b_dp(M/2+1)=1; % limita sinc(0)=1 
b_dp=b_dp*(2*f1/fs); % normalizace 1/A
b_dp=b_dp.*hamming(M+1)'; % impulzní odezva DP
fir_plot(b_dp, fs, t);
% HP ----------
% Tj. rovnoměrné spektrum bez DP
% Rovnoměrné spektrum má jednotkový impulz
w2=2*pi*f2;
b_dp2=sin(w2*t)./(w2*t);
b_dp2(M/2+1)=1; % limita sinc(0)=1 
b_dp2=b_dp2*(2*f2/fs); % normalizace 1/A
b_dp2=b_dp2.*hamming(M+1)'; % impulzní odezva DP
fir_plot(b_dp2, fs, t);

d=zeros(1,M+1); d(M/2+1)=1; % jednotkový impulz

b_hp=d-b_dp2; % impulzní odezva HP: d(t)-sinc(w2t)
fir_plot(b_hp, fs, t);

% PZ = DP + HP ----------
b_pz=b_dp+b_hp;
b_pz=b_pz.*hamming(M+1)'; 

fir_plot(b_pz, fs, t);

%% filtrace ekg

ekg=load('ecg_50Hz_isoline_fs500.txt');
fs=500;
t=linspace(0,(length(ekg)-1)/fs,length(ekg));

figure();
subplot(321);
plot(t, ekg);
xlabel('time (s)'); ylabel('mV');

subplot(322);
pwelch(ekg,fs,fs/2,[],fs);

% hřebenový filtr
f0=50; % 1,3,5... x50 Hz
D=fs/(2*f0); % řád filtru, zpoždění
 
b=zeros(1,D+1); % impulzní odezva délky D+1

b([1 end])=0.5; % koeficienty impulzní odezvy 
 
ekg50=filter(b,1,ekg); % filtrace FIR, a=1
% kompenzace fázového zpoždění M/2
ekg50=ekg50(round(D/2):end); % ořez D/2
t50=t(1:end-round(D/2)+1); % zkrácení času

subplot(323);
plot(t50, ekg50);
xlabel('time (s)'); ylabel('mV');

subplot(324);
pwelch(ekg50,fs,fs/2,[],fs);

% horní propust
f0=0.5; % 0.5 Hz
W0=2*f0/fs; % normovaný kmitočet w
M=500; % řád filtru
b_hp = fir1(M,W0,'high'); % doc fir1
ekg50hp=filter(b_hp,1,ekg50);
ekg50hp=ekg50hp(round(M/2):end); % ořez D/2 vzorků signálu
t50hp=t50(1:end-round(M/2)+1); % zkrácení časové osy

subplot(325);
plot(t50hp, ekg50hp);
xlabel('time (s)'); ylabel('mV');

subplot(326);
pwelch(ekg50hp,fs,fs/2,[],fs);

figure();
freqz(b_hp,1,10*fs,fs)

fprintf('M=%.f\n', M);
fprintf('T=%.2f\n', (M/2)/fs);

%% Breathing
y=load('Breathing_fs500Hz.txt');
fs=500;
N=length(y);
t=linspace(0,(N-1)/fs,N);

figure();
subplot(511);
plot(t,y);
xlim([0 30]); ylim([-1 1]);
xlabel('time [s]'); ylabel('breathing sensor'); title('raw signal');

M=round(2*fs); % řád filtru ~ MA-okno 2s 
b=ones(1,M)/M; % impulzní odezva

yma=filter(b,1,y);
% kompenzace fázového zpoždění
yma=yma(round(M/2):end);
tma=t(1:end-round(M/2)+1);

subplot(512);
plot(tma,yma);
xlim([0 30]); ylim([-1 1]);
xlabel('time [s]'); ylabel('(-)'); title('MA-filtered');

% diferenciátor (rychlost nádechu/výdechu)
ymad=diff(yma); % diference b=[1 -1]
tmad=tma(1:end-1); % M/2=1

subplot(513);
plot(tmad,ymad);
xlim([0 30]); ylim([-1.5e-3 1.5e-3]);
xlabel('time [s]'); ylabel('(-)'); title('diff');

% polarita gradientu (+nádech, -výdech)
ymads=sign(ymad); % signum (-1,0,+1)
ymads(ymads==0)=1; % 0 jako +polarita

subplot(514);
plot(tmad,ymads);
xlim([0 30]); ylim([-1.1 1.1]);
xlabel('time [s]'); ylabel('(-)'); title('sign(diff): +1 inhale, -1 exhale');

ymadsd=diff(ymads);% změna nádech«výdech 
tmadsd=tmad(1:end-1);

subplot(515);
stem(tmadsd,ymadsd, '.');
xlim([0 30]); ylim([-2.1 2.1]);
xlabel('time [s]'); ylabel('(-)'); title('diff(sign(diff)) leading/falling edge');

N_nadech=sum(ymadsd==2);
N_vydech=sum(ymadsd==-2);

time=((N-1)/fs)/60;

Fmin_nadech=N_nadech/time;
Fmin_vydech=N_vydech/time;

Caps=["nádechů";"výdechů"];
N_viz=[20; 21];
N_det=[N_nadech; N_vydech];
Fmin=[Fmin_nadech; Fmin_vydech];

T=table(Caps, N_viz, N_det, Fmin);
T.Properties.VariableNames=[" ", "počet vizuálně", "počet detekovaný", "dechová frekvence/min"];
disp(T);
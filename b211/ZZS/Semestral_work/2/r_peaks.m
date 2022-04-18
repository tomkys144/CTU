beep off
clear all
close all
clc

%% data load

data=load('ECG_respiratory_fs500.txt');
fs=500;
ekg=data(:,1);
resp=data(:,2);

t=linspace(0,length(ekg)/fs, length(ekg));

figure('Name', 'Initial data', 'NumberTitle','off')
subplot(311)
plot(t,ekg)
xlabel('time [s]'); ylabel('[mV]'); title('ECG');

subplot(312)
plot(t,resp)
xlabel('time [s]'); ylabel('[-]'); title('Respiratory belt');

%% signal preprocessing
figure('Name', 'Filters', 'NumberTitle','off')
Wp=1.4/(fs/2);
Rp=0.3;
Ws=1/(fs/2);
Rs=60;
[n,Wp]=ellipord(Wp,Ws,Rp,Rs);
[bhp,ahp]=ellip(n,Rp,Rs,Wp,'high');
[H,f]=freqz(bhp,ahp,20*fs,fs);
subplot(311)
plot(f,20*log10(abs(H)));
xlabel('f [Hz]'); ylabel('|H(f)|')

Wp=45/(fs/2);
Rp=0.3;
Ws=45.4/(fs/2);
Rs=60;
[n,Wp]=ellipord(Wp,Ws,Rp,Rs);
[bdp,adp]=ellip(n,Rp,Rs,Wp,'low');
[H,f]=freqz(bdp,adp,20*fs,fs);
subplot(312)
plot(f,20*log10(abs(H)));
xlabel('f [Hz]'); ylabel('|H(f)|')

ekgf=filtfilt(bhp,ahp,ekg);
ekgf=filtfilt(bdp,adp,ekgf);
subplot(313)
plot(t, ekgf)
xlabel('time [s]'); ylabel('[mV]'); title('Filtered ECG');

%% Local max detection

figure('Name', 'Local max detection', 'NumberTitle','off')
subplot(611)
plot(t,ekg)
xlim([0 3])
xlabel('time [s]'); ylabel('[mV]'); title('ECG');

subplot(612)
plot(t, ekgf)
xlim([0 3])
xlabel('time [s]'); ylabel('[mV]'); title('ECG 1-45Hz');

subplot(613)
ekgd=diff(ekgf,2).^2;
ekgd(end+1:end+2)=0;
plot(t, ekgd)
xlim([0 3])
xlabel('time [s]'); ylabel('[mV]'); title('Fast components');

subplot(614)
N=0.1*fs;
b=ones(1,N)/N;
env=filtfilt(b,1,ekgd);
plot(t, env)
xlim([0 3])
xlabel('time [s]'); ylabel('[mV]'); title('Envelope');
hold on
trh=0.2*max(env);
yline(trh,'-r','Treshold');

subplot(615)
roi=env>trh;
plot(t, roi)
xlim([0 3]); ylim([-0.1 1.1])
xlabel('time [s]'); ylabel('[-]'); title('ROI');

subplot(616);

RT=[];
up=find(diff(roi)>0); % náběžná
dw=find(diff(roi)<0); % sestupná

for i=1:length(up)
    seg_start=up(i);
    seg_end=dw(i);
    seg=ekgf(up(i):dw(i));
    [~,p]=max(seg);
    RT(end+1)=(p+seg_start-1);
end

plot(t,ekgf);
hold on
plot(t(RT),ekgf(RT),'xm')
xlim([0 3])
xlabel('time [s]'); ylabel('[mV]'); title('ECG 1-45Hz');

%% heart rate

figure('Name', 'Heart rate', 'NumberTitle','off')
subplot(311)
plot(t,ekgf);
hold on
plot(t(RT),ekgf(RT),'xm')
xlabel('time [s]'); ylabel('[mV]'); title('ECG');

subplot(312)
RR=diff(RT);
T=RR/fs;
stairs(T)
xlim([0 t(end)])
xlabel('time [s]'); ylabel('[s]'); title('R-R interval');

subplot(313)
BPM=60./T;
stairs(BPM)
xlim([0 t(end)])
xlabel('time [s]'); ylabel('BPM'); title('Heart rate');

seg=BPM(round(length(BPM)/120*4):end);
BPM_max=max(seg);
BPM_min=min(seg);
BPM_res=length(RR)/(t(end)/60);

fprintf("Tepová frekvence za minutu: %.f\nMaximální:%.f\nMinimální:%.f\n",BPM_res,BPM_max,BPM_min)

%% resp. rate

figure()
subplot(211)
plot(t,resp);
xlabel('time [s]'); title('Respiratory belt')

subplot(212)
M=round(1*fs);
b=ones(1,M)/M;
respf=filtfilt(b,1,resp);
plot(t,respf)
xlabel('time [s]');title('MA filter')
hold on;

polarity=sign(diff(respf));
polarity(end+1)=polarity(end);
polarity(polarity==0)=1;
up=find(diff(polarity)<0);
dw=find(diff(polarity)>0);
plot(t(up),respf(up), 'xc')
hold on
plot(t(dw),respf(dw),'xr')
legend('Respiratory','start of expirum','start of inspirum')

RPM_in=length(dw)/(t(end)/60);
RPM_out=length(up)/(t(end)/60);
fprintf('Počet nádechů za minutu:%.f\nPočet výdechů za minutu:%.1f\n', RPM_in,RPM_out);

%% RR int

figure()
subplot(411)
t_rr=linspace(0,t(end),length(T));
plot(t_rr,T)
xlim([30 60])
xlabel('time [s]');ylabel('[s]');title('R-R interval')

subplot(412)
b=ones(1,3)/3;
Tf=filtfilt(b,1,T);
plot(t_rr,Tf)
xlim([30 60])
xlabel('time [s]');ylabel('[s]');title('MA-filter (M=3)')

subplot(413)
Tdiff=diff(Tf);
Tdiff(end+1)=Tdiff(end);
plot(t_rr,Tdiff)
xlim([30 60])
xlabel('time [s]');ylabel('[s]');title('\DeltaR-R')

subplot(414)
Tsig=sign(Tdiff);
Tsig(Tsig==0)=1;
Tsd=diff(Tsig);
Tsd(end+1)=Tsd(end);
plot(t_rr,Tsig);
hold on;
stem(t_rr, Tsd, '.black');
xlim([30 60])
xlabel('time [s]');title('signum(\DeltaR-R)');
RPM_in=length(find(Tsd>0))/2;
RPM_out=length(find(Tsd<0))/2;
fprintf('Počet nádechů za minutu:%.f\nPočet výdechů za minutu:%.f\n', RPM_in,RPM_out);

%% Conclusion

disp('Srdeční rytmus kolísá s nádechem/výdechem. Konkrétně lze pozorovat zvýšení rztmu při nádechu a snížení při výdechu.')
disp('Samotná detekce nádechů z EKG je celkem přesná. Pro orientační monitorování zcela použitelná. Pro přesné hodnoty je samozřejmě lepší detekce přímo nádechů a výdechů...')
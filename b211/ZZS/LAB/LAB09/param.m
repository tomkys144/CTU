beep off
clear all
close all
clc

%%

load('FORCE_EMG_3xR_03.mat', 'emg','force','fs');

t=linspace(0, length(emg)/fs, length(emg));

figure()
subplot(411)
plot(t,emg);
xlabel('time [s]');ylabel('[mV]'), title('EMG');

subplot(412)
plot(t,force);
xlabel('time [s]');ylabel('[N]'), title('force');

e=abs(emg).^2;
N=0.1*fs;
bma=ones(1,N)/N;
env=filtfilt(bma,1,e);

subplot(413)
plot(t,env);
xlabel('time [s]');ylabel('[mV^2]'), title('energetic envelope');

% Prahujte obálku např. 5 % z maxima;
th=0.05*max(env);
roi=env>th;

subplot(414)
plot(t, roi);
ylim([-0.1 1.1]);
xlabel('time [s]');ylabel('[-]'), title('ROI');

up=find(diff([0;roi])>0); % indexy náběžné hrany
dw=find(diff([roi;0])<0); % indexy sestupné hrany

for i=1:length(up)
    seg=emg(up(i):dw(i)); % segment EMG
    T=(dw(i)-up(i))/fs; % délka segmentu v (s)
    
    [SD(i),Fzrc(i), Fmed(i), M1(i)] = ekg_param_fce(seg,T,fs);
    
    Force(i)=max(force(up(i):dw(i)));

end

disp(['FORCE: ' num2str(round(Force)) ' [N]'])
disp(['S.D:   ' num2str(round(SD*1000)) ' [uV]'])
disp(['ZRCf:  ' num2str(round(Fzrc)) ' [Hz]'])
disp(['MEDf:  ' num2str(round(Fmed)) ' [Hz]'])
disp(['M1:    ' num2str(round(M1)) ' [Hz]'])

disp('čím vyšší frekvence tím větší síla kontrakce');

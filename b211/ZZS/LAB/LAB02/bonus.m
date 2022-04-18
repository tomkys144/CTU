close all;
clear all;
clc;

load('ECG_01_fs1k.mat');


figure('Name', 'ECG II', 'NumberTitle', 'off', 'Position', [0 0 1920 1080]);
subplot(211)
plot(ekg);
xlim([0 2.5e4]);
xlabel('n (-)'); ylabel('(mV)'); title('ECG II.')

hold on
plot(Rm,max(ekg)*ones(length(Rm),1),'.r');
plot(Te,max(ekg)*ones(length(Te),1),'.c');

legend('ECG','I.','II.')

tn=linspace(0,0.1-1/fs,fs*0.1)';
Isin=sin(2*pi*300*tn);
IIsin=sin(2*pi*200*tn);

sono=zeros(size(ekg));

for i=1:length(Rm)
    sono(Rm(i):(Rm(i)+fs*0.1-1))=Isin;
end

for i=1:length(Te)
    sono(Te(i):(Te(i)+fs*0.1-1))=IIsin;
end

subplot(212)
plot(sono)
xlim([0, length(ekg)]);
xlabel('n (-)'); ylabel('sound'); title('sonification')

HR = round(length(Rm)/(length(ekg)/fs)*60);

fprintf('HR = %.f', HR);

sound(sono, fs)
clear; clc; close all

s=loadbin('SA001S04.CS0');
fs=16000;

wlen=0.032*fs;
wstep=0.016*fs;
nover=wlen-wstep;

figure(1)
subplot(211)
plot(s); axis tight
subplot(212)
spectrogram(s, wlen, nover, [], fs, 'yaxis');

cp=12;
cr=vrceps(s, 1, cp, wlen, wstep); % tady je to wstep jako krok, nepsat překryv!

figure(2)
plot(cr); axis tight

p = 16;
ca=vaceps(s, 1, p, cp, wlen, wstep);

figure(3)
plot(ca(:,2:5)); axis tight

b=fir1(30,0.8,'low');
% b=fir1(30,0.1,'high');
s2=filter(b,1,s);

cr2=vrceps(s2, 1, cp, wlen, wstep);
ca2=vaceps(s2, 1, p, cp, wlen, wstep);

figure(4)
plot(cr2); axis tight

figure(5)
plot(ca2); axis tight

cdist=cde(cr,cr2);

figure(6)
subplot(311)
spectrogram(s, wlen, nover,[], fs, 'yaxis'); colorbar off
subplot(312)
spectrogram(s2, wlen, nover,[], fs, 'yaxis'); colorbar off
subplot(313)
plot(cdist); axis tight
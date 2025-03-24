fs = 100e6;
fc = 7.5e6; % TODO central frequency
bw = 0.5; % TODO fractional bandwidth
bwr = -6; % TODO fractional bandwidth reference level
tpe = 40; %  TODO drop in trailing pulse envelope for cutoff time estimation

tc = gauspuls('cutoff',fc,bw,bwr,tpe);
t = - tc:1/fs:tc;
y = gauspuls(t,fc,bw);

figure()
subplot(2,1,1)
plot(t,y)
title({'Impulse response of an piezoelectric element','in time domain (top) and in frequency domain (bottom)'})
xlabel('t [s]')
axis tight
subplot(2,1,2)
f = linspace(-fs/2,fs/2,512);
plot(f,fftshift(abs(fft([y zeros(1,512 - length(y))]))))
xlabel('f [Hz]')

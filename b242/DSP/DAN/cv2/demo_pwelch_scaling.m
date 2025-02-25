% B2B31CZS / B2M31DSP - Scaling of PSD estimate

fs=200;
tmax=20 ;

f1=14;
A1=0.5 ;

f2=27.5 ;
A2=0.2 ;


tt=0:1/fs:tmax-1/fs ;
s1=A1*sin(2*pi*f1*tt)+A2*sin(2*pi*f2*tt) ;

b1=randn(1,tmax*fs);

SNR=-3;
Ps1=mean(s1.*s1);
Pb1=mean(b1.*b1);
k=sqrt(Ps1/Pb1*exp(-SNR/10));
x1=s1+k*b1;

wlen=256 ;

wn=hamming(wlen);
Pwn=mean(wn.^2);

figure(1)
pwelch(x1,wn,[],[],fs)

figure(2)
pwelch(x1(1:wlen),wn,[],[],fs)


Gx1=abs(fft(x1(1:wlen).*wn')).^2/wlen/fs/Pwn ;
ff=(0:wlen-1)./wlen.*fs ;

[psd1,fff]=pwelch(x1,wn,[],[],fs,'twoside','power');
[psd2,fff]=pwelch(x1(1:wlen),wn,[],[],fs,'twoside','power');

figure(3)
plot(ff,10*log10(Gx1),'b')
hold on
plot(fff,10*log10(psd2),'g--')
plot(fff,10*log10(psd1),'r')
hold off
title('Two-side PSD estimation using pwelch() with ''power'' option')
legend('DFT one-frame Gx','pwelch one-frame','pwelch smoothed')

[psd1oneside,ffone]=pwelch(x1,wn,[],[],fs);
[psd2oneside,ffone]=pwelch(x1(1:wlen),wn,[],[],fs);

figure(4)
plot(ff,10*log10(Gx1),'b')
hold on
plot(ffone,10*log10(psd2oneside),'g')
plot(ffone,10*log10(psd1oneside),'r')
hold off
title('One-side PSD estimation using pwelch() with ''power'' option')
legend('DFT one-frame Gx','pwelch one-frame','pwelch smoothed')

figure(5)
plot(fff,10*log10(psd1),'b')
hold on
plot(ffone,10*log10(psd1oneside),'r')
hold off
legend('pwelch two-side PSD','pwelch one-side PSD')
title('One-side spectrum is 3 dB above two-side spectrum')

%% PWELCH with 'psd' option

wn=rectwin(wlen);
wn=hamming(wlen);

Gx1_2=abs(fft(x1(1:wlen).*wn')).^2./wlen./Pwn ;
ff=(0:wlen-1)./wlen.*fs ;

figure(6)
plot(ff,10*log10(Gx1_2),'b');

% [psd1,fff]=pwelch(x1,wn,[],[],fs,'twoside');
[psd2_2,fff]=pwelch(x1(1:wlen),wn,[],[],[],'psd','twoside');
[psd2_1,fff]=pwelch(x1,wn,[],[],[],'psd','twoside');

hold on

plot(ff,10*log10(psd2_2),'g--');
plot(ff,10*log10(psd2_1),'r');

hold off
title('Two-side PSD estimation using pwelch() with ''psd'' option')
legend('Equivalent power spectrum (periodogram) computed by fft()','pwelch two-side PSD with ''psd'' option without smoothing','pwelch two-side PSD with ''psd'' SMOOTHED')

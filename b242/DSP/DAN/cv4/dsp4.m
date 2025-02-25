%% sim1
close all; clc; clear all
sig1 = loadbin("SA001S01.CS0");
sig1 = sig1(:);
wlen = 2000;
xmin = 31577;
xmin2 = 70565;
xmax2 = xmin2 + wlen;
xmax = xmin + wlen;
fs = 16000;
wlen2 = 512;
Noverlap = 3*wlen2/4;

%delay filter
M = 20;
b = [zeros(1,M) 1];

%delayed signal
sig2 = filter(b,1,sig1);
x = sig1(:);
y = sig2(:);
%CCF of sig1 and sig2
%MSC12 = mscohere(sig1,sig2,512,[],512,fs);

[P12, ff] = cpsd(sig1(xmin:xmax),sig2(xmin:xmax),[],[],[],fs);

figure(1)
subplot(211)
plot([sig1 sig2])
xlim([xmin xmax])
title('simulation ideal delay')


figure(2)
subplot(211)
mscohere(sig1(xmin:xmax),sig2(xmin:xmax),wlen2,Noverlap,[],fs);
title('MSC of sig1 and sig2')
subplot(212)
mscohere(sig1(xmin2:xmax2),sig2(xmin2:xmax2),wlen2,Noverlap,[],fs);
title("MSC of sig1 and sig2 unsounded voice")

msc1 = mscohere(sig1(xmin:xmax),sig2(xmin:xmax),wlen2,Noverlap,[],fs);
mean1 = mean(msc1)
figure(3)
subplot(211)
plot(ff,20*log10(abs(P12)))
title('magnitude CPSD of sig1 and sig2')
subplot(212)
plot(ff, unwrap(angle(P12)))
title('phase CPSD of sig1 and sig2')

msc2 = mscohere(sig1(xmin2:xmax2),sig2(xmin2:xmax2),wlen2,Noverlap,[],fs);
mean2 = mean(msc2)
%% sim2
%řád filtru
M1 = 30;
%mezní frekvence normovaná k fs/2
Wc = 0.05;
%návrh FIR filtru
b = fir1(M1,Wc,'high');
%bílý šum
n1 = randn(wlen,1);
n2 = randn(wlen,1);
%normovací konstanta 
K = 0.01;
n1 = n1.*K;
n2 = n2.*K;
%zpoždění filtrací
%sig2 = filter(b,1,sig1);
%přidávám šum
sig1_2 = sig1(xmin:xmax -1) + n1;
sig2_2 = sig2(xmin:xmax -1) + n2;
sig1_3 = sig1(xmin2:xmax2 -1) + n1;
sig2_3 = sig2(xmin2:xmax2 -1) + n2;

[P12, ff] = cpsd(sig1_2,sig2_2,[],[],[],fs);

figure(4)
subplot(211)
plot(ff,20*log10(abs(P12)))
title('magnitude CPSD of sig1 and sig2_2 with noise')
subplot(212)
plot(ff, unwrap(angle(P12)))
title('phase CPSD of sig1 and sig2_2 with noise')

figure(5)
subplot(211)
mscohere(sig1_2,sig2_2,wlen2, Noverlap,[],fs);
title('MSC of sig1 and sig with noise')
subplot(212)
mscohere(sig1_3,sig2_3,wlen2,Noverlap,[],fs);
title('MSC of sig1 and sig unsounded frame with noise')

%% cohergram
slen = length(sig1);
wlen=2048 ;
wstep=3*wlen/4 ;
wlen2 = wlen/4;
nover2 = wlen2/2;
%NFFT=wstep;

wnum=floor((slen-wlen)/wstep+1 );

MSCmtx=[];
tv=zeros(wnum,1);

% Main cycle
for i=1:wnum

  % short-time frame selection
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame1=x(ii:jj);
  frame2=y(ii:jj);
  
  [MSC, F] = mscohere(frame1,frame2,wlen2,nover2,[],fs);
  
  % Addition short-time spectrum to the output matrix
  MSCmtx = [MSCmtx MSC] ;
  tv(i) = ii/fs;

end

figure(10)
pcolor(tv,F,MSCmtx)
shading flat


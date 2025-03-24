% EXAMPLE of signal semgentation 
% - spectrogram and Welch-based PSD estimation

if exist('/home/pollak/'),
    % For linux
    addpath /home/pollak/vyuka/DSP/m-files;
    addpath /home/pollak/vyuka/DSP/signaly;
elseif exist('K:\VYUKA\DSP')
    addpath K:\VYUKA\DSP\m; 
    addpath K:\VYUKA\DSP\signaly; 
elseif exist('C:\usr\pollak\vyuka\DSP')
    addpath C:\usr\pollak\vyuka\DSP\m-files;
    addpath C:\usr\pollak\vyuka\DSP\signaly;
end


% Loading of long signal
sig=loadbin('SA001S01.CS0');  fs=16000 ;
sig=sig(:);
slen=length(sig);


% Computation of short-time frame amount for given parameters of segmentation
wlen=512 ;
wstep=wlen/2 ;
NFFT=wstep;

wnum=floor((slen-wlen)/wstep+1 );

% Hamming window for weighting
w=hamming(wlen);

% For real signals just half of the spectrum is computed
if isreal(sig) 
    kmax=NFFT/2+1;
else
    kmax=NFFT;
end

% creation of empty output matrices
Gsig=[];
tv=zeros(wnum,1);

% Main cycle
for i=1:wnum,

  % short-time frame selection
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame=sig(ii:jj).*w;
  
  % Short-time power spectrum computation
  S=fft(frame,NFFT);
  Gs=abs(S(1:kmax)).^2./NFFT;
  
  % Addition short-time spectrum to the output matrix
  Gsig = [Gsig Gs] ;
  tv(i) = ii/fs;

end;

% PSD estimation (averaging)
Ssig=mean(Gsig,2) ;


% Drawing of signal and spectrogram (spectrum in dBs)
figure(1); clf ;

subplot(211);
tt=(0:slen-1)./fs;
plot(tt,sig);
xlim([0 max(tt)])

title('Analyzed signal');
xlabel('t [s]')
ylabel('s(t)')

fv=(0:kmax-1)./NFFT*fs;

subplot(212);
pcolor(tv,fv,10*log10(Gsig)) ;
shading flat
title('Signal spectrogram (short-time analysis)');
xlabel('t [s]')
ylabel('f [Hz]')


figure(2); clf ;


plot(fv,10*log10(Ssig));
grid;
title('PSD (long-time analysis)');
xlabel('f [Hz]');
ylabel('Ss_{dB}')



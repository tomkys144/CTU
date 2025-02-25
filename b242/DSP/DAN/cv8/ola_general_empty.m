% EXAMPLE OF OLA-GENERAL IMPLEMENTATION 
%  (without any modification)
close all;
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


% Loading of clean signal
%%%%%%%%%%%%%%%%%%%%%%%%%
load sink.mat; fs = 16000;
clean=sum(sink(1:3,:));
% clean=loadbin('vm0.bin');  fs=16000 ;
n = loadbin('nc2.bin');
K = 0.3;
n = K*n;

clean=clean(:);

% sig=clean;
SNR = 10*log10(mean(clean.^2)/mean(n(1:length(clean)).^2));

sig = clean + n(1:length(clean)); % zašumělý signál
% Computation of short-time frame amount (50% overlap)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
slen=length(sig);
wlen=512 ;
wstep=wlen/2 ;
wnum=(slen-wlen)/wstep+1 ;

w=hamming(wlen);
% w=hanning(wlen);
% w=blackman(wlen);

% Vykresleni vstupniho signalu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf ;
subplot(211);
plot(sig);
title('Input signal');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zero-initialization of output signal
out = zeros(slen,1);

% Main cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:wnum

  % short-time frame selection
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame=sig(ii:jj).*w;
  
  % No modification
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  yframe = frame ;
  
    X=fft(frame);

    Y=X;

    yframe=ifft(Y);

  % Addition to output signal (implementation of OLA with general window)
  out(ii:jj)=out(ii:jj)+yframe ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalization of output signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% škálování aby nebyl jinak velký výstup
% scale2 = sum ( w(1:wstep:wlen) ) ;
% out = out ./ scale2 ;

subplot(212);
plot(out) ;
title('Output signal');



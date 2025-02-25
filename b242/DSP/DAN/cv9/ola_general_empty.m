% EXAMPLE OF OLA-GENERAL IMPLEMENTATION 
%  (without any modification)

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

k = 0.1;
fs=16000 ;

noise=loadbin('nc1.bin') .* k;
clean = loadbin('SA001S01.CS0');
clean = clean(:);

noise = noise(1:length(clean));

SNR = 10 * log10(mean(clean.^2) / mean(noise.^2));

sig=clean + noise;

% Computation of short-time frame amount (50% overlap)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
slen=length(sig);
wlen=512 ;
wstep=wlen/2 ;
wnum=(slen-wlen)/wstep+1 ;

w=hamming(wlen);

% Vykresleni vstupniho signalu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf ;
subplot(211);
plot(sig);
title('Input signal');


% Vypocet vykonovych spekter sumu

Gnmtx = [];

for i=1:30,

  % short-time frame selection
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame=sig(ii:jj).*w;
  
  N = fft(frame);
  Gn = (abs(N).^2)./wlen;
  
  Gnmtx = [Gnmtx, Gn];

end;

Sn = mean(Gnmtx, 2);




% figure(2);
%subplot(211);
%plot(Ss);
% subplot(212);
% plot(Sn);




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
  S = fft(frame);
  Gs = (abs(S).^2)./wlen;
  H = max(Gs - Sn, 0) ./ Gs;

  yframe = ifft(S .* H) ;
  
  % Addition to output signal (implementation of OLA with general window)
  out(ii:jj)=out(ii:jj)+yframe ;

end

%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalization of output signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scale2 = sum ( w(1:wstep:wlen) ) ;
out = out ./ scale2 ;

SNR2 = 10 * log10(mean(clean(500:3500).^2) / mean((out(500:3500) - clean(500:3500)).^2));

figure(1)
subplot(212);
plot(out) ;
title('Output signal');



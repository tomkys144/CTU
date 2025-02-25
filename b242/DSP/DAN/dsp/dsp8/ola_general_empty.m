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
%clean=loadbin('vm0.bin');  fs=16000 ;
%sinusovky
sinusovky = load("sink.mat");
sinusovky = sinusovky.sink;
sin1 = sinusovky(1, :);
sin2 = sinusovky(2, :);
sin3 = sinusovky(3, :);
clean = sin1 + sin2 + sin3;
clean=clean(:);

%šum k sinusovkám
slen = length(clean);
un = loadbin("nc2.bin");
un = un(1:slen);
un = un(:);
k = 0.3;
un = un.*k;
%výkon signálu a šumu
Gsig = mean(clean.^2);
Gun = mean(un.^2);
%SNR
SNR1 = 10*log10(Gsig/Gun);
sig=clean + un;

% Computation of short-time frame amount (50% overlap)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%Výpočet výkonových spekter (manuální welch)
Gsmtx = [];
Gnmtx = [];
for i=1:wnum,

  % short-time frame selection
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;
  
  %výkonová spektra segmentů
  %signál
  S=fft(clean(ii:jj).*w);
  Gs=abs(S.^2)./wlen;
  %šum
  N = fft(un(ii:jj).*w);
  Gn = abs(N.^2)./wlen;
  
  
  % uložení segmentů do matice
  Gsmtx = [Gsmtx, Gs];
  Gnmtx = [Gnmtx, Gn];

end;

%spektrální výkonové hustoty signálu a šumu
Ss = mean(Gsmtx,2);
Sn = mean(Gnmtx,2);
%přenosová funkce wienerova filtru
H = sqrt(Ss./(Ss + Sn));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zero-initialization of output signal
out = zeros(slen,1);
% Main cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:wnum,

  % short-time frame selection
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame=sig(ii:jj).*w;
  Sframe = fft(frame);
  %filtration
  Sframe = Sframe.*H;
  
  % No modification
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  yframe = ifft(Sframe) ;
  
  % Addition to output signal (implementation of OLA with general window)
  out(ii:jj)=out(ii:jj)+yframe ;

end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalization of output signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scale2 = sum ( w(1:wstep:wlen) ) ;
out = out ./ scale2 ;


nr = out(291:3635) - clean(291:3635);
Ssig1 = mean(clean(291:3635).^2);
Snr1 = mean(nr.^2);
SNR2 = 10*log10(Ssig1/Snr1);

subplot(212);
plot(out) ;
title('Output signal');

figure(2)
subplot(211)
plot(Ss)
title("výkonové spektrum signálu")
subplot(212)
plot(Sn)
title("výkonové spektrum šumu")


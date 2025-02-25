%potlačování šumu ve stacionárním signálu
%filtrace ve frekvenční oblasti
% OLA s obecným oknem -> segmentace s překryvem ->
%    xi[n] -> DFT -> Xi[k] -> Wienerův filtr ->Yi[k] -> IDFT -> yi[n] ->
% -> sčítání překryvů
%
% Wienerův filtr H[k] = sqrt(Ss[k]/Sx[k]) - výkonová spektra Ss - výkonový
% spektrum čistého signálu, Sx - výkonové spektrum signálu se šumem
% x[n] = s[n] + u[n]


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
SNR = 10*log10(sum(clean.^2)/sum(n(1:length(clean)).^2));

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

Gs=[]; % matice pro spektra čistého signálu
Gu=[]; % matice pro spektra samotného šumu

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
  sframe = clean(ii:jj).*w;
  uframe = n(ii:jj).*w;
    S=fft(sframe);
    U=fft(uframe);

    Gs=[Gs (abs(S).^2)./wlen];
    Gu=[Gu (abs(U).^2)./wlen];
    
    Ss=mean(Gs,2);
    Su=mean(Gu,2);

    H=Ss./(Ss+Su);

    X=fft(frame);

    Y=X.*H;

    yframe=ifft(Y);
    out(ii:jj)=out(ii:jj)+yframe ;
end
clean2=clean(300:3700);
out2=out(300:3700);


SNRout = 10*log10(mean((clean2).^2)/mean((out2-clean2).^2));
SNRE = SNRout-SNR;
subplot(212);
plot(out) ;
title('Output signal');

% plot(Su+Ss)
% přenosová funkce H
figure;
plot(H);

% logaritmické něco
% figure;
% plot();
%%
% spektrální odečítání
% Compute the magnitude spectrum of the noisy signal
mixMagnitude = abs(mixFFT);

% Compute the magnitude spectrum of the noise
noiseMagnitude = abs(noiseFFT);

% Subtract the magnitude spectrum of the noise from the magnitude spectrum of the noisy signal
cleanMagnitude = mixMagnitude - noiseMagnitude;

% Two-way rectifying
cleanMagnitude(cleanMagnitude < 0) = 0;

% Reconstruct the clean signal spectrum
cleanFFT = cleanMagnitude .* exp(1i * angle(mixFFT)); % Use phase of the mixed signal

% Inverse FFT to obtain the clean signal in time domain
cleanSignal = ifft(cleanFFT);

% Plot the clean signal spectrum
figure;
plot(abs(cleanFFT));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Clean Signal Spectrum');
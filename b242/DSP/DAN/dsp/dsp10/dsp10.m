%póly zkreslujícího filtru filtru
poles = [0.98*exp(j*11*pi/12) 0.98*exp(-j*11*pi/12)];

%výpočet jmenovatele filtru
a = poly(poles);
b = 1;

%vstupní signál
sig = loadbin('SA001S01.CS0');

%parametry signálu
fs = 16000;
wlen = 512;
slen = length(sig);

%zkreslený signál
sig2 = filter(b,a,sig);

%výpočet výkonu vstupních signálů
P_orig = mean(sig.^2);
P_zkresl = mean(sig2.^2);

%frekvenční charakteristika zkreslujícího filtru
H = freqz(b,a,wlen,"whole");

figure(1)
    freqz(b, a, wlen, "whole")
    title('frekvenční charakteristika zkreslujícího filtru')

figure(2)
    subplot(211)
        plot(sig)
        title('signál')
    subplot(212)
        plot(sig2)
        title('zkreslený signál')

figure(3)
    subplot(211)
        spectrogram(sig, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu')
        colorbar off
        colormap jet
    subplot(212)
        spectrogram(sig2, wlen, [], [], fs, 'yaxis');
        title('spektrogram zkresleného signálu')
        colorbar off
        colormap jet

%inverzní filtrace
sig3 = filter(a,b,sig2);

figure(4)
    subplot(211)
        plot(sig)
        title('signál')
    subplot(212)
        plot(sig3)
        title('signál po inverzní filtraci')

figure(5)
    subplot(211)
        spectrogram(sig, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu')
        colorbar off
        colormap jet
    subplot(212)
        spectrogram(sig3, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu po inverzní filtraci')
        colorbar off
        colormap jet

%generování šumu

scale = 0.002;
chnoise=scale*randn(slen,1);
%přidávam šum k signálu
sig2 = sig2 + chnoise;
%výkon šumu
P_noise = mean(chnoise.^2);
%SNR na vstupu inverzního filtru
SNR_zkresl = 10*log10(P_zkresl/P_noise);

%inverzní filtrace signálu se šumem -> šumová katastrofa
sig4 = filter(a,b,sig2);

figure(6)
    subplot(211)
        plot(sig)
        title('signál')
    subplot(212)
        plot(sig4)
        title('signál po inverzní filtraci se šumem v kanálu')

figure(7)
    subplot(211)
        spectrogram(sig, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu')
        colorbar off
        colormap jet
    subplot(212)
        spectrogram(sig4, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu po inverzní filtraci se šumem v kanálu')
        colorbar off
        colormap jet

%parametry pro inverzní filtraci ve frekvenční oblasti
wstep=wlen/2 ;
wnum=(slen-wlen)/wstep+1 ;
w=hamming(wlen);

out = zeros(slen,1);

% inverzní filtrace ve frekvenční oblasti bez kompenzace šumu -> šumová
% katastrofa
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:wnum,

  % short-time frame selection
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;
  frame=sig2(ii:jj).*w;

  Sframe = fft(frame);

  %filtration
  Sframe = Sframe./H;
  yframe = ifft(Sframe) ;
  
  % Addition to output signal (implementation of OLA with general window)
  out(ii:jj)=out(ii:jj)+yframe ;

end;

figure(8)
    subplot(211)
        plot(sig)
        title('signál')
    subplot(212)
        plot(out)
        title('signál po inverzní filtraci ve frekv. oblasti se šumem v kanálu')

figure(9)
    subplot(211)
        spectrogram(sig, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu')
        colorbar off
        colormap jet
    subplot(212)
        spectrogram(out, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu po inverzní filtraci ve frekv. oblasti se šumem v kanálu')
        colorbar off
        colormap jet

% inverzní filtrace ve frekvenční oblasti s potlačením šumu
out2 = zeros(slen,1);

%odhad výkonu šumu - welch
Gnmtx = [];
for i=1:wnum,

  % short-time frame selection
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;
  frame=chnoise(ii:jj).*w;
  
  %výpočet výkonového spektra segmentu
  N = fft(frame);
  Gn = (abs(N).^2)./wlen;
  
  %matice výkonových spekter segmentů
  Gnmtx = [Gnmtx, Gn];

end;
%odhad spektrální výkonové hustoty šumu - průměrování segmentů
Sn = mean(Gnmtx, 2);

%inverzní filtrace ve frekvenční oblasti s použitím wienerova filtru
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:wnum,

  % short-time frame selection
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame=sig2(ii:jj).*w;
  Sframe = fft(frame);
  Gs = (abs(Sframe).^2)./wlen;
  %filtration
  
  Hinv = (1./H).*((abs(H).^2)./(abs(H).^2 + (Sn./max(Gs - Sn, 0))));
  Sframe = Sframe.*Hinv;
  % No modification
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  yframe = ifft(Sframe) ;

  
  % Addition to output signal (implementation of OLA with general window)
  out2(ii:jj)=out2(ii:jj)+yframe ;

end;

%output scaling
scale2 = sum ( w(1:wstep:wlen) ) ;
out2 = out2 ./ scale2 ;
%residual noise
nr = out2 - sig;
P_nr = mean(nr.^2);
%output SNR
SNR_invWF = 10*log10(P_orig/P_nr);

figure(10)
    subplot(211)
        plot(sig)
        title('signál')
    subplot(212)
        plot(out2)
        title('signál po inverzní filtraci ve frekv. oblasti se šumem v kanálu, potlačení šumu')

figure(11)
    subplot(211)
        spectrogram(sig, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu')
        colorbar off
        colormap jet
    subplot(212)
        spectrogram(out2, wlen, [], [], fs, 'yaxis');
        title('spektrogram signálu inverzní filtrace ve frekv. oblasti se šumem v kanálu, WF')
        colorbar off
        colormap jet

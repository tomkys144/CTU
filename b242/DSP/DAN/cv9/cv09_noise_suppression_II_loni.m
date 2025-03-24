% Various methods of noise suppresion

% Setup of directory with signals for different OS
% if exist('/home/pollak'),  % it is the Linux OS
%     linux=1;
%     windows=0;
%     addpath /home/pollak/www/html/vyu/b2m31dsp/m
%     addpath /home/pollak/www/html/vyu/b2m31dsp/signaly
% elseif exist('K:\VYUKA\DSP'),
%     linux=0;
%     windows=1;
%     addpath K:\VYUKA\DSP\m
%     addpath K:\VYUKA\DSP\signaly
% elseif exist('C:\usr\pollak')
%     linux=0;
%     windows=1;
%     addpath C:\usr\pollak\www\html\vyu\b2m31dsp\m
%     addpath C:\usr\pollak\www\html\vyu\b2m31dsp\signaly
% else
%     error('ERROR: Predefined directories are not available. It must be changed within the script!')
% end

snrest=0;
% snrest=1;

% Loading of clean signal
% clean=loadbin('vm0.bin');  fs=16000 ;
clean=loadbin('SA001S01.CS0');   fs=16000 ; speechpart=1.8e4:8e4 ;


clean=clean(:);
slen=length(clean);

% noi=loadbin('nc1.bin');
noi=loadbin('nc2.bin');
% noi=loadbin('nc3.bin');

% Addition of noise

scale=0.1;
noi=scale*noi(:);

sig=clean+noi(1:slen);


% Loading of noisy speech
% sig=loadbin('SA110992_auto1.CS0');  fs=16000 ;  snrest=1;
% sig=loadbin('SA107S06_auto2.CS0');  fs=16000 ;  snrest=1;
% sig=loadbin('ma034014_auto3.ils');  fs=16000 ;  snrest=1'


% Vypocet poctu oken

slen=length(sig);
wlen=512 ;
wstep=wlen/2 ;
wnum=(slen-wlen)/wstep+1 ;

w=hamming(wlen);
% w=rectwin(wlen);
% w=hanning(wlen);
% w=blackman(wlen);



% Estimation of magnitude spectrum of noise (for SS)
% Estimation of PSD of noise (for WF)
%   z prvniho casti signalu bez reci
%   (prvnich 30 segmentu, nebo wnum pro kratsi signaly)
winit =min([wnum 30]) ;
Nabs=[] ;
Nabs2=[] ;
Sabs2=[] ;
Ndct=[];
Sdct=[];
for i=1:winit
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;
  nframe=noi(ii:jj).*w;
  N=fft(nframe);
  Nabs = [Nabs abs(N)] ;
  Nabs2 = [Nabs2 (abs(N).^2)./wlen] ;
  Ndct = [Ndct dct(nframe)];
  
  sframe=clean(ii:jj).*w;
  S=fft(sframe);
  Sabs2 = [Sabs2 (abs(S).^2)./wlen] ;
  Sdct = [Sdct dct(sframe)];
end

% For Spectral Subtraction
Navg=mean(Nabs,2);

% For Wiener filtering
Npsd=mean(Nabs2,2);
Spsd=mean(Sabs2,2);

% For DCT based noise suppression
Ndct2avg=mean(Ndct.^2,2);
Sdct2avg=mean(Sdct.^2,2);


% Generovani nulove vystupni posloupnosti
out = zeros(slen,1);
out2 = zeros(slen,1);
out3 = zeros(slen,1);
Gx=mean(Nabs2,2)+mean(Sabs2,2);
% Main cycle

for i=1:wnum

  % short-time frame selection
  
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame=sig(ii:jj).*w;
  
  % FFT-based spectral subtraction
  X=fft(frame);
  Xabs = abs(X) ;
  Xangle = angle(X) ;
  
  Yabs = Xabs - Navg ;
  Yabs = ( Yabs + abs(Yabs) )./ 2 ;   % Half-wave rectification
  % Yabs = abs(Yabs) ;   % Full-wave rectification
  
  yframe = real ( ifft( Yabs .* exp (j*Xangle) ) ) ;
  % Addition to output signal (implementation of OLA with general window)
  out(ii:jj)=out(ii:jj)+yframe ;
  
  % Wiener filter (basic), with half-wave rectification
  %   Gx=(Xabs.^2)./wlen;
  p = 0.5; % parametr zapomínání (exponenciální)
    
  Gx=p*Gx+(1-p)*(Xabs.^2)./wlen;
  % H=sqrt(((Gx-Npsd).*(Gx>Npsd))./Gx);
  H=((Gx-Npsd).*(Gx>Npsd))./Gx;
  
  
  y2frame = real ( ifft( X .* H ) ) ;
  out2(ii:jj)=out2(ii:jj)+y2frame ;
  
  % DCT-based noise suppression
  X=dct(frame);

  aprio_snr=(X.^2-Ndct2avg)./(Ndct2avg);
  aprio_snr = ( aprio_snr + abs(aprio_snr) )./ 2 ;   % Half-wave rectification
  G=sqrt(aprio_snr./(aprio_snr+1));
  % G=aprio_snr./(aprio_snr+1);
  Y=G.*X ;
  
  y3frame = idct ( Y ) ;
  % Addition to output signal (implementation of OLA with general window)
  out3(ii:jj)=out3(ii:jj)+y3frame ;

end

% Normalization of output signal

scale2 = sum ( w(1:wstep:wlen) ) ;
out = out ./ scale2 ;
out2 = out2 ./ scale2 ;
out3 = out3 ./ scale2 ;

if snrest==1,
    
    % Cycle for power comuptation
    for i=1:wnum,

        % short-time frame selection
        ii=(i-1)*wstep+1;
        jj=(i-1)*wstep+wlen;

        frame=sig(ii:jj);
        Pvdb(i)=10*log10(mean(frame.^2)) ;
        
        frameout=out(ii:jj);
        Pvdbout(i)=10*log10(mean(frameout.^2)) ;
        frameout2=out2(ii:jj);
        Pvdbout2(i)=10*log10(mean(frameout2.^2)) ;
        frameout3=out3(ii:jj);
        Pvdbout3(i)=10*log10(mean(frameout3.^2)) ;
    end
    
    Pvdbsort=sort(Pvdb);  estpart=round(0.1*length(Pvdbsort));
    SNRin = mean(Pvdbsort(end-estpart:end))-mean(Pvdbsort(1:estpart));
    
    Pvdbsortout=sort(Pvdbout);  estpart=round(0.1*length(Pvdbsortout));
    SNRout = mean(Pvdbsortout(end-estpart:end))-mean(Pvdbsortout(1:estpart));
    
    Pvdbsortout2=sort(Pvdbout2);  estpart=round(0.1*length(Pvdbsortout2));
    SNRout2 = mean(Pvdbsortout2(end-estpart:end))-mean(Pvdbsortout2(1:estpart));
    
    Pvdbsortout3=sort(Pvdbout3);  estpart=round(0.1*length(Pvdbsortout3));
    SNRout3 = mean(Pvdbsortout3(end-estpart:end))-mean(Pvdbsortout3(1:estpart));
    
else

    Pclean = mean(clean(wlen:end-wlen).^2);
    Pnoi = mean(noi(wlen:end-wlen).^2);

    SNRin = 10*log10(Pclean/Pnoi);

    noiout=out-clean(1:length(out));
    noiout2=out2-clean(1:length(out2));
    noiout3=out3-clean(1:length(out3));

    Pnoiout=mean(noiout(wlen:end-wlen).^2);
    Pnoiout2=mean(noiout2(wlen:end-wlen).^2);
    Pnoiout3=mean(noiout3(wlen:end-wlen).^2);

    SNRout=10*log10(Pclean/Pnoiout);
    SNRout2=10*log10(Pclean/Pnoiout2);
    SNRout3=10*log10(Pclean/Pnoiout3);
    
end


% Graphs for Spectral subtraction
figure(1); clf ;
subplot(211);
plot(sig);
title(['Input signal: SNRin = ' num2str(SNRin) ' dB']);
% player = audioplayer(out, fs); % přehrát zvuk
% play(player);

subplot(212);
plot(out) ;
title(['Output SSub: SNRout = ' num2str(SNRout) ' dB; SNRE = ' num2str(SNRout-SNRin) ' dB']);

figure(2)
subplot(211);
spectrogram(sig,wlen,[],[],fs,'yaxis'); 
title(['Input signal: SNRin = ' num2str(SNRin) ' dB']);
colorbar off

subplot(212);
spectrogram(out,wlen,[],[],fs,'yaxis'); 
title(['Output SSub: SNRout = ' num2str(SNRout) ' dB; SNRE = ' num2str(SNRout-SNRin) ' dB']);
colorbar off

% Graphs for Wiener filtering
figure(3); clf ;
subplot(211);
plot(sig);
title(['Input signal: SNRin = ' num2str(SNRin) ' dB']);

subplot(212);
plot(out2) ;
title(['Output WF: SNRout2 = ' num2str(SNRout2) ' dB; SNRE = ' num2str(SNRout2-SNRin) ' dB']);

figure(4)
subplot(211);
spectrogram(sig,wlen,[],[],fs,'yaxis'); 
title(['Input signal: SNRin = ' num2str(SNRin) ' dB']);
colorbar off

subplot(212);
spectrogram(out2,wlen,[],[],fs,'yaxis'); 
title(['Output WF: SNRout2 = ' num2str(SNRout2) ' dB; SNRE = ' num2str(SNRout2-SNRin) ' dB']);
colorbar off

% Graphs for Spectral subtraction
figure(5); clf ;
subplot(211);
plot(sig);
title(['Input signal: SNRin = ' num2str(SNRin) ' dB']);

% player = audioplayer(sig, fs); % přehrát zvuk
% play(player)

subplot(212);
plot(out3) ;
title(['Output DCT: SNRout = ' num2str(SNRout3) ' dB; SNRE = ' num2str(SNRout3-SNRin) ' dB']);

figure(6)
subplot(211);
spectrogram(sig,wlen,[],[],fs,'yaxis'); 
title(['Input signal: SNRin = ' num2str(SNRin) ' dB']);
colorbar off

subplot(212);
spectrogram(out3,wlen,[],[],fs,'yaxis'); 
title(['Output DCT: SNRout = ' num2str(SNRout3) ' dB; SNRE = ' num2str(SNRout3-SNRin) ' dB']);
colorbar off


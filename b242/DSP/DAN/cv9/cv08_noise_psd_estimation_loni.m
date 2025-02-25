% Various methods of noise suppresion

% Setup of directory with signals for different OS
if exist('/home/pollak'),  % it is the Linux OS
    linux=1;
    windows=0;
    addpath /home/pollak/www/html/vyu/b2m31dsp/m
    addpath /home/pollak/www/html/vyu/b2m31dsp/signaly
elseif exist('H:\VYUKA\DSP'),
    linux=0;
    windows=1;
    addpath H:\VYUKA\DSP\m
    addpath H:\VYUKA\DSP\signaly
elseif exist('C:\usr\pollak')
    linux=0;
    windows=1;
    addpath C:\usr\pollak\www\html\vyu\b2m31dsp\m
    addpath C:\usr\pollak\www\html\vyu\b2m31dsp\signaly
else
    error('ERROR: Predefined directories are not available. It must be changed within the script!')
end


% noi=loadbin('nc1.bin');
noi=loadbin('nc2.bin');
% noi=loadbin('nc3.bin');



% Vypocet poctu oken
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
slen=length(noi);
wlen=512 ;
wstep=wlen/2 ;
wnum=(slen-wlen)/wstep+1 ;

w=hamming(wlen);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation of magnitude spectrum of noise (for SS)
% Estimation of PSD of noise (for WF)
%   z prvniho casti signalu bez reci
%   (prvnich 30 segmentu, nebo wnum pro kratsi signaly)
Nabs=[] ;
Nabs2=[] ;
Sabs2=[] ;
Ndct=[];
Sdct=[];
for i=1:wnum,
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;
  nframe=noi(ii:jj).*w;
  N=fft(nframe);
  Nabs = [Nabs abs(N)] ;
  Nabs2 = [Nabs2 (abs(N).^2)./wlen] ;
end;

% averaged magnitude spectrum
Navg=mean(Nabs,2);

% Averaged power spectrum - i.e. smoothed PSD estimation
Npsd=mean(Nabs2,2);
Npsd_welch=pwelch(noi,wlen,wstep,wlen,'twosided');
Npsd_welch_wcomp=pwelch(noi,wlen,wstep,wlen,'twosided')/mean(hamming(wlen).^2);

% Short-time power spectrum
Gnst=Nabs2(:,1);

% Short-time magnitude spectrum
Nabsst=Nabs(1,:);

figure(1)
semilogy(Gnst,'b');
hold on
semilogy(Npsd,'r');
semilogy(Npsd_welch,'g');
semilogy(Npsd_welch_wcomp,'k-.');
hold off
title('PSD estimation')

legend('short-time','averaged manually','using pwelch','pwelch window compensation')


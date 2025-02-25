%Funciton CDET1 - Cepstral speech/pause (VAD) detector.
%                    LPC cepstrum (autocorrelation method)
%                    L2 cepstral distance without c[0]
%
%Called functions:   a2c
%                	
%Usage: [out,Dv,Dpv]=cdet1(sig[,cp,p,wlen,wstep,init]);              
%Input parameters:
%  sig    - vector with signal values
%Optional input parameters:                                    <Default values>
%  cp     - order of LPC model (number of cepstral coefficients)           <10>
%  p      - adaptation constant for background cepstrum updating          <0.8>
%  wlen   - length of signal segment                                      <256>
%  wstep  - length of step for segmentation                            <wlen/2>
%  init   - number of initial phase segments                          <2/(1-p)>
%Output parameters:
%  out    - output vector with values 0 or 1 for pause or speech
%  Dv     - vector with current cepstral distance
%  Dpv    - vector with current thresholds 

%                              Made by PP
%                             CVUT FEL K331
%                           Last change 11-02-99

function [out,Dv,Dpv]=cdet1(sig,cp,p,wlen,wstep,init);

q=0.99;

if nargin<2,
  cp=10;
end;
if nargin<3,
  p=0.8;
end;
if nargin<4, 
  wlen=256;
end;
if nargin<5,
  wstep=wlen/2;
end;
if nargin<6, 
  init=1/2*floor(1/(1-q));
end;

za=2;

sig=sig(:);

w=hamming(wlen);
frame1=sig(1:wlen).*w;
frame2=sig(1+wstep:wlen+wstep).*w;

a1=lpc(frame1,cp);   
a2=lpc(frame2,cp);

c1=a2c(a1(2:cp+1),cp,cp);
c2=a2c(a2(2:cp+1),cp,cp);
c0=mean([c1; c2]);

dist=sqrt(sum((c0-c2).^2));

Dmean=dist;
Dmean2=dist*dist;
Dvar=0;

out=[];
Dv=[];
Dpv=[];

slen=length(sig);
wnum=floor((slen-wlen)/wstep)+1;

for i=1:wnum,

  frame=sig(1+wstep*(i-1):wlen+wstep*(i-1)).*w;
  ai=lpc(frame,cp);   
  ci=a2c(ai(2:cp+1),cp,cp);

  D=sqrt(sum((c0-ci).^2));

  Dv=[Dv D];
  Dp=Dmean+za*sqrt(Dvar);
  Dpv=[Dpv Dp];

  if ( D>Dp & i>init ),
    out=[out 1];
  else
    out=[out 0];

    c0=p*c0+(1-p)*ci;

    Dmean=q*Dmean+(1-q)*D;
    Dmean2=q*Dmean2+(1-q)*D*D;
    Dvar=Dmean2-Dmean*Dmean;

  end;

end;


out=out(:);
Dv=Dv(:);
Dpv=Dpv(:);  

if nargout < 1,
  figure(gcf); clf;
  x=1:length(out);
  subplot(211);
  plot(x,Dv,'r-',x,Dpv,'b--');
  axis([0 max(x) 0 max(Dv)]);
  title('Cepstral distance (CD1) and adaptive threshold');
  xlabel('Frame No.');
  ylabel('CD1');
  subplot(212);
  plot(x,out,'g-');
  title('Final detection');
  xlabel('Frame No.');
  ylabel('out');
  axis([0 max(x) -0.1 1.2]);
end;


% adaptivni metody potlaceni sumu
fs = 16000;

clean = loadbin("SA001S01.CS0");

lfn = loadbin("nc1.bin");
%hfn = loadbin("nc2.bin");
%bfn = loadbin("nc3.bin");

K = 0.1;

noise = lfn(1:length(clean)).*K;

sig = clean + noise;

signoise1 = 10 * log10( (rms(sig(18000:80000))^2 - rms(sig(1:16000))^2) / rms(sig(1:16000))^2)

% Computation of short-time frame amount (50% overlap)
slen=length(sig);
wlen=512 ;
wstep=wlen/2 ;
wnum=(slen-wlen)/wstep+1 ;

w=hamming(wlen);

% Zero-initialization of output signal
out = zeros(slen,1);

% PSD welch for Wiener
Sn = zeros(wlen,1);

for i=1:wnum

  % short-time frame selection
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame1 = noise(ii:jj).*w;
  
  Sn = Sn + abs(fft(frame1)).^2;
end
Sn = Sn .*(1 / (wnum));



% Zero-initialization of output signal
out = zeros(slen,1);

% Main cycle
for i=1:wnum

  % short-time frame selection
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;

  frame=sig(ii:jj).*w;
  
  X = fft(frame);
  Gx = abs(X).^2;
  angY = angle(X);
  modY = (Gx - Sn).*(Gx >= Sn); %jednosmer
  %modY = abs(Gx - Sn); %dvousmer
  Y = sqrt(modY).*exp(angY*1i);
  yframe = real(ifft(Y));
  
  % Addition to output signal (implementation of OLA with general window)
  out(ii:jj)=out(ii:jj)+yframe ;

end

% Normalization of output signal

scale2 = sum ( w(1:wstep:wlen) ) ;
out = out ./ scale2 ;

signoise2 = 10 * log10( (rms(out(18000:80000))^2 - rms(out(1:16000))^2) / rms(out(1:16000))^2)

improvement = signoise2 - signoise1

figure(1)
plot(sig)
hold on
plot(out)
hold off

figure(2)
plot(10*log10(Sn))


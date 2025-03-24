%A*u = lambda*u
%(A-lambda*E)*u = 0
%[V, D] = eig(R) V... matice vlastních vektorů, 
% D...matice vlastních čísel(vlastní čísla na diagonále)
% A=Rss ... kovarianční matice signálu -> V...vlastní vektory signálu
% KLT : matice transformace WKLT = |v1| = V'
%                                  |v2| 
%                                  |v3|
% KLT spektrum : XKLT = WKLT*x
% x = WKLT^-1*XKLT = WKLT'* * XKLT (WKLT transponovaná, komplexně sdružená)
%parmetry signálů
f1 = 821;
f2 = 532;
f3 = 640;
f4 = 1642;
fs = 16000;
k = 0.001;
wlen = 200;
wstep = 50;
nreal = 20;

%načtení řečového signálu
fsr1 = 16000;
r1 = loadbin('vm0.bin');
r1 = r1(:);
%slen = length(r1);

%generování sinusovek
slen = 4000;
tt = 0:1/fs:(slen - 1)/fs;
tt = tt(:);
s1 = sin(2*pi*f1*tt);
s2 = sin(2*pi*f2*tt) + sin(2*pi*f3*tt);
s1 = s1(:);
s2 = s2(:);
s3 = sin(2*pi*f4*tt);
s4 = s1 + 0.5.*s3;
s5 = 0.7.*s1 + 0.9.*s3;
% 
% %analýza směsí
% S_mtx = [s4,s5];
% RS = S_mtx*S_mtx';
% [V,D] = eig(RS);
% W = flipud(V');
% X = W*S_mtx;
% 
% 
% figure(20)
%     subplot(211)
%     plot(s1)
%     subplot(212)
%     plot(s3)
% 
% figure(21)
%     plot(s1,s3, '.')
% figure(22)
%     plot(s4,s5,'.')
%     hold on
%     plot(X(:,1)./30 - 0.5064,X(:,2)./30 + 0.55, 'r')
%     hold off
% figure(23)
%     plot(V(:,end).*D(end,end), V(:,end-1).*D(end-1,end-1), '.')

%generování šumů
n1 = randn(slen,1).*k;
n2 = randn(slen,1).*k;
n1 = n1(:);
n2 = n2(:);

%přidávám šum k sinusovce
s1 = s1 + n1;
s2 = s2 + n2;
r1 = r1 + n1(1:2000);
SS1 = [];
SS2 = [];
SR1 = [];
for i = 1:nreal
  ii=(i-1)*wstep+1;
  jj=(i-1)*wstep+wlen;
  frame1 = s1(ii:jj);
  frame2 = s2(ii:jj);
  frame3 = r1(ii:jj);
  SS1 = [SS1, frame1];
  SS2 = [SS2, frame2];
  SR1 = [SR1, frame3];
end

RSS1 = SS1*SS1';
RSS2 = SS2*SS2';
RSR1 = SR1*SR1';
[V1, D1] = eig(RSS1);
[V2, D2] = eig(RSS2);
[V3, D3] = eig(RSR1);
lam1 = diag(D1);
lam2 = diag(D2);
lam3 = diag(D3);

WKLT1 = flipud(V1');
x1 = s1(110:309);
XKLT1 = WKLT1*x1;
Xfft1 = fft(x1);
Xdct1 = dct(x1);

WKLT2 = flipud(V2');
x2 = s2(1:200);
XKLT2 = WKLT2*x2;
Xfft2 = fft(x2);
Xdct2 = dct(x2);

figure(1)
    subplot(311)
        stem(lam1)
        title('vlastní čísla s1')
    subplot(312)
        stem(lam2)
        title('vlastní čísla s2')
    subplot(313)
        stem(lam3)
        title('vlastní čísla řečového signálu')

figure(2)
    subplot(411)
        plot(V1(:,(end - 3)));
        title('vlastní vektor s1 čtvrtý od konce')
    subplot(412)
        plot(V1(:,(end - 2)));
        title('vlastní vektor s1 třetí od konce')
    subplot(413)
        plot(V1(:,(end - 1)));
        title('vlastní vektor s1 druhý od konce')
    subplot(414)
        plot(V1(:,(end)));
        title('vlastní vektor s1 ale tenhle je poslední')

figure(3)
    subplot(411)
        plot(V2(:,(end - 3)));
        title('vlastní vektor s2 čtvrtý od konce')
    subplot(412)
        plot(V2(:,(end - 2)));
        title('vlastní vektor s2 třetí od konce')
    subplot(413)
        plot(V2(:,(end - 1)));
        title('vlastní vektor s2 druhý od konce')
    subplot(414)
        plot(V2(:,(end)));
        title('vlastní vektor s2 ale tenhle je poslední')

figure(4)
    subplot(411)
        plot(V3(:,(end - 3)));
        title('vlastní vektor r1 čtvrtý od konce')
    subplot(412)
        plot(V3(:,(end - 2)));
        title('vlastní vektor r1 třetí od konce')
    subplot(413)
        plot(V3(:,(end - 1)));
        title('vlastní vektor r1 druhý od konce')
    subplot(414)
        plot(V3(:,(end)));
        title('vlastní vektor r1 ale tenhle je poslední')

figure(5)
    subplot(311)
        plot(XKLT1)
        title('KLT spektrum s1')
    subplot(312)
        plot(abs(Xfft1))
        title('fft spektrum s1')
    subplot(313)
        plot(Xdct1)
        title('dct spektrum s1')

figure(6)
    subplot(311)
        stem(abs(XKLT2))
        title('KLT spektrum s2')
    subplot(312)
        plot(abs(Xfft2))
        title('fft spektrum s2')
    subplot(313)
        plot(abs(Xdct2))
        title('dct spektrum s2')
%%
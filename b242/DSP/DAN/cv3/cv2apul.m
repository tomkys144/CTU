% close all; clc; clear all;
close all; clc;
% LPC spektrum

frame = loadbin('vm0-512.bin');
frame=frame(:);

fs = 16000;

wlen=length(frame);

w = hamming(wlen); % okno, pocet bodů = wlen, vždy se generuje jako sloupcový vektor
% takže sloupec musí být taky sloupcový
framew = frame.*w;

X=fft(framew);
Gx=(abs(X).^2)./wlen;

figure(1);
plot([frame framew]);
axis tight % aby byl obrázek co nejvíc vyplněný

figure(2);
plot(10*log10(Gx)); % je tam trochu náhodná složka
% signál je periodický => lze složit Fourierovou řadou (počtu harmonických
% složek)
% první harmonická složka je na frekvenci odpovídající periodě signálu
% další harmonická složka je na frekvenci v násobcích první harmonické
% to jsou špičky v tomhle signálu
axis tight

p = 16; % řád
[a, Ep] = lpc(framew,p); % Ep = výkon chyby predikce
b = sqrt(Ep); % modifikace spektra
n = wlen; % počet bodů

figure(3);
freqz(b,a,n); % frekvenční charakteristika

[H, FFF] = freqz(b,a,n,'whole'); % whole - trochu vykompenzujeme- nakreslíme
% celou statistiku
% FFF - nechápu
LPCx =abs(H).^2; % bez druhé mocniny - jiná dynamika - not good



figure(2);
% FF = 0:fs/wlen:fs-fs/wlen; % vektor frekvencí, jeden vzorek odečteme sAMoZřejMě
hold on
plot(10*log10(LPCx),'r');
hold off

% jak získat vyhlazené spektrum? Welchovo metodou, ale je potřeba delší
% signál, protože je v něm potřeba mnoho realizací
% takhle ale získáme odhad z jedné realizace, ofc že s nějakou chybou

% řád 16 vypadá jako optimum, modeluje nejvýznamnější špičky (formanty)
% ofc nejsme schopni mít hluboký zářež, je tam jen zvlnění, ale je to už
% -40 dB pod hladinou
% řád p = 10 => 10 pólů => modelujeme 5 špiček - trochu větší komprese
% řád p = 20 => 20 pólů => modeluje se 10 špiček - větší detail
% moc velký řád - začínají se modelovat harmonické složky - až moc detailu
% - basically overfit
% v řeči 4 formanty => 4 špičky => aspoň 8 pólů, dáme si rezervu na 10 pólů

% === jednotlivé vzorky se nepřenáší, ale přenáší se koeficienty
% rekonstruující signál

figure(4);
zplane(b, a);

% špatně nastavené NFFT - nebude si to sedět z hlediska měřítka
% 
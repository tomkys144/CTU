
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
format long
sig20 = loadbin('frame-022.bin');
%váhování oknem
w20 = hamming(length(sig20));
sig20 = sig20.*w20;
%výpočet DCT-2
Xdct20 = dctxc1(sig20);
ans20 = Xdct20(1:8)
%%
sigs = load("sigs_2chan_08.mat");
sig1_1 = sigs.sig1;
sig1_2 = sigs.sig2;
sig1_1 = sig1_1(:);
sig1_2 = sig1_2(:);
%parametry 
tlen1 = 0.064;
fs1   = 8000;
wlen1 = fs1*tlen1;
w1 = hamming(wlen1);
%nover1 = 0.75*wlen1;
nover1 = 0.5*wlen1;
%výpočet MSC
msc1 = mscohere(sig1_1,sig1_2,w1,nover1,wlen1,fs1);
ans1 = mean(msc1)

%%
%načtení signálů
sig2_1 = loadbin('frame-001.bin');
sig2_2 = loadbin('frame-012.bin');
sig2_1 = sig2_1(:);
sig2_2 = sig2_2(:);
%váhování oknem
w2 = hamming(length(sig2_1));
sig2_1 = sig2_1.*w2;
sig2_2 = sig2_2.*w2;
%výpočet kepster
keps2_1 = aceps(sig2_1,16,12);
keps2_2 = aceps(sig2_2,16,12);
keps2_1 = keps2_1(1:13);
keps2_2 = keps2_2(1:13);
%výpočet kepstrální vzdálenosti
ans2 = cde(keps2_1, keps2_2)

%%
sig7_clean = loadbin('SA018S01.CS0');
sig7_noisy = loadbin('SX018S01.CS0');
%výpočet šumu
n7 = sig7_noisy - sig7_clean;
%výkony
P_sig7 = mean(sig7_clean.^2);
P_n7 = mean(n7.^2);
%SNR
ans7 = 10*log10(P_sig7/P_n7)

%%
sig = loadbin('frame-006.bin');
w = hamming(length(sig));
sig = sig.*w;
keps = cceps(sig);
%zobrazení výsledku
figure;
    plot(keps)
    axis tight

%%
sig6 = loadbin('frame-008.bin');
%DCT
XDCT6 = dct(sig6);
%výběr prvních 70 komponent
XDCT6 = XDCT6(1:70);
%IDCT
sig6_2 = idct(XDCT6,length(sig6));
%výpočty výkonů
P_sig6 = mean(sig6.^2);
P_sig6_2 = mean(sig6_2.^2);
ans6 = P_sig6_2/P_sig6*100

%%
sigs13 = load('sig_xy_04.mat');
sig13_x = sigs13.x;
sig13_y = sigs13.y;
%parametry výpočtu
fs13 = 16000;
wlen13 = 512;
nover13 = wlen13/2;
%výpočet cpsd
[Sxy13, ff13] = cpsd(sig13_x, sig13_y,wlen13,nover13,wlen13,fs13);
%plot
figure(13)
    plot(ff13, unwrap(angle(Sxy13)))
    title('odpověď na příklad 13')
%%
sig22_clean = loadbin('frame-001.bin');
sig22_dist  = loadbin('frame-025.bin');
%parametry výpočtu
wlen22 = 512;
wstep22 = wlen22*0.5;
cp22 = 13;
w = hamming(wlen22);
% sig22_clean = sig22_clean.*w;
% sig22_dist = sig22_dist.*w;
%výpočet kepster
keps22_clean = vrceps(sig22_clean,1,cp22,wlen22,wstep22);
keps22_dist  = vrceps(sig22_dist,1,cp22,wlen22,wstep22);
% keps22_clean = rceps(sig22_clean); keps22_clean = keps22_clean(1:13);
% keps22_dist  = rceps(sig22_dist); keps22_dist = keps22_dist(1:13);

%výpočet kepstrální vzdálenosti
ans22 = mean(cde(keps22_dist, keps22_clean)) 
clc;
disp(ans22);
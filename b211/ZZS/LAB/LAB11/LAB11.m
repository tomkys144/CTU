beep off
clear all
close all
clc

%% img read
IMG=imread('morse.png');
IMG=mean(double(IMG)/255,3);
IMG(IMG>1)=1;
IMG(IMG<0)=0;

figure()
subplot(411)
imagesc(IMG); axis image; caxis([0 1]); colormap('gray')

nc=2;
[idx,C]=kmeans(IMG(:),nc,...
    'start',linspace(0,1,nc)');
th=mean(C); % mezi centroidy
I=IMG<th;
subplot(412)
imagesc(I); axis image; caxis([0 1]); colormap('gray')

subplot(413)
n=sum(I,1); % suma přes řádky (součet ve sloupci)
plot(n)
xlim([0 2300]);
ylabel('n');

subplot(414)
roi=n>0;
plot(roi)
xlim([0 2300]); ylim([-0.1 1.1]);
title('ROI');

up=find(diff([0,roi])>0); % náběžná
dw=find(diff([roi,0])<0); % sestupná

%% sign preparation
tic
figure()
subplot(131)
[X,Y]=meshgrid(-20:20,-20:20); % matice 41x41 se středem v [0,0]
R=sqrt(X.^2+Y.^2);
R=R<=10; % kruh s poloměrem 10
imagesc(R); axis image; caxis([0 1]); colormap('gray')
title('dot')
subplot(132)
% čárka: obdélník 10x40
comma=zeros(40,40);
comma(15:25,:)=1;
imagesc(comma); axis image; caxis([0 1]); colormap('gray')
title('comma')

subplot(133)
% svislý obdélník 40x10
vb=comma';
imagesc(vb); axis image; caxis([0 1]); colormap('gray')
title('vertical bar')

%% convolution mask

sig=2; % rozmazání v px (směrodatná odchylka )
[XM,YM]=meshgrid(-2*sig:2*sig,-2*sig:2*sig);% rastr, ±2*s
r=sqrt(XM.^2+YM.^2); % rádius – vzdálenost od středu
GM=exp((-1/2)*(r-sig)^2); % PDF(r) 
GM=GM./sum(GM(:)); % normalizace na jednotkovou energii
IG=conv2(I,GM,'valid'); % konvoluce rozmaže obraz

RG=conv2(R, GM, 'valid'); % rozmaže tečku
commaG=conv2(comma, GM, 'valid'); % rozmaže mezeru
vbG=conv2(vb, GM, 'valid'); % rozmaže svislítko

figure()
subplot(2,3,[1 3])
imagesc(IG); axis image; caxis([0 1]); colormap('gray')
title('IMG');

subplot(234)
imagesc(RG); axis image; caxis([0 1]); colormap('gray')
title('dot');

subplot(235)
imagesc(commaG); axis image; caxis([0 1]); colormap('gray')
title('comma');

subplot(236)
imagesc(vbG); axis image; caxis([0 1]); colormap('gray')
title('vertical bar');

%% corelation
figure()
subplot(411)
C_R=normxcorr2(RG,IG); % korelace s tečkou
crop=floor(size(RG)/2);
C_R=C_R(crop(1)+1:end-crop(1),crop(2)+1:end-crop(2)); % ořez okrajů
imagesc(C_R); axis image; caxis([-1 1])
title('correlation with dot');

subplot(412)
C_com=normxcorr2(commaG,IG); % korelace s čárkou
crop=floor(size(commaG)/2);
C_com=C_com(crop(1)+1:end-crop(1),crop(2)+1:end-crop(2));
imagesc(C_com); axis image; caxis([-1 1])
title('correlation with comma');

subplot(413)
C_vb=normxcorr2(vbG,IG); % korelace s oddělovačem
crop=floor(size(vbG)/2);
C_vb=C_vb(crop(1)+1:end-crop(1),crop(2)+1:end-crop(2)); % ořez okrajů
imagesc(C_vb); axis image; caxis([-1 1])
title('correlation with vertical bar');

cl=zeros(1,length(up)); % definice vektoru pro uložení třídy
for i=1:length(up)
    seg=C_R(:,up(i):dw(i)); % korelace s tečkou
    max_R=max(seg(:)); % max. korelace v ROI
    
    seg=C_com(:,up(i):dw(i)); % korelace s čárkou
    max_com=max(seg(:)); % max. korelace v ROI
    
    seg=C_vb(:,up(i):dw(i)); % korelace s oddělovačem
    max_vb=max(seg(:)); % max. korelace v ROI
    
    [~,cl(i)]=max([max_R,max_com,max_vb]); % třída, pozice max. korelace
end

subplot(414)
stem(cl);
set(gca,'YTick',[1 2 3],'YTickLabel',{'dot','comma','vertical bar'})
xlabel('symbol')
temp='.-|';
str=temp(cl);
title(str, 'FontSize',20)

disp('HELLO WORLD')
toc

%% parametrisation
tic
nh=zeros(1,length(up));
nv=zeros(1,length(up));

for i=1:length(up)
    seg=I(:,up(i):dw(i));
    nh(i)=sum(sum(seg,1)>0); % šířka
    nv(i)=sum(sum(seg,2)>0); % výška
end
nh=nh/max(nh);
nv=nv/max(nv);

figure()
subplot(211)
plot(nh,nv,'o');
xlabel('horizontal size'); ylabel('vertical size'); title('Parameters of ROI');

S=[0.5 0.5; % tečka 
   0.8 0.2;  % čárka
   0.2 0.8]; % oddělovač

[idx,CC]=kmeans([nh(:) nv(:)],3,'start',S);

subplot(212)
plot(nh(idx==1),nv(idx==1),'ro') % tečka 
hold on
plot(nh(idx==2),nv(idx==2),'bo') % čárka
hold on
plot(nh(idx==3),nv(idx==3),'mo') % oddělovač

temp='.-|';
str2=temp(idx);
title(str2,'FontSize',20)
xlabel('horizontal size'); ylabel('vertical size');
disp('HELLO WORLD => souhlasi')
toc
disp('Metoda pomoci parametrizace je vyrazne rychlejsi')
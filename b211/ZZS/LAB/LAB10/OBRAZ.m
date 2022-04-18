beep off
close all
clear all
clc

%% monochromatic
IMGC=imread('railtracks_render.jpg');

figure('Name','Monochromatic picture');
subplot(211)
image(IMGC); axis image

subplot(212);
IMG=mean(double(IMGC),3);
IMG=IMG/255;
imagesc(IMG); axis image; caxis([0 1])
colormap('gray');

%% brightness

bright=-0.1;
IMGT=IMG+bright;
IMGT(IMGT>1)=1;
IMGT(IMGT<0)=0;

I=linspace(0,1,256);
T=I+bright;
tf_title=['y=x' num2str(100*bright,'%+.f') '%'];

fig_gen(IMG, T, IMGT, tf_title, 'Brightness decrease');

bright=0.2;
IMGT=IMG+bright;
IMGT(IMGT>1)=1;
IMGT(IMGT<0)=0;

I=linspace(0,1,256);
T=I+bright;
tf_title=['y=x' num2str(100*bright,'%+.f') '%'];
fig_gen(IMG, T, IMGT, tf_title, 'Brightness increase');

%% negative
IMGT=1-IMG;
IMGT(IMGT>1)=0;
IMGT(IMGT<0)=0;

T=linspace(1,0,256);
tf_title='negative';

fig_gen(IMG, T, IMGT, tf_title, 'Negative');

%% contrast

a=2;
b=0.5*(1-a);

IMGT=a*IMG+b; 
IMGT(IMGT>1)=1;
IMGT(IMGT<0)=0;
I=linspace(0,1,256);
T=a*I+b;
tf_title=['constrast ' num2str(a, '%.2f')];

fig_gen(IMG, T, IMGT, tf_title, 'Contrast increase');

a=0.5;
b=0.5*(1-a);

IMGT=a*IMG+b; 
IMGT(IMGT>1)=1;
IMGT(IMGT<0)=0;
I=linspace(0,1,256);
T=a*I+b;
tf_title=['constrast ' num2str(a, '%.2f')];

fig_gen(IMG, T, IMGT, tf_title, 'Contrast decrease');

%% gamma

gamma=2;
IMGT=IMG.^gamma;
T=linspace(0,1,256).^gamma;
tf_title=['y=x^{' num2str(gamma, '%.2f') '}'];
fig_gen(IMG, T, IMGT, tf_title, 'Gamma >1');

gamma=0.5;
IMGT=IMG.^gamma;
T=linspace(0,1,256).^gamma;
tf_title=['y=x^{' num2str(a, '%.2f') '}'];
fig_gen(IMG, T, IMGT, tf_title, 'Gamma <1');

%% Equlisation

[H,~]=hist(IMG(:),256); % histogram
CDF=cumsum(H)/sum(H); % kumulativní distribuční funkce
IMGT=CDF(round(255*IMG+1)); % jas na indexy 1-256
T=CDF(round(255*linspace(0,1,256)+1));
tf_title='Equalised';
fig_gen(IMG, T, IMGT, tf_title, 'Equlisation');

%% Second equalisation

[H,~]=hist(IMGT(:),256); % histogram
CDF=cumsum(H)/sum(H); % kumulativní distribuční funkce
IMGE=CDF(round(255*IMGT+1)); % jas na indexy 1-256
T=CDF(round(255*T+1));
tf_title='Equalised';
fig_gen(IMGT, T, IMGE, tf_title, 'Second Equlisation');

%% 3-bit redution

nc=8; % 8 barev
I=linspace(0,1,256);
IMGT=round(IMG*nc)/nc;

T=round(linspace(0,1,256)*nc)/nc;
tf_title=[num2str(nc, '%.f') ' colours'];
fig_gen(IMG, T, IMGT, tf_title, '3-bit redution');

%% 3-bit redution via k-means

nc=8; % 8 barev (klastrů)
[idx,C]=kmeans(IMG(:),nc,... % vektor pixelů
    'start',linspace(0,1,nc)'); % inicializace centroidů
IMGT=reshape(C(idx),size(IMG)); % přímá indexace a přeskupení
IMGT(IMGT>1)=1;
IMGT(IMGT<0)=0;
[H,idx]=hist(IMGT(:),256);
T=cumsum(H)/sum(H);
tf_title=[num2str(nc, '%.f') ' colours'];
fig_gen(IMG, T, IMGT, tf_title, '3-bit redution via k-mean');
%% Background/foreground segmentation

% mean -----------
th=mean(IMG(:));

IMGT=IMG>th;
T=linspace(0,1,256)>th;
tf_title=['th=' num2str(th, '%.5f')];
fig_gen(IMG, T, IMGT, tf_title, 'Segmentation mean');

% median ---------
th=median(IMG(:));

IMGT=IMG>th;
T=linspace(0,1,256)>th;
tf_title=['th=' num2str(th, '%.5f')];
fig_gen(IMG, T, IMGT, tf_title, 'Segmentation median');

% k-means --------
nc=2;
[idx,C]=kmeans(IMG(:),nc,...
    'start',linspace(0,1,nc)');
th=mean(C); % mezi centroidy

IMGT=IMG>th;
T=linspace(0,1,256)>th;
tf_title=['th=' num2str(th, '%.5f')];
fig_gen(IMG, T, IMGT, tf_title, 'Segmentation k-means');

%% MRI_T2
IMG=imread('MRI_T2.png');
IMG=double(IMG);
IMG=IMG/255;
IMG(IMG>1)=1;
IMG(IMG<0)=0;


R=[0.776 1]; % rozměr pixelu v mm   
new_res=round(size(IMG).*R); % nové rozlišení v poměru R
[X,Y]=meshgrid(1:size(IMG,2),1:size(IMG,1)); % od 1. po poslední pixel
[XI,YI]=meshgrid(linspace(1,size(IMG,2),new_res(2)),linspace(1,size(IMG,1),new_res(1)));

IMGT=interp2(X,Y,IMG,XI,YI); % interpolace IMG->IMGT

figure('Name','MRI_T2')
subplot(231); imagesc(IMG); axis image; caxis([0 1]); colorbar; title([num2str(size(IMG,1)) 'x' num2str(size(IMG,2)) ' px'])
subplot(232); imagesc(X); title('x-coordinate'); axis image; colorbar
subplot(233); imagesc(Y); title('y-coordinate'); axis image; colorbar;
  colormap('gray')
subplot(234); imagesc(IMGT); axis image; caxis([0 1]); colorbar; title([num2str(new_res(1)) 'x' num2str(new_res(2)) ' px'])
subplot(235); imagesc(XI); title('x-coordinate'); axis image; colorbar
subplot(236); imagesc(YI); title('y-coordinate'); axis image; colorbar

%% transformation

figure('Name', 'Transforation')
subplot(231);
imagesc(IMG); axis image; caxis([0 1]);  colormap('gray')
title('original')

subplot(232)
[X,Y]=meshgrid(1:size(IMG,2),1:size(IMG,1)); % originální rastr
rx=1; 
ry=1/0.776; % 0.776 mm -> 1 mm 

T=[rx 0 0;
   0 ry 0;
   0 0 1];

XYI=T*[X(:)';Y(:)'; ones(1,numel(X))]; % transformace souřadnic
 
XI=reshape(XYI(1,:),size(X)); % sestavení nového rastru
YI=reshape(XYI(2,:),size(Y)); % sestavení nového rastru

IMGT=interp2(X,Y,IMG,XI,YI); % lineární interpolace

imagesc(IMGT); axis image; caxis([0 1]);  colormap('gray')
title('Proportion change')

subplot(233)
px=-100; % horizontální posun
py=-150; % vertikální posun
 
T=[1 0 px;
   0 1 py;
   0 0 1]; % transformační matice

XYT=T*[X(:)';Y(:)';ones(1,numel(X))];

XI=reshape(XYT(1,:),size(X));
YI=reshape(XYT(2,:),size(Y));
IMGT=interp2(X,Y,IMG,XI,YI);

imagesc(IMGT); axis image; caxis([0 1]);  colormap('gray')
title('shift')

subplot(234)
ax=0;
ay=30;
 
T=[1 tand(ay) 0;
   tand(ax) 1 0;
   0 0 1]; % transformační matice

XYT=T*[X(:)';Y(:)';ones(1,numel(X))];

XI=reshape(XYT(1,:),size(X));
YI=reshape(XYT(2,:),size(Y));
IMGT=interp2(X,Y,IMG,XI,YI);

imagesc(IMGT); axis image; caxis([0 1]);  colormap('gray')
title('shift')

subplot(235)
fi=30; % stupně
T=[cosd(fi) sind(fi) 0; 
   -sind(fi) cosd(fi) 0;
   0 0 1];
XYT=T*[X(:)';Y(:)';ones(1,numel(X))];

XI=reshape(XYT(1,:),size(X));
YI=reshape(XYT(2,:),size(Y));
IMGT=interp2(X,Y,IMG,XI,YI);

imagesc(IMGT); axis image; caxis([0 1]);  colormap('gray')
title('rotation around center of coords')

subplot(236)
px=-size(IMG,2)/2; % na střed x 
py=-size(IMG,1)/2; % na střed y
T1=[1 0 px;
    0 1 py;
    0 0 1];

fi=30;
T2=[cosd(fi) sind(fi) 0;
    -sind(fi) cosd(fi) 0;
    0 0 1];

XYT=inv(T1)*T2*T1*[X(:)';Y(:)'; ones(1,numel(X))];

XI=reshape(XYT(1,:),size(X));
YI=reshape(XYT(2,:),size(Y));
IMGT=interp2(X,Y,IMG,XI,YI);

imagesc(IMGT); axis image; caxis([0 1]);  colormap('gray')
title('rotation around center of img')
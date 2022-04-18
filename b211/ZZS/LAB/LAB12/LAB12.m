beep off
close all
clear all
clc

%% data cleanup

load('bio_studenti'); % proměnná DATA

HIGH=DATA{:,1}; % tělesná výška
EYE=DATA{:,2}; % table na cell (protože barva jako string)
HEAD=DATA{:,3}; % obvod hlavy
FOOT=DATA{:,4}; % velikost obuvi 
KOS=DATA{:,5}; % vážený průměr dle KOS
SEX=DATA{:,6}; % table na cell (protože pohlaví jako string)

invalid_high = HIGH<145 | HIGH>220;
invalid_head = HEAD<53 | HEAD>63;
invalid_foot = FOOT<35 | FOOT>49;
invalid_kos = KOS<1 | KOS>3;

fxs=@(x) ~(strcmpi(x,'žena') | strcmpi(x,'muž'));
invalid_sex=cellfun(fxs,SEX);

fxe=@(x) ~(strcmpi(x,'hnědá') | strcmpi(x,'zelená') | strcmpi(x,'modrá/šedá'));
invalid_eye=cellfun(fxe,EYE);

% vypište si, kde se nacházejí chybné odpovědi
disp(['chybné pohlaví u probanda :'     num2str(find(invalid_sex)')]);
disp(['chybná barva očí u probanda :'  num2str(find(invalid_eye)')]);
disp(['chybná výška u probanda :'        num2str(find(invalid_high)')]);
disp(['chybný obvod hlavy u probanda :'  num2str(find(invalid_head)')]);
disp(['chybná velikost boty u probanda :' num2str(find(invalid_foot)')]);
disp(['chybný průměr KOS u probanda :'  num2str(find(invalid_kos)')]);

HEAD(invalid_head)=NaN;
KOS(invalid_kos)=NaN;

% odstranění probandů
to_remove=find(invalid_sex | invalid_eye | invalid_high | invalid_foot);

SEX(to_remove)=[];
EYE(to_remove)=[];
HIGH(to_remove)=[];
HEAD(to_remove)=[];
FOOT(to_remove)=[];
KOS(to_remove)=[];

SEX=cellfun(@(x) strcmpi(x,'žena'),SEX); % (1)-žena, false (0)-muž
[EYE_label,~,EYE]=unique(EYE); % (1)-Hnědá, (2)-Modrá/Šedá, (3)-Zelená

%% Data disply

figure()

subplot(231)
boxplot(HIGH,SEX);
set(gca,'XTickLabel',{'Male','Female'})
ylabel('[cm]'); title('Body high');

subplot(232)
boxplot(HEAD,SEX);
set(gca,'XTickLabel',{'Male','Female'})
ylabel('[cm]'); title('Head circumference');

subplot(233)
boxplot(FOOT,SEX);
set(gca,'XTickLabel',{'Male','Female'})
ylabel('[-]'); title('Shoes size');

subplot(234)
boxplot(KOS,SEX);
set(gca,'XTickLabel',{'Male','Female'})
title('KOS evaluation');

subplot(235)
EYE_cat=categorical(EYE,[1 2 3],EYE_label);
histogram(EYE_cat)
ylabel('n'); title('Eyes color');

%% test normality

[h0_f_high,p_f_high]= adtest(HIGH(SEX)); 
[h0_m_high,p_m_high]= adtest(HIGH(~SEX));

[h0_f_head,p_f_head]= adtest(HEAD(SEX)); 
[h0_m_head,p_m_head]= adtest(HEAD(~SEX));

[h0_f_foot,p_f_foot]= adtest(FOOT(SEX)); 
[h0_m_foot,p_m_foot]= adtest(FOOT(~SEX));

[h0_f_kos,p_f_kos]= adtest(KOS(SEX)); 
[h0_m_kos,p_m_kos]= adtest(KOS(~SEX));

h0_f=[h0_f_high;h0_f_head;h0_f_foot;h0_f_kos];
h0_m=[h0_m_high;h0_m_head;h0_m_foot;h0_m_kos];
p_f=[p_f_high;p_f_head;p_f_foot;p_f_kos];
p_m=[p_m_high;p_m_head;p_m_foot;p_m_kos];
test=["U-test";"U-test";"dvouvýběrový test";"dvouvýběrový test"];
label=["Tělesná výška";"Obvod hlavy";"Velikost obuvy";"Studijní průměr"];
var=["Parametr"; "H0/H1 Muži"; "p Muži"; "H0/H1 Ženy"; "p Ženy"; "Výběr testu"];
disp(table(label,h0_m,p_m,h0_f,p_f,test, 'VariableNames', var));

%% Dvouvýběrové testy

p_alpha=0.05/4; % Bonferroniho korekce, hodnota korekce je 0.05-p_alpha
% pozor na pořadí výstupů funkcí u jednotlivých testů
% A: H0-tělesná výška je stejná mezi muži a ženami (dle normality U-testem)
% [H0A,pA] =ttest2(HIGH(SEX),HIGH(~SEX),'Alpha',p_alpha); % paremetrický
[pA ,H0A]=ranksum(HIGH(SEX),HIGH(~SEX),'Alpha',p_alpha); % neparametrický
[pB, H0B]=ranksum(HEAD(SEX), HEAD(~SEX), 'Alpha',p_alpha);
[H0C,pC]=ttest2(FOOT(SEX),FOOT(~SEX),'Alpha',p_alpha);
[H0D,pD]=ttest2(KOS(SEX),KOS(~SEX),'Alpha',p_alpha);

msm=@(x) [mean(x,'omitnan') std(x,[],1,'omitnan') median(x,'omitnan')];
avrg_high_f=msm(HIGH(SEX)); % ženy mean+-S.D.(median)
avrg_high_m=msm(HIGH(~SEX)); % muži mean+-S.D.(median)

avrg_head_f=msm(HEAD(SEX)); % ženy mean+-S.D.(median)
avrg_head_m=msm(HEAD(~SEX)); % muži mean+-S.D.(median)

avrg_foot_f=msm(FOOT(SEX)); % ženy mean+-S.D.(median)
avrg_foot_m=msm(FOOT(~SEX)); % muži mean+-S.D.(median)

avrg_kos_f=msm(KOS(SEX)); % ženy mean+-S.D.(median)
avrg_kos_m=msm(KOS(~SEX)); % muži mean+-S.D.(median)

p=[pA;pB;pC;pD]+(0.05-p_alpha);
H=[H0A;H0B;H0C;H0D];

mean_m=[avrg_high_m(1);avrg_head_m(1);avrg_foot_m(1);avrg_kos_m(1)];
std_m=[avrg_high_m(2);avrg_head_m(2);avrg_foot_m(2);avrg_kos_m(2)];
med_m=[avrg_high_m(3);avrg_head_m(3);avrg_foot_m(3);avrg_kos_m(3)];

mean_f=[avrg_high_f(1);avrg_head_f(1);avrg_foot_f(1);avrg_kos_f(1)];
std_f=[avrg_high_f(2);avrg_head_f(2);avrg_foot_f(2);avrg_kos_f(2)];
med_f=[avrg_high_f(3);avrg_head_f(3);avrg_foot_f(3);avrg_kos_f(3)];

hyp=["A: Tělesná výška";"B: Obvod hlavy";"C: Velikost obuvy";"D: Studijní průměr"];
labels=["Hypotéza";"mean Muži";"std Muži";"med Muži";"mean Ženy";"std Ženy";"med Ženy";"H_0/H_1";"p+(0.05-p_a)"];
disp(table(hyp,mean_m,std_m,med_m,mean_f,std_f,mean_f,H,p,'VariableNames',labels))

%% Multivarietní analýza

[CC1,pp1]=corr([HIGH,HEAD,FOOT,KOS],'Rows','pairwise');
[CC2,pp2]=corr([HIGH,HEAD,FOOT,KOS],'Type','Spearman','Rows','pairwise');

p_alpha=0.05/(4^2-4); % kolik je kombinancí parametrů?
figure()
subplot(221)
imagesc(CC1); caxis([-1 1]); axis image; colorbar;
title('Pearson correlation')
set(gca,'YTick',1:4,'YTickLabel',{'high','head','foot','kos'})
set(gca,'XTick',1:4,'XTickLabel',{'high','head','foot','kos'})
 
subplot(222)
imagesc(pp1<p_alpha); axis image; c=colorbar; 
set(c,'XTick',[0 1],'XTickLabel',{'false','true'})
title(['p<' num2str(p_alpha) ' (Pearson correlation)'])
set(gca,'YTick',1:4,'YTickLabel',{'high','head','foot','kos'})
set(gca,'XTick',1:4,'XTickLabel',{'high','head','foot','kos'})

subplot(223)
imagesc(CC2); caxis([-1 1]); axis image; colorbar;
title('Spearman correlation')
set(gca,'YTick',1:4,'YTickLabel',{'high','head','foot','kos'})
set(gca,'XTick',1:4,'XTickLabel',{'high','head','foot','kos'})

subplot(224)
imagesc(pp2<p_alpha); axis image; c=colorbar; 
set(c,'XTick',[0 1],'XTickLabel',{'false','true'})
title(['p<' num2str(p_alpha) ' (Spearman correlation)'])
set(gca,'YTick',1:4,'YTickLabel',{'high','head','foot','kos'})
set(gca,'XTick',1:4,'XTickLabel',{'high','head','foot','kos'})
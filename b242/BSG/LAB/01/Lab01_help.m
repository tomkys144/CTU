% DSG - Lab01: Měření a hodnocení doby reakce
% 20. února 2025
% Užitečné funkce: 
% diff, find, iqr, isnan, linspace, load, mean, median, plot, 
% normpdf, hist, ranksum, std, ttest2

clc; clear; close all;

%% Parametry
fs = 500; % vzorkovací frekvence
threshold = 1; % práh pro detekci stisku tlačítka

%% Načtení a zobrazení signálu 1
button_signal1 = load('data/data/01.txt');
button_signal_drift1 = button_signal1(1,1);

secondspersample1 = button_signal1(2,1) - button_signal1(1,1);

start1 = zeros(floor(button_signal_drift1/secondspersample1),1);

button_signal1 = button_signal1(:,2); % pouze signál tlačítka
button_signal1 = [start1;button_signal1];

time_axis1 = linspace(0, (length(button_signal1)-1)/fs, length(button_signal1)); % časová osa

stimuli1 = load('data/markers/01.txt'); % časové značky stimulací

figure(1)
plot(time_axis1, button_signal1); hold on;
plot(stimuli1, 5 * ones(size(stimuli1)), 'rv'); % značení stimulací
xlabel('Cas (s)'); ylabel('Napeti (V)');
legend('Stisk tlacitka', 'Stimul');
xlim([0, max(time_axis1)])

%% Načtení a zobrazení signálu 2

button_signal2 = load('data/data/02.txt');
button_signal_drift2 = button_signal2(1,1);

secondspersample2 = button_signal2(2,1) - button_signal2(1,1);

start2 = zeros(floor(button_signal_drift2/secondspersample2),1);

button_signal2 = button_signal2(:,2); % pouze signál tlačítka
button_signal2 = [start2;button_signal2];

time_axis2 = linspace(0, (length(button_signal2)-1)/fs, length(button_signal2)); % časová osa

stimuli2 = load('data/markers/02.txt'); % časové značky stimulací

figure(2)
plot(time_axis2, button_signal2); hold on;
plot(stimuli2, 5 * ones(size(stimuli2)), 'rv'); % značení stimulací
xlabel('Cas (s)'); ylabel('Napeti (V)');
legend('Stisk tlacitka', 'Stimul');
xlim([0, max(time_axis2)])

%% Detaily stimulů, prahovaného signálu a diference signálu
figure(3)
subplot(3,1,1);
button_pressed1 = button_signal1 > threshold;
diff_signal1 = diff([0; button_pressed1]);

plot(time_axis1, button_signal1); hold on;
plot(stimuli1, 5 * ones(size(stimuli1)), 'rv');
xlim([stimuli1(1)-0.5 stimuli1(3)+0.5]);
title('Detail stimulů a reakcí');
xlabel('Čas (s)'); ylabel('Napětí (V)');

subplot(3,1,2);
plot(time_axis1, button_pressed1);
xlim([stimuli1(1)-0.5 stimuli1(3)+0.5]);
title('Prahovaný signál');

subplot(3,1,3);
plot(time_axis1(1:length(diff_signal1)), diff_signal1);
xlim([stimuli1(1)-0.5 stimuli1(3)+0.5]);
title('Diference signálu');

%%
figure(4)
subplot(3,1,1);
button_pressed2 = button_signal2 > threshold;
diff_signal2 = diff([0; button_pressed2]);

plot(time_axis2, button_signal2); hold on;
plot(stimuli2, 5 * ones(size(stimuli2)), 'rv');
xlim([stimuli2(1)-0.5 stimuli2(3)+0.5]);
title('Detail stimulů a reakcí');
xlabel('Čas (s)'); ylabel('Napětí (V)');

subplot(3,1,2);
plot(time_axis2, button_pressed2);
xlim([stimuli2(1)-0.5 stimuli2(3)+0.5]);
title('Prahovaný signál');

subplot(3,1,3);
plot(time_axis2(1:length(diff_signal2)), diff_signal2);
xlim([stimuli2(1)-0.5 stimuli2(3)+0.5]);
title('Diference signálu');

%% Detekce náběžné hrany (stisk tlačítka)
reaction_indices1 = find(diff_signal1 > 0);
reaction_times1 = time_axis1(reaction_indices1);


reaction_indices2 = find(diff_signal2 > 0);
reaction_times2 = time_axis1(reaction_indices2);
%% Výpočet reakční doby
reaction_durations1 = nan(length(stimuli1),1);
for i = 1:length(stimuli1)
    pos = find(reaction_times1 > stimuli1(i), 1);
    if ~isempty(pos)
        delta = reaction_times1(pos) - stimuli1(i);
        if delta <= 1
            reaction_durations1(i) = delta;
        end
    end
end

reaction_durations2 = nan(length(stimuli2),1);
for i = 1:length(stimuli2)
    pos = find(reaction_times2 > stimuli2(i), 1);
    if ~isempty(pos)
        delta = reaction_times2(pos) - stimuli2(i);
        if delta <= 1
            reaction_durations2(i) = delta;
        end
    end
end
%% Statistická analýza
random_reactions1 = reaction_durations1(1:19);
random_reactions1 = random_reactions1(~isnan(random_reactions1));
random_reactions1 = [random_reactions1; mean(random_reactions1)];
periodic_reactions1 = reaction_durations1(20:39);
periodic_reactions1 = periodic_reactions1(~isnan(periodic_reactions1));

random_reactions2 = reaction_durations2(1:20);
random_reactions2 = random_reactions2(~isnan(random_reactions2));
periodic_reactions2 = reaction_durations2(21:40);
periodic_reactions2 = periodic_reactions2(~isnan(periodic_reactions2));

figure(5)
boxplot([random_reactions1, periodic_reactions1, random_reactions2, periodic_reactions2], 'Labels', {'Nahodna M', 'Periodicka M', 'Nahodna F', 'PeriodickaF'});
% title('Boxplot reakcnich casu');
ylabel('Reakcni cas (s)');

figure(6)
edges = linspace(min([random_reactions1; random_reactions2]), max([random_reactions1; random_reactions2]), 10);
histogram(random_reactions1, 'Normalization', 'pdf', 'BinEdges', edges); hold on;
histogram(random_reactions2, 'Normalization', 'pdf', 'BinEdges', edges);
smooth_edges = linspace(min([random_reactions1; random_reactions2]), max([random_reactions1; random_reactions2]), 100);
pdf1 = normpdf(smooth_edges, mean(random_reactions1), std(random_reactions1));
pdf2 = normpdf(smooth_edges, mean(random_reactions2), std(random_reactions2));
plot(smooth_edges, pdf1, 'b', 'LineWidth', 3);
plot(smooth_edges, pdf2, 'r', 'LineWidth', 3);
% title('Histogram s křivkou normálního rozdělení');
legend('Muz', 'Zena', 'Gauss M', 'Gauss F');
xlabel('Reakcni cas (s)'); ylabel('Pravdepodobnostni hustota');

figure(7)
edges = linspace(min([periodic_reactions1; periodic_reactions2]), max([periodic_reactions1; periodic_reactions2]), 10);
histogram(periodic_reactions1, 'Normalization', 'pdf', 'BinEdges', edges); hold on;
histogram(periodic_reactions2, 'Normalization', 'pdf', 'BinEdges', edges);
smooth_edges = linspace(min([periodic_reactions1; periodic_reactions2]), max([periodic_reactions1; periodic_reactions2]), 100);
pdf1 = normpdf(smooth_edges, mean(periodic_reactions1), std(periodic_reactions1));
pdf2 = normpdf(smooth_edges, mean(periodic_reactions2), std(periodic_reactions2));
plot(smooth_edges, pdf1, 'b', 'LineWidth', 3);
plot(smooth_edges, pdf2, 'r', 'LineWidth', 3);
% title('Histogram s křivkou normálního rozdělení');
legend('Muz', 'Zena', 'Gauss M', 'Gauss F');
xlabel('Reakcni cas (s)'); ylabel('Pravdepodobnostni hustota');

%% Testy normality
[h_shapiro_rand1, p_shapiro_rand1] = swtest(random_reactions1);
[h_shapiro_periodic1, p_shapiro_periodic1] = swtest(periodic_reactions1);

[h_shapiro_rand2, p_shapiro_rand2] = swtest(random_reactions2);
[h_shapiro_periodic2, p_shapiro_periodic2] = swtest(periodic_reactions2);

%% Statistické testy
[h_ttest_rand, p_ttest_rand, ~, stats_rand] = ttest2(random_reactions1, random_reactions2);
[p_utest_rand, h_utest_rand] = ranksum(random_reactions1, random_reactions2);

[h_ttest_per, p_ttest_per, ~, stats_per] = ttest2(periodic_reactions1, periodic_reactions2);
[p_utest_per, h_utest_per] = ranksum(periodic_reactions1, periodic_reactions2);
%% Výpis výsledků
disp('--- VYSLEDKY TESTU ---');
if h_shapiro_rand1 == 0
    disp('Random1: Data mohou být normálně rozdělena.');
else
    disp('Random1: Data nejsou normálně rozdělena.');
end
if h_shapiro_periodic1 == 0
    disp('Periodic1: Data mohou být normálně rozdělena.');
else
    disp('Periodic1: Data nejsou normálně rozdělena.');
end
if h_shapiro_rand2 == 0
    disp('Random2: Data mohou být normálně rozdělena.');
else
    disp('Random2: Data nejsou normálně rozdělena.');
end
if h_shapiro_periodic2 == 0
    disp('Periodic2: Data mohou být normálně rozdělena.');
else
    disp('Periodic2: Data nejsou normálně rozdělena.');
end

disp(['p-hodnota t-testu random: ', num2str(p_ttest_rand)]);
if h_ttest_rand == 1
    disp('T-test random: Statisticky významný rozdíl mezi průměry skupin.');
else
    disp('T-test random: Nebyl nalezen významný rozdíl mezi průměry skupin.');
end

disp(['p-hodnota Mann-Whitney U-testu rand: ', num2str(p_utest_rand)]);
if h_utest_rand == 1
    disp('U-test rand: Statisticky významný rozdíl mezi mediány skupin.');
else
    disp('U-test rand: Nebyl nalezen významný rozdíl mezi mediány skupin.');
end

disp(['p-hodnota t-testu per: ', num2str(p_ttest_per)]);
if h_ttest_per == 1
    disp('T-test per: Statisticky významný rozdíl mezi průměry skupin.');
else
    disp('T-test per: Nebyl nalezen významný rozdíl mezi průměry skupin.');
end

disp(['p-hodnota Mann-Whitney U-testu per: ', num2str(p_utest_per)]);
if h_utest_per == 1
    disp('U-test per: Statisticky významný rozdíl mezi mediány skupin.');
else
    disp('U-test per: Nebyl nalezen významný rozdíl mezi mediány skupin.');
end

%%
clc
mean(periodic_reactions2)
std(periodic_reactions2)
min(periodic_reactions2)
max(periodic_reactions2)

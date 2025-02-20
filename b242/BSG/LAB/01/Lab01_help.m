% DSG - Lab01: Měření a hodnocení doby reakce
% 20. února 2025
% Užitečné funkce: 
% diff, find, iqr, isnan, linspace, load, mean, median, plot, 
% normpdf, hist, ranksum, std, ttest2

clc; clear; close all;

%% Parametry
fs = 500; % vzorkovací frekvence
threshold = 1; % práh pro detekci stisku tlačítka

%% Načtení a zobrazení signálu
button_signal = load('Data_lab01/odezvy_zvuk/odezvy_zvuk01.txt');
button_signal = button_signal(:,2); % pouze signál tlačítka
time_axis = linspace(0, (length(button_signal)-1)/fs, length(button_signal)); % časová osa

stimuli = load('Data_lab01/znacky_zvuk/znacky_zvuk01.txt'); % časové značky stimulací

figure(1)
plot(time_axis, button_signal); hold on;
plot(stimuli, 5 * ones(size(stimuli)), 'rv'); % značení stimulací
xlabel('Cas (s)'); ylabel('Napeti (V)');
title('Signal tlacitka a stimuly');
legend('Stisk tlacitka', 'Stimul');

%% Detaily stimulů, prahovaného signálu a diference signálu
figure(2)
subplot(3,1,1);
button_pressed = button_signal > threshold;
diff_signal = diff([0; button_pressed]);

plot(time_axis, button_signal); hold on;
plot(stimuli, 5 * ones(size(stimuli)), 'rv');
xlim([stimuli(1)-0.5 stimuli(3)+0.5]);
title('Detail stimulů a reakcí');
xlabel('Čas (s)'); ylabel('Napětí (V)');

subplot(3,1,2);
plot(time_axis, button_pressed);
xlim([stimuli(1)-0.5 stimuli(3)+0.5]);
title('Prahovaný signál');

subplot(3,1,3);
plot(time_axis(1:length(diff_signal)), diff_signal);
xlim([stimuli(1)-0.5 stimuli(3)+0.5]);
title('Diference signálu');

%% Detekce náběžné hrany (stisk tlačítka)
reaction_indices = find(diff_signal > 0);
reaction_times = time_axis(reaction_indices);

%% Výpočet reakční doby
reaction_durations = nan(length(stimuli),1);
for i = 1:length(stimuli)
    pos = find(reaction_times > stimuli(i), 1);
    if ~isempty(pos)
        delta = reaction_times(pos) - stimuli(i);
        if delta <= 1
            reaction_durations(i) = delta;
        end
    end
end

%% Statistická analýza
random_reactions = reaction_durations(1:20);
random_reactions = random_reactions(~isnan(random_reactions));
periodic_reactions = reaction_durations(21:40);
periodic_reactions = periodic_reactions(~isnan(periodic_reactions));

figure(3)
boxplot([random_reactions, periodic_reactions], 'Labels', {'Nahodna', 'Periodicka'});
title('Boxplot reakcnich casu');
ylabel('Reakcni cas (s)');

figure(4)
edges = linspace(min([random_reactions; periodic_reactions]), max([random_reactions; periodic_reactions]), 10);
histogram(random_reactions, 'Normalization', 'pdf', 'BinEdges', edges); hold on;
histogram(periodic_reactions, 'Normalization', 'pdf', 'BinEdges', edges);
smooth_edges = linspace(min([random_reactions; periodic_reactions]), max([random_reactions; periodic_reactions]), 100);
rand_pdf = normpdf(smooth_edges, mean(random_reactions), std(random_reactions));
periodic_pdf = normpdf(smooth_edges, mean(periodic_reactions), std(periodic_reactions));
plot(smooth_edges, rand_pdf, 'b', 'LineWidth', 3);
plot(smooth_edges, periodic_pdf, 'r', 'LineWidth', 3);
title('Histogram s křivkou normálního rozdělení');
legend('Nahodna', 'Periodicka', 'Gauss Nahodna', 'Gauss Periodicka');
xlabel('Reakcni cas (s)'); ylabel('Pravdepodobnostni hustota');

%% Testy normality
[h_shapiro_rand, p_shapiro_rand] = swtest(random_reactions);
[h_shapiro_periodic, p_shapiro_periodic] = swtest(periodic_reactions);

%% Statistické testy
[h_ttest, p_ttest] = ttest2(random_reactions, periodic_reactions);
[p_utest, h_utest] = ranksum(random_reactions, periodic_reactions);

%% Výpis výsledků
disp('--- VYSLEDKY TESTU ---');
if h_shapiro_rand == 0
    disp('Random: Data mohou být normálně rozdělena.');
else
    disp('Random: Data nejsou normálně rozdělena.');
end
if h_shapiro_periodic == 0
    disp('Periodic: Data mohou být normálně rozdělena.');
else
    disp('Periodic: Data nejsou normálně rozdělena.');
end

disp(['p-hodnota t-testu: ', num2str(p_ttest)]);
if h_ttest == 1
    disp('T-test: Statisticky významný rozdíl mezi průměry skupin.');
else
    disp('T-test: Nebyl nalezen významný rozdíl mezi průměry skupin.');
end

disp(['p-hodnota Mann-Whitney U-testu: ', num2str(p_utest)]);
if h_utest == 1
    disp('U-test: Statisticky významný rozdíl mezi mediány skupin.');
else
    disp('U-test: Nebyl nalezen významný rozdíl mezi mediány skupin.');
end

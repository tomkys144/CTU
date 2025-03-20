clc
clear all
close all

%% Konstanty

fs = 500;
file_path = 'data/01.txt';

%% Načtení dat

if exist(file_path, 'file') ~= 2
    error('Soubor %s nebyl nalezen.', file_path);
end

data = readtable(file_path, 'ReadVariableNames',true);
if size(data,2) < 2
    error('Nesprávný formát souboru. Očekávány alespoň dva sloupce.');
end

if any(strcmp('tm',data.Properties.VariableNames))
    data.t = data.tm * 60;
    data.tm = [];
end

force = data.Dynamometr;
emg = data.EMG;
t = data.t;

figure('Name', 'Namerena data')
subplot(2,1,1);
plot(t, force, 'LineWidth',2);
xlabel('Čas [s]'); ylabel('Síla [Kg]'); title('Průběh síly stisku');

subplot(2,1,2);
plot(t, emg, 'LineWidth',2);
xlabel('Čas [s]'); ylabel('EMG [mV]'); title('EMG signál');

fontsize(14, "points")

%% Vymezení relevantního segmentu na základě síly stisku

xs = find(force > max(force)*0.8, 1, 'first'); % Začátek segmentu
xe = find(flip(force) > max(force)*0.45, 1, 'first'); % Konec segmentu
xe = numel(force) - xe;

% Výběr relevantních dat
force = force(xs:xe);
emg = emg(xs:xe);
t = t(xs:xe);

figure('Name', 'Vybrana data')
subplot(2,1,1);
plot(t, force, 'LineWidth',2);
xlabel('Čas [s]'); ylabel('Síla [Kg]'); title('Průběh síly stisku');

subplot(2,1,2);
plot(t, emg, 'LineWidth',2);
xlabel('Čas [s]'); ylabel('EMG [mV]'); title('EMG signál');

fontsize(14, "points")

%% Definice segmentace signálu

win = ceil(1 * fs);         % Délka segmentačního okna: 1 sekunda
overlap = ceil(0.5 * win);  % Překryv 50 %
index = 1:win-overlap:length(emg)-win;
t_segments = t(index);      % Časové značky pro segmenty

%% Výpočet parametrů pro každý segment

num_segments = length(index);
SD = zeros(1, num_segments);
P_P = zeros(1, num_segments);
ZCR = zeros(1, num_segments);
fMED = zeros(1, num_segments);
M1 = zeros(1, num_segments);
M2 = zeros(1, num_segments);

for k = 1:num_segments
    emg_seg = emg(index(k):index(k)+win-1);
    force_seg = force(index(k):index(k)+win-1);

    force_mean = mean(force_seg);
    
    % Časové charakteristiky
    SD(k) = std(emg_seg);
    P_P(k) = (max(emg_seg) - min(emg_seg))/force_mean;
    ZCR(k) = sum(abs(diff(sign(emg_seg)))) / 2;
    
    % Spektrální analýza (FFT)
    PSD = (abs(fft(emg_seg)).^2) / win;
    PSD = PSD(1:floor(length(PSD)/2))'; % Pouze první polovina spektra, převod na řádkový vektor
    ff = linspace(0, fs/2, length(PSD)); % Správná frekvenční osa
    
    % Ujistíme se, že PSD a ff mají stejné rozměry
    min_length = min(length(ff), length(PSD));
    ff = ff(1:min_length);
    PSD = PSD(1:min_length);
    
    % Mediánová frekvence (fMED)
    CPSD = cumsum(PSD) / sum(PSD);
    fMED(k) = ff(find(CPSD >= 0.5, 1, 'first'));
    
    % Spektrální momenty (M1 a M2)
    M1(k) = sum(ff .* PSD) / sum(PSD);
    M2(k) = sqrt(sum((ff.^2) .* PSD) / sum(PSD) - (M1(k)^2));
end

figure;
params = {SD, P_P, ZCR, fMED, M1, M2};
titles = {'Směrodatná odchylka', 'Peak-to-peak amplituda', 'Počet průchodů nulou', ...
      'Mediánová frekvence', 'První spektrální moment', 'Druhý spektrální moment'};

for i = 1:6
subplot(3,2,i);
plot(t_segments, params{i}, '.-', 'MarkerSize', 10, 'LineWidth',2); hold on;

% Lineární regrese
p = polyfit(t_segments, params{i}, 1);
y_fit = polyval(p, t_segments);
plot(t_segments, y_fit, 'r-', 'LineWidth', 2);

xlabel('Čas [s]'); title(titles{i});
end
hold off;

fontsize(16,"points")

%% Výpočet korelací parametrů s časem
correlations = zeros(1, 6);
corr_p = zeros(1,6);
for i = 1:6
    [correlations(i), corr_p(i)] = corr(t_segments, params{i}', 'Tail','both');
    fprintf('Korelace %s s časem: %.3f, p=%.3f\n', titles{i}, correlations(i), corr_p(i));
end

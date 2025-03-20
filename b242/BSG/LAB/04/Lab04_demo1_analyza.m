clc; clear; close all;

% Tento demonstrační skript analyzuje samohlásky pomocí spektrogramů a LPC spekter.
% Požadované vstupní soubory: 'a.wav', 'e.wav', 'i.wav', 'o.wav', 'u.wav'.

% Seznam souborů samohlásek
vowel_files = {'demo/a.wav', 'demo/e.wav', 'demo/i.wav', 'demo/o.wav', 'demo/u.wav'};
num_vowels = length(vowel_files);

% Inicializace proměnných
Fs = 8000; % Vzorkovací frekvence
formant_order = 8; % Počet koeficientů pro LPC

%% Načtení signálů
signals = cell(num_vowels,1);
time_vectors = cell(num_vowels,1);
F0_values = zeros(num_vowels, 1);
F = zeros(num_vowels, 4); % Formanty (F1-F4)

for i = 1:num_vowels
    if exist(vowel_files{i}, 'file') == 2
        [x, Fs] = audioread(vowel_files{i});
        x = x(:,1); % Použít pouze první kanál
        signals{i} = x;
        time_vectors{i} = (0:length(x)-1) / Fs;
        
        % Výpočet základní frekvence F0
        F0_values(i) = mean(pitch(x, Fs, 'Method', 'NCF'), 'omitnan');
        
        % Výpočet formantů
        formants = estimateFormants(x, Fs, formant_order);
        F(i, :) = formants;
    else
        error('Soubor %s nebyl nalezen.', vowel_files{i});
    end
end

%% Obrázek 1: Časové průběhy a spektrogramy
figure('Position', [100, 100, 700, 700]); % Posunutí okna níže
colormap('jet');
for i = 1:num_vowels
    subplot(5,2,2*i-1);
    plot(time_vectors{i}, signals{i});
    title(['Časový průběh ', upper(vowel_files{i}(1))]);
    xlabel('Čas [s]'); ylabel('Amplituda'); grid on;
    
    subplot(5,2,2*i); axis tight;
    spectrogram(signals{i}, hamming(256), 128, 512, Fs, 'yaxis');
    title(['Spektrogram ', upper(vowel_files{i}(1))]);
    axis tight;
    colorbar off;
end

%% Obrázek 2: Detailní průběhy a LPC spektra
figure('Position', [200, 100, 700, 700]); % Posunutí okna níže
for i = 1:num_vowels
    mid_idx = round(length(signals{i}) / 2);
    win_length = round(0.1 * Fs);
    idx = mid_idx - win_length/2 : mid_idx + win_length/2;
    idx(idx < 1 | idx > length(signals{i})) = [];
    
    subplot(5,2,2*i-1);
    plot(time_vectors{i}(idx), signals{i}(idx), 'LineWidth', 1.2);
    title(['Detail samohlásky ', upper(vowel_files{i}(1))]);
    xlabel('Čas [s]'); ylabel('Amplituda'); grid on;
    
    [H, w] = computeLPC(signals{i}, Fs, formant_order);
    subplot(5,2,2*i);
    plot(w, 20*log10(abs(H)), 'r', 'LineWidth', 1.5);
    title(['LPC Spektrum ', upper(vowel_files{i}(1))]);
    xlabel('Frekvence [Hz]'); ylabel('PSD [dB]'); grid on;
end

%% Obrázek 3: Rovina F1-F2 s trojúhelníkem A-I-U
figure('Position', [300, 100, 560, 560]);
vowel_labels = {'A', 'E', 'I', 'O', 'U'};
scatter(F(:,1), F(:,2), 100, 'filled');
text(F(:,1), F(:,2), vowel_labels, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'right', 'FontSize', 12);
hold on;
plot(F([1,3,5,1],1), F([1,3,5,1],2), 'k--', 'LineWidth', 1.5);
hold off;
title('Formantová rovina F1-F2');
xlabel('F1 [Hz]'); ylabel('F2 [Hz]'); grid on;
xlim([0 800]); ylim([0 2500]);

%% Obrázek 4: Tabulka analýzy samohlásek
figure('Position', [400, 100, 400, 300]); axis off;
uitable('Data', round([F0_values, F]), 'ColumnName', {'F0', 'F1', 'F2', 'F3', 'F4'}, ...
        'RowName', vowel_labels, 'Position', [20, 20, 500, 200]);
title('Výsledky analýzy samohlásek');

%% funkce

% Funkce pro výpočet LPC spektra
function [H, w] = computeLPC(signal, Fs, order)
    lpc_coeffs = lpc(signal, order);
    H = freqz(1, lpc_coeffs, 1024, Fs);
    w = linspace(0, Fs/2, length(H));
end

% Funkce pro odhad formantů
function formants = estimateFormants(signal, Fs, order)
    lpc_coeffs = lpc(signal, order);
    roots_poly = roots(lpc_coeffs);
    ang_freqs = atan2(imag(roots_poly), real(roots_poly));
    formant_freqs = sort(Fs * ang_freqs / (2 * pi));
    valid_indices = find(formant_freqs > 90 & formant_freqs < 4000);
    formants = formant_freqs(valid_indices(1:min(4, length(valid_indices))));
    formants(end+1:4) = NaN;
end

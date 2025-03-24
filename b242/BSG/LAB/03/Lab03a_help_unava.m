% function analyze_emg_fatigue()
    clear; clc; close all;

    %% Laboratorní úloha č. 3: Měření svalové únavy
    % Analýza únavy na základě EMG signálu a síly stisku dynamometru.

    %% 1. Načtení dat
    data = load('emg_force.txt'); 
    force = data(:,1);  % Síla z dynamometru (kg)
    emg = data(:,2);    % EMG signál (mV)
    fs = 200;          % Vzorkovací frekvence (Hz)

    % Časová osa
    t = (0:length(emg)-1)/fs;

    %% 2. Vymezení relevantního segmentu na základě síly stisku
    xs = find(force > max(force)*0.8, 1, 'first'); % Začátek segmentu
    xe = find(flip(force) > max(force)*0.45, 1, 'first'); % Konec segmentu
    xe = numel(force) - xe;

    % Výběr relevantních dat
    force = force(xs:xe);
    emg = emg(xs:xe);
    t = t(xs:xe);

    %% 3. Vizualizace vstupních signálů
    figure;
    subplot(2,1,1);
    plot(t, force, 'b'); xlabel('Čas [s]'); ylabel('Síla [Kg]'); title('Průběh síly stisku');
    subplot(2,1,2);
    plot(t, emg, 'b'); xlabel('Čas [s]'); ylabel('EMG [mV]'); title('EMG signál');

    %% 4. Definice segmentace signálu
    win = ceil(1 * fs);         % Délka segmentačního okna: 1 sekunda
    overlap = ceil(0.5 * win);  % Překryv 50 %
    index = 1:win-overlap:length(emg)-win;
    t_segments = t(index);      % Časové značky pro segmenty

    %% 5. Inicializace parametrů
    num_segments = length(index);
    SD = zeros(1, num_segments);
    P_P = zeros(1, num_segments);
    ZCR = zeros(1, num_segments);
    fMED = zeros(1, num_segments);
    M1 = zeros(1, num_segments);
    M2 = zeros(1, num_segments);

    %% 6. Výpočet parametrů pro každý segment
    for k = 1:num_segments
        emg_seg = emg(index(k):index(k)+win-1);

        % Časové charakteristiky
        SD(k) = std(emg_seg);
        P_P(k) = max(emg_seg) - min(emg_seg);
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

    %% 7. Vizualizace výsledků s regresní přímkou
    figure;
    params = {SD, P_P, ZCR, fMED, M1, M2};
    titles = {'Směrodatná odchylka', 'Peak-to-peak amplituda', 'Počet průchodů nulou', ...
              'Mediánová frekvence', 'První spektrální moment', 'Druhý spektrální moment'};

    for i = 1:6
        subplot(3,2,i);
        plot(t_segments, params{i}, '.-', 'MarkerSize', 10); hold on;

        % Lineární regrese
        p = polyfit(t_segments, params{i}, 1);
        y_fit = polyval(p, t_segments);
        plot(t_segments, y_fit, 'r-', 'LineWidth', 2);

        xlabel('Čas [s]'); title(titles{i});
    end
    hold off;

    %% 8. Výpočet korelací parametrů s časem
    correlations = zeros(1, 6);
    for i = 1:6
        correlations(i) = corr(t_segments', params{i}');
        fprintf('Korelace %s s časem: %.3f\n', titles{i}, correlations(i));
    end

    %% 9. Interpretace výsledků
    fprintf('\nShrnutí analýzy EMG signálu:\n');
    fprintf('- Mediánová frekvence (f_MED) obvykle klesá s únavou.\n');
    fprintf('- Směrodatná odchylka a peak-to-peak hodnota odrážejí změny variability signálu.\n');
    fprintf('- Druhý spektrální moment M2 informuje o šířce frekvenčního spektra.\n');
    fprintf('- Korelační koeficienty naznačují, které parametry mají nejsilnější vztah s časem.\n');
% end

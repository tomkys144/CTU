% Lab02.m - MATLAB skript pro detekci stimulačních časů a motorických evokovaných odpovědí

clc; clear; close all;

MAX_DELAY_SAM = 100e-3;
MAX_DELAY_VED = 500e-3;

%% Načtení dat
file_path = 'data/03.txt';
if exist(file_path, 'file') ~= 2
    error('Soubor %s nebyl nalezen.', file_path);
end

data = readtable(file_path, 'ReadVariableNames',true);
if size(data,2) < 2
    error('Nesprávný formát souboru. Očekávány alespoň dva sloupce.');
end

fs = 5e3;

figure('Name', 'Namerena data')
subplot(311)
plot(data.t, data.stim);
xlabel('Cas (s)'); ylabel('Signal z tlacitka (-)', 'LineWidth', 2)
title('Signal stimulu')
xlim([5 8])

subplot(312)
plot(data.t, data.EMG_samovolne);
xlabel('Cas (s)'); ylabel('Signal EMG (-)', 'LineWidth', 2)
title('EMG - samovolne reakce')
xlim([5 8])

subplot(313)
plot(data.t, data.EMG_vedome, 'LineWidth', 2);
xlabel('Cas (s)'); ylabel('Signal EMG (-)')
title('EMG - vedome reakce')
xlim([5 8])

fontsize(14,"points")
%% Detekce počátků stimulů
stimulus_threshold = 1;                     % Prahová hodnota (45)
refractory_period = round(500e-3 * fs);       % 10 ms refrakterní fáze

potential_indices = find(diff(data.stim) > 0 & ...
    data.stim(1:end-1) < stimulus_threshold & ...
    data.stim(2:end) >= stimulus_threshold);

stimulus_indices = [];
last_index = -refractory_period;

for idx = potential_indices'
    if idx > last_index + refractory_period
        stimulus_indices = [stimulus_indices; idx];
        last_index = idx;
    end
end

figure('Name', 'Detekce počátků stimulů')
plot(data.t, data.stim, 'LineWidth', 2);
xlabel('Cas (s)'); ylabel('Signal z tlacitka (-)')
hold on
plot(data.t(stimulus_indices), 5 * ones(size(stimulus_indices)), 'rv', 'LineWidth', 2);
hold off
fontsize(14,"points")

%%% Detekce odpovědí v EMG

%% Prahová detekce
threshold = 0.1;
response_indices_prah_sam = [];
response_indices_prah_ved = [];
for i = 1:length(stimulus_indices)
    search_range = stimulus_indices(i):min(stimulus_indices(i) + round(MAX_DELAY_SAM * fs), length(data.EMG_samovolne));
    response_idx = search_range(find(data.EMG_samovolne(search_range) > threshold, 1, 'first'));
    if ~isempty(response_idx)
        response_indices_prah_sam = [response_indices_prah_sam; response_idx];
    else
        response_indices_prah_sam = [response_indices_prah_sam; nan];
    end

    search_range = stimulus_indices(i):min(stimulus_indices(i) + round(MAX_DELAY_VED * fs), length(data.EMG_vedome));
    response_idx = search_range(find(data.EMG_vedome(search_range) > threshold, 1, 'first'));
    if ~isempty(response_idx)
        response_indices_prah_ved = [response_indices_prah_ved; response_idx];
    else
        response_indices_prah_ved = [response_indices_prah_ved; nan];
    end
end

figure('Name', 'Prahova detekce')
subplot(311)
plot(data.t, data.stim);
xlabel('Cas (s)'); ylabel('Signal z tlacitka (-)', 'LineWidth', 2)
title('Signal stimulu')
hold on
plot(data.t(stimulus_indices), 5 * ones(size(stimulus_indices)), 'rv','LineWidth', 2);
hold off

subplot(312)
plot(data.t, data.EMG_samovolne);
xlabel('Cas (s)'); ylabel('Signal EMG (-)', 'LineWidth', 2)
title('EMG - samovolne reakce')
hold on
plot(data.t(response_indices_prah_sam(isfinite(response_indices_prah_sam))), ...
    max(data.EMG_samovolne) * ones(size(response_indices_prah_sam(isfinite(response_indices_prah_sam)))), ...
    'rv', 'LineWidth', 2);
hold off

subplot(313)
plot(data.t, data.EMG_vedome);
xlabel('Cas (s)'); ylabel('Signal EMG (-)', 'LineWidth', 2)
title('EMG - vedome reakce')
hold on
plot(data.t(response_indices_prah_ved(isfinite(response_indices_prah_ved))), ...
    max(data.EMG_vedome) * ones(size(response_indices_prah_ved(isfinite(response_indices_prah_ved)))), ...
    'rv', 'LineWidth', 2);
hold off

fontsize(14, "points")

% Výpočet latencí
if any(isnan(response_indices_prah_sam))
    warning('Počet detekovaných samovolných odpovědí a stimulací se neshoduje.');
end

if any(isnan(response_indices_prah_ved))
    warning('Počet detekovaných vědomých odpovědí a stimulací se neshoduje.');
end

latencies_prah_sam = [(response_indices_prah_sam - stimulus_indices)]' / fs;
mean_latency_prah_sam = mean(latencies_prah_sam, "omitmissing");

latencies_prah_ved = [(response_indices_prah_ved - stimulus_indices)]' / fs;
mean_latency_prah_ved = mean(latencies_prah_ved, "omitmissing");

electrode_distance = 0.65 * 2;                           % Zadejte skutečnou vzdálenost mezi elektrodami v metrech
mean_velocity_prah = electrode_distance / mean_latency_prah_sam;

% Výpis výsledků
% fprintf('Časy počátků stimulů: \n'); disp(t(stimulus_indices)');
% fprintf('Časy počátků odpovědí: \n'); disp(t(response_indices)');
fprintf('Latence [s]: \n'); disp(latencies_prah_sam');

fprintf('\n==== Výsledky detekce ====\n');
fprintf('Počet detekovaných stimulací: %d\n', length(stimulus_indices));
fprintf('Počet detekovaných samovolných odpovědí: %d\n', sum(isfinite(response_indices_prah_sam)));
fprintf('Počet detekovaných vědomých odpovědí: %d\n', sum(isfinite(response_indices_prah_ved)));
fprintf('Průměrná samovolná latence: %.5f s\n', mean_latency_prah_sam);
fprintf('Průměrná vědomá latence: %.5f s\n', mean_latency_prah_ved);
fprintf('Průměrná rychlost vedení nervu: %.2f m/s\n', mean_velocity_prah);
fprintf('===========================\n\n');

%% Detekce odpovědí pomocí výkonové obálky
window_size = round(5e-3 * fs);                           % 5ms klouzavé okno
power_envelope_sam = movmean(abs(data.EMG_samovolne).^2, window_size);
power_envelope_ved = movmean(abs(data.EMG_vedome).^2, window_size);

threshold_env_sam = 0.01 * max(power_envelope_sam);
threshold_env_ved = 0.01 * max(power_envelope_ved);

response_indices_pwr_sam = [];
response_indices_pwr_ved = [];

for i = 1:length(stimulus_indices)
    search_range = stimulus_indices(i):min(stimulus_indices(i) + round(MAX_DELAY_SAM * fs), length(power_envelope_sam));
    response_idx = search_range(find(power_envelope_sam(search_range) > threshold_env_sam, 1, 'first'));
    if ~isempty(response_idx)
        response_indices_pwr_sam = [response_indices_pwr_sam; response_idx];
    else
        response_indices_pwr_sam = [response_indices_pwr_sam; nan];
    end

    search_range = stimulus_indices(i):min(stimulus_indices(i) + round(MAX_DELAY_VED * fs), length(power_envelope_ved));
    response_idx = search_range(find(power_envelope_ved(search_range) > threshold_env_ved, 1, 'first'));
    if ~isempty(response_idx)
        response_indices_pwr_ved = [response_indices_pwr_ved; response_idx];
    else
        response_indices_pwr_ved = [response_indices_pwr_ved; nan];
    end
end

figure('Name', 'Detekce odpovědí pomocí výkonové obálky')
subplot(311)
plot(data.t, data.stim, 'LineWidth', 2);
xlabel('Cas (s)'); ylabel('Signal z tlacitka (-)', 'LineWidth', 2)
title('Signal stimulu')
hold on
plot(data.t(stimulus_indices), 5 * ones(size(stimulus_indices)), 'rv', 'LineWidth', 2);
hold off
xlim([5 8])

subplot(312)
plot(data.t, data.EMG_samovolne, 'LineWidth', 2);
xlabel('Cas (s)'); ylabel('Signal EMG (-)')
title('EMG - samovolne reakce')
hold on
plot(data.t, power_envelope_sam, 'LineWidth', 2);
plot(data.t(response_indices_pwr_sam(isfinite(response_indices_pwr_sam))), ...
    max(power_envelope_sam) * ones(size(response_indices_pwr_sam(isfinite(response_indices_pwr_sam)))), ...
    'rv', 'LineWidth', 2);
hold off
xlim([5 8])

subplot(313)
plot(data.t, data.EMG_vedome, 'LineWidth', 2);
xlabel('Cas (s)'); ylabel('Signal EMG (-)')
title('EMG - vedome reakce')
hold on
plot(data.t, power_envelope_ved, 'LineWidth', 2);
plot(data.t(response_indices_pwr_ved(isfinite(response_indices_pwr_ved))), ...
    max(power_envelope_ved) * ones(size(response_indices_pwr_ved(isfinite(response_indices_pwr_ved)))), ...
    'rv', 'LineWidth', 2);
hold off
xlim([5 8])

fontsize(14, "points")

% Výpočet latencí
if any(isnan(response_indices_pwr_sam))
    warning('Počet detekovaných samovolných odpovědí a stimulací se neshoduje.');
end

if any(isnan(response_indices_pwr_ved))
    warning('Počet detekovaných vědomých odpovědí a stimulací se neshoduje.');
end

latencies_pwr_sam = [(response_indices_pwr_sam - stimulus_indices)]' / fs;
mean_latency_pwr_sam = mean(latencies_pwr_sam, "omitmissing");

latencies_pwr_ved = [(response_indices_pwr_ved - stimulus_indices)]' / fs;
mean_latency_pwr_ved = mean(latencies_pwr_ved, "omitmissing");

electrode_distance = 0.65 * 2;                           % Zadejte skutečnou vzdálenost mezi elektrodami v metrech
mean_velocity_pwr = electrode_distance / mean_latency_pwr_sam;

% Výpis výsledků
% fprintf('Časy počátků stimulů: \n'); disp(t(stimulus_indices)');
% fprintf('Časy počátků odpovědí: \n'); disp(t(response_indices)');
fprintf('Latence [s]: \n'); disp(latencies_pwr_sam');

fprintf('\n==== Výsledky detekce ====\n');
fprintf('Počet detekovaných stimulací: %d\n', length(stimulus_indices));
fprintf('Počet detekovaných samovolných odpovědí: %d\n', sum(isfinite(response_indices_pwr_sam)));
fprintf('Počet detekovaných vědomých odpovědí: %d\n', sum(isfinite(response_indices_pwr_ved)));
fprintf('Průměrná samovolná latence: %.5f s\n', mean_latency_pwr_sam);
fprintf('Průměrná vědomá latence: %.5f s\n', mean_latency_pwr_ved);
fprintf('Průměrná rychlost vedení nervu: %.2f m/s\n', mean_velocity_pwr);
fprintf('===========================\n\n');


%% Trojúhelníková metoda detekce odpovědí
response_indices_tri_sam = [];
response_indices_tri_ved = [];

for i = 1:length(stimulus_indices)
    segment = data.EMG_samovolne(stimulus_indices(i):min(stimulus_indices(i) ...
        + round(MAX_DELAY_SAM * fs), length(data.EMG_samovolne)));
    [amp, lmax] = findpeaks(abs(segment)); % Lokální maxima
    lmax = lmax(amp > 0.05 * max(abs(segment))); % Maxima nad 5 % maxima MEP
    if isempty(lmax)
        continue; % Přeskakujeme, pokud není platné maximum
    end
    lmax = lmax(1); % První maximum

    % Trojúhelníková metoda
    ax = 1; ay = abs(segment(1));       % Vrchol A
    cx = lmax; cy = abs(segment(lmax)); % Vrchol C
    S = [];
    for k = 1:lmax
        bx = k; by = abs(segment(k));
        S = [S, 0.5 * abs((cx - ax) * (by - ay) - (cy - ay) * (bx - ax))];
    end
    [~, bx_max] = max(S);
    response_indices_tri_sam = [response_indices_tri_sam; stimulus_indices(i) + bx_max];
end

for i = 1:length(stimulus_indices)
    segment = data.EMG_vedome(stimulus_indices(i):min(stimulus_indices(i) ...
        + round(MAX_DELAY_VED * fs), length(data.EMG_vedome)));
    [amp, lmax] = findpeaks(abs(segment)); % Lokální maxima
    lmax = lmax(amp > 0.05 * max(abs(segment))); % Maxima nad 5 % maxima MEP
    if isempty(lmax)
        response_indices_tri_ved = [response_indices_tri_ved; nan];
        continue; % Přeskakujeme, pokud není platné maximum
    end
    lmax = lmax(1); % První maximum

    % Trojúhelníková metoda
    ax = 1; ay = abs(segment(1));       % Vrchol A
    cx = lmax; cy = abs(segment(lmax)); % Vrchol C
    S = [];
    for k = 1:lmax
        bx = k; by = abs(segment(k));
        S = [S, 0.5 * abs((cx - ax) * (by - ay) - (cy - ay) * (bx - ax))];
    end
    [~, bx_max] = max(S);
    response_indices_tri_ved = [response_indices_tri_ved; stimulus_indices(i) + bx_max];
end

figure('Name', 'Trojúhelníková metoda detekce odpovědí')
subplot(311)
plot(data.t, data.stim, 'LineWidth', 2);
xlabel('Cas (s)'); ylabel('Signal z tlacitka (-)')
title('Signal stimulu')
hold on
plot(data.t(stimulus_indices), 5 * ones(size(stimulus_indices)), 'rv', 'LineWidth', 2);
hold off

subplot(312)
plot(data.t, data.EMG_samovolne, 'LineWidth', 2);
xlabel('Cas (s)'); ylabel('Signal EMG (-)')
title('EMG - samovolne reakce')
hold on
plot(data.t(response_indices_tri_sam(isfinite(response_indices_tri_sam))), ...
    max(data.EMG_samovolne) * ones(size(response_indices_tri_sam(isfinite(response_indices_tri_sam)))), ...
    'rv', 'LineWidth', 2);
hold off

subplot(313)
plot(data.t, data.EMG_vedome, 'LineWidth', 2);
xlabel('Cas (s)'); ylabel('Signal EMG (-)')
title('EMG - vedome reakce')
hold on
plot(data.t(response_indices_tri_ved(isfinite(response_indices_tri_ved))), ...
    max(data.EMG_vedome) * ones(size(response_indices_tri_ved(isfinite(response_indices_tri_ved)))), ...
    'rv', 'LineWidth', 2);
hold off

fontsize(14,"points")

% Výpočet latencí
if any(isnan(response_indices_tri_sam))
    warning('Počet detekovaných samovolných odpovědí a stimulací se neshoduje.');
end

if any(isnan(response_indices_tri_ved))
    warning('Počet detekovaných vědomých odpovědí a stimulací se neshoduje.');
end

latencies_tri_sam = [(response_indices_tri_sam - stimulus_indices)]' / fs;
mean_latency_tri_sam = mean(latencies_tri_sam, "omitmissing");

latencies_tri_ved = [(response_indices_tri_ved - stimulus_indices)]' / fs;
mean_latency_tri_ved = mean(latencies_tri_ved, "omitmissing");

electrode_distance = 0.65 * 2;                           % Zadejte skutečnou vzdálenost mezi elektrodami v metrech
mean_velocity_tri = electrode_distance / mean_latency_tri_sam;

% Výpis výsledků
% fprintf('Časy počátků stimulů: \n'); disp(t(stimulus_indices)');
% fprintf('Časy počátků odpovědí: \n'); disp(t(response_indices)');
fprintf('Latence [s]: \n'); disp(latencies_tri_sam');

fprintf('\n==== Výsledky detekce ====\n');
fprintf('Počet detekovaných stimulací: %d\n', length(stimulus_indices));
fprintf('Počet detekovaných samovolných odpovědí: %d\n', sum(isfinite(response_indices_tri_sam)));
fprintf('Počet detekovaných vědomých odpovědí: %d\n', sum(isfinite(response_indices_tri_ved)));
fprintf('Průměrná samovolná latence: %.5f s\n', mean_latency_tri_sam);
fprintf('Průměrná vědomá latence: %.5f s\n', mean_latency_tri_ved);
fprintf('Průměrná rychlost vedení nervu: %.2f m/s\n', mean_velocity_tri);
fprintf('===========================\n\n');

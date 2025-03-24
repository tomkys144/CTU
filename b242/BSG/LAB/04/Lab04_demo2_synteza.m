clc; clear; close all;

% Tento demonstrační skript syntetizuje samohlásky na základě pevně
% zadaných formantových frekvencí a šířek pásem. Umožňuje výběr samohlásky,
% délky signálu a typu buzení.
fs = 8000; % Vzorkovací frekvence
vowel_names = {'A', 'E', 'I', 'O', 'U'};

% Formantové frekvence pro jednotlivé samohlásky [F1 F2 F3 F4]
F = [
    597  1036  2852  4000;  % A
    508  1752  2604  4000;  % E
    244  2092  3037  4000;  % I
    386  728   2772  4000;  % O
    237  529   2603  3196   % U
];

% Šířky pásem pro všechny formanty [BW1 BW2 BW3 BW4]
B = [90  110  170  250];

while true
    % Nabídka pro výběr parametrů syntézy
    [vowel_idx, ok] = listdlg('PromptString', 'Vyberte syntetickou samohlásku:', 'SelectionMode', 'single', 'ListString', vowel_names);
    if ~ok, break; end

    dur = inputdlg('Zadejte délku samohlásky (s):', 'Délka', [1 35], {'0.5'});
    dur = str2double(dur);
    if isnan(dur) || dur <= 0, break; end

    [buzz_type, ok] = listdlg('PromptString', 'Vyberte typ buzení:', 'SelectionMode', 'single', 'ListString', {'Bílý šum', 'Pulsy', 'Rosenbergovy pulsy'});
    if ~ok, break; end

    if buzz_type ~= 1  % F0 pouze pro pulsy a Rosenbergovy pulsy
    f0_input = inputdlg('Zadejte základní frekvenci F0 (Hz):', 'Frekvence F0', [1 35], {'100'});
    f0 = str2double(f0_input);
    if isnan(f0) || f0 <= 0, break; end
else
    f0 = NaN; % Neaplikovatelné pro bílý šum
end % Implicitní základní frekvence pro pulsy

    % Generování syntetizovaného signálu
    y = synthesizeVowel(F(vowel_idx, :), B, fs, dur, f0, buzz_type);

    % Přehrání zvuku
    soundsc(y, fs);

    % Zobrazení výsledků
    figure('Position', [300, 100, 600, 400]);
    subplot(2,1,1);
    plot((0:length(y)-1)/fs, y);
    title(['Časový průběh samohlásky ', vowel_names{vowel_idx}]);
    xlabel('Čas [s]'); ylabel('Amplituda'); grid on;

    subplot(2,1,2);
    spectrogram(y, hamming(256), 128, 512, fs, 'yaxis');
    title(['Spektrogram samohlásky ', vowel_names{vowel_idx}]);
    colorbar;
end

% Funkce pro syntézu samohlásky pomocí formantových filtrů
function y = synthesizeVowel(F, BW, fs, dur, f0, buzz_type)
    N = round(dur * fs);
    switch buzz_type
        case 1 % Bílý šum
            excitation = randn(N, 1);
        case 2 % Pulsy
            excitation = pulstran(0:1/fs:dur-1/fs, (0:1/f0:dur), 'rectpuls', 1/fs);
        case 3 % Rosenbergovy pulsy
            excitation = rosenbergPulseTrain(N, fs, f0);
    end
    
    y = excitation;
    for k = 1:4
        R = 1 - BW(k) * pi / fs;
        pp = R * exp(1j * 2 * pi * F(k) / fs);
        pn = R * exp(-1j * 2 * pi * F(k) / fs);
        [b, a] = zp2tf(0, [pp; pn], 1);
        y = filter(b, a, y);
    end
end

% Funkce pro generování Rosenbergových pulsů
function excitation = rosenbergPulseTrain(N, fs, f0)
    T0 = 1/f0;
    t = (0:N-1)/fs;
    pulse = [linspace(0,1,round(0.4*T0*fs)), linspace(1,0,round(0.6*T0*fs))];
    pulse = [pulse zeros(1, round(T0*fs) - length(pulse))];
    excitation = repmat(pulse, 1, ceil(N/length(pulse)));
    excitation = excitation(1:N)';
end

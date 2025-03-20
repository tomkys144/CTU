clc; clear; close all;

% 1. Načtení připraveného wavu
[file, fs] = audioread('rozsah.wav');
time = (0:length(file)-1)/fs;

% 2. LPC analýza pro získání reziduálního signálu
formant_order = 16;
lpc_coeffs = lpc(file, formant_order);
residual_signal = filter(lpc_coeffs, 1, file);

% Filtrace chybového signálu
f0 = 200;               % Filtrace hlasivkového tónu
B0 = 100;
R0 = 1 - B0 * pi / fs;  
Fg = 1500;
Bg = 3500;
Rg = 1 - Bg * pi / fs;
[b0, a0] = zp2tf([Rg*exp(1j*2*pi*Fg/fs); Rg*exp(-1j*2*pi*Fg/fs); 1], [R0; R0], 1);
residual_signal = filter(b0, a0, residual_signal);


% 3. Výběr cílové samohlásky
vowel_names = {'A', 'E', 'I', 'O', 'U'};
vowel_index = menu('Vyberte cílovou samohlásku:', vowel_names);

% Formanty a šířky pásma
F = [
    597  1036  2852  4000;  % A
    508  1752  2604  4000;  % E
    244  2092  3037  4000;  % I
    386  728   2772  4000;  % O
    237  529   2603  3196   % U
];
 
BW = [90  110  170  250;
      90  110  170  250;
      90  110  170  250;
      90  110  170  250;
      90  110  170  250];
  
F_selected = F(vowel_index, :);
BW_selected = BW(vowel_index, :);

% 4. Syntéza pomocí Klattova syntezátoru
y = residual_signal;
for k = 1:4
    R = 1 - BW_selected(k) * pi / fs;
    pp = R * exp(1j * 2 * pi * F_selected(k) / fs);
    pn = R * exp(-1j * 2 * pi * F_selected(k) / fs);
    [b, a] = zp2tf(0, [pp; pn], 1);
    y = filter(b, a, y);
end

% Přehrání syntetizovaného signálu
soundsc(y, fs);

% Vykreslení výsledků

time_residual = (0:length(residual_signal)-1)/fs;
subplot(3,1,1);
plot(time_residual, residual_signal);
title('Reziduální signál'); xlabel('Čas [s]'); ylabel('Amplituda');

subplot(3,1,2);
time_synth = (0:length(y)-1)/fs;
plot(time_synth, y);
title(['Syntetizovaná samohláska ', vowel_names{vowel_index}]);
xlabel('Čas [s]'); ylabel('Amplituda');
grid on;

subplot(3,1,3);
    time_synth = (0:length(y)-1)/fs;
    subplot(3,1,3);
    [S, F, T, P] = spectrogram(y, hamming(256), 128, 512, fs, 'yaxis');
    imagesc(T, F, 10*log10(P)); axis xy; colormap jet;
    xlabel('Čas [s]'); ylabel('Frekvence [Hz]');
    ylim([0 4000]); % Spektrogram zobrazující formanty do 4 kHz
    title(['Spektrum syntetizované samohlásky ', vowel_names{vowel_index}]);
    xlabel('Čas [s]'); ylabel('Amplituda'); grid on;

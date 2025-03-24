clc; clear; close all;

signal = loadbin('SA001S01.CS0');

% Nastavení parametrů
fs = 16000; % vzorkovací frekvence
N = 3; % počet úrovní banky filtrů
n_bands = 2^N; % počet pásem banky filtrů


% Navržení prototypového filtru
b0 = [ -0.0059, 0.0129, 0.0013, -0.0274, 0.0086, 0.0510, -0.0338, -0.1001, 0.1243, 0.4688, 0.4688, 0.1243, -0.1001, -0.0338, 0.0510, 0.0086, -0.0274, 0.0013, 0.0129, -0.0059 ] ;
lag = (n_bands-1)*(length(b0)-1);

% Rozklad 
% inicializace
bands = DWT_filt(signal,b0);

for i = 2:N
    %current number of band_mtx columns
    col = size(bands,2);
    band_n_stage = [];
    for j = 1:col
        band_n_stage = [band_n_stage, DWT_split(bands(:,j),b0)];
    end
    bands = band_n_stage;
end

figure;
for i = 1:n_bands
    subplot(n_bands,1,i);
    plot(bands(:,i));
    title(['DWT koeficient ' num2str(i-1)]);
end

% Syntéza
band_n_stage = bands;
for i = 1:N
    col = size(band_n_stage,2);
    band_n_minus_stage = [];
    for j = 1:2:col
        sig_lp = band_n_stage(:,j);
        sig_hp = band_n_stage(:,j+1);

        % interpolace
        lp_interp=zeros(2*size(band_n_stage,1),1) ;
        hp_interp=zeros(2*size(band_n_stage,1),1) ;
    
        lp_interp(1:2:end)=sig_lp;
        hp_interp(1:2:end)=sig_hp;

        % koeficienty horní propusti
        b1 = b0;
        b1(2:2:end) = -b1(2:2:end);

        %filtration of signal after interpolation
        sig_lp = filter(b0,1,lp_interp);
        sig_hp = filter(b1,1,hp_interp);
        
        %addition of the signals
        sig_combined = (sig_lp+sig_hp)*2;
        band_n_minus_stage = [band_n_minus_stage, sig_combined];
    end
    band_n_stage = band_n_minus_stage;
end
synthetized = band_n_stage;
synthetized = synthetized(lag:end);
signal = signal(1:length(synthetized));
% Výpočet chybového signálu
error_signal = signal - synthetized;

% Výpočet SNR_e
Ps = sum(signal.^2); % výkon původního signálu
Pe = sum(error_signal.^2); % výkon chybového signálu
SNR_e = 10*log10(Ps/Pe);

figure;

subplot(211);
plot(signal);
title(['Původní signál vs signál po zpětné syntéze,' ' zpoždění ' num2str(lag) ' vzorků']);
hold on;
plot(synthetized,'r--');
hold off;
legend('Původní signál','Signál po zpětné syntéze');

subplot(212);
plot(error_signal);
title(['Chybový signál, SNR_e = ' num2str(SNR_e) ' dB']);


function bands = DWT_filt(signal, b0)
    
    b1 = b0;
    % koeficienty horní propusti
    b1(2:2:end) = -b1(2:2:end);

    % filtrování horní a dolní propustí
    decomposition_lp = filter(b0, 1, signal);
    decomposition_hp = filter(b1, 1, signal);
    
    
    % decimace na polovinu vzorků
    decomposition_lp = decomposition_lp(1:2:end);
    decomposition_hp = decomposition_hp(1:2:end);
    
    bands = [decomposition_lp, decomposition_hp];
end

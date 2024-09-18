function [envelope1, reduced_signal1, envelope2, reduced_signal2] = shimmer(channel1, channel2, fs_shimmer, plot_progress)
    %SHIMMER Summary of this function goes here
    %   Detailed explanation goes here
    channel1 = channel1 - channel1(1);
    channel2 = channel2 - channel2(2);

    if plot_progress
        figure('Name', 'Shimmer raw data')
        plot(channel1)
        hold on
        plot(channel2)
        legend('Channel 1', 'Channel2')
%         title('raw data')
    end

    % 1. KROK Filtrování - BAND PASS FILTER
    high_pass_freq = 20;
    low_pass_freq = 120;

    [b, a] = butter(6, [high_pass_freq / fs_shimmer * 2 ...
        low_pass_freq / fs_shimmer * 2]);

    channel1_bp = filter(b, a, channel1);
    channel2_bp = filter(b, a, channel2);

    if plot_progress
        figure('Name', 'Shimmer band pass')
        plot(channel1_bp)
        hold on
        plot(channel2_bp)
        legend('Channel 1', 'Channel2')
%         title('band pass')
    end

    figure(Name='BP')
    freqz(b,a, 5000, "half", fs_shimmer);
    ylim([-300, 10])

    % 2.KROK absolutni hodnota
    channel1_abs = abs(channel1_bp);
    channel2_abs = abs(channel2_bp);

    if plot_progress
        figure('Name', 'Shimmer absolute value')
        plot(channel1_abs)
        hold on
        plot(channel2_abs)
        legend('Channel 1', 'Channel2')
%         title('absolute value')
    end

    % 3.KROK low pass
    [b2, a2] = butter(6, 5 / fs_shimmer * 2);

    %envelope1 = filter(b2, a2, channel1_abs);
    %envelope2 = filter(b2, a2, channel2_abs);
    
    %% TODO: NEW OPERATION MEAN
    
    envelope1=channel1_abs;
    envelope2=channel2_abs;
    
    % 4. KROK RMS
    signal_1 = envelope1;
    num_samples = length(signal_1);
    reduced_signal1 = arrayfun(@(i) ...
        rms(signal_1(i:min(i + fs_shimmer - 1, num_samples))), ...
        1:fs_shimmer:num_samples)';

    signal_2 = envelope2;
    num_samples = length(signal_2);
    reduced_signal2 = arrayfun(@(i) ...
        rms(signal_2(i:min(i + fs_shimmer - 1, num_samples))), ...
        1:fs_shimmer:num_samples)';
end

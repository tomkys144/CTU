clear all;
close all;

%%% Data files
geta_file = 'Míra_pokus.xlsx';
shimmer_file1 = 'mira/2023_11_10_channel_13.csv'; %right
shimmer_file2 = 'mira/2023_11_10_channel_10.csv'; %left

%%% Metadata
ffig = strsplit(shimmer_file1, '/');
ffig = ffig(1);

fs_shimmer = 256;
fs_geta = 1;

mat_name = strcat([ffig{1} '_fmax.mat']);

%% Reading data

% geta
tab = readtable(geta_file);

e1 = table2array(tab(:, 2));
e2 = table2array(tab(:, 4));
e3 = table2array(tab(:, 6));
e4 = table2array(tab(:, 8));

mm = table2array(tab(:, 10));

% shimmer
data1 = readtable(shimmer_file1);
data2 = readtable(shimmer_file2);

channel1 = table2array(data1(:, 18));
channel2 = table2array(data1(:, 20));
channel3 = table2array(data2(:, 18));
channel4 = table2array(data2(:, 20));

m = zeros([1 length(mm)]);

for k = 1:length(mm)

    if ~isempty(mm{k})
        m(k) = 1;
    end

end

mx = find(m);
mx0 = [1 mx];

%% resampling
e1_256 = resample(e1, fs_shimmer, fs_geta);
e2_256 = resample(e2, fs_shimmer, fs_geta);
e3_256 = resample(e3, fs_shimmer, fs_geta);
e4_256 = resample(e4, fs_shimmer, fs_geta);

mx_256 = mx * 256;
mx0_256 = [1 mx_256];

%% shimmer procesing

[channel1_env, channel1_reduced, channel2_env, channel2_reduced] = shimmer(channel1, channel2, fs_shimmer, false);
[channel3_env, channel3_reduced, channel4_env, channel4_reduced] = shimmer(channel3, channel4, fs_shimmer, false);

%% sync signals

[channel1_al, e1_256_al, delay1_256] = alignsignals(channel1_env, e1_256, 'Method', 'xcorr');
[channel2_al, e2_256_al, delay2_256] = alignsignals(channel2_env, e2_256, 'Method', 'xcorr');
[channel3_al, e3_256_al, delay3_256] = alignsignals(channel3_env, e3_256, 'Method', 'xcorr');
[channel4_al, e4_256_al, delay4_256] = alignsignals(channel4_env, e4_256, 'Method', 'xcorr');

fig1 = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Aligned signals 256 Hz');
subplot(221)
plot(channel1_al / max(channel1_al));
hold on
plot(e1_256_al / max(e1_256_al))
plot_markers(mx_256, 1)
legend('Shimmer', 'Geta')
title('Channel 1')

subplot(222)
plot(channel2_al / max(channel2_al));
hold on
plot(e2_256_al / max(e2_256_al))
plot_markers(mx_256, 1)
legend('Shimmer', 'Geta')
title('Channel 2')

subplot(223)
plot(channel3_al / max(channel3_al));
hold on
plot(e3_256_al / max(e3_256_al))
plot_markers(mx_256, 1)
legend('Shimmer', 'Geta')
title('Channel 3')

subplot(224)
plot(channel4_al / max(channel4_al));
hold on
plot(e4_256_al / max(e4_256_al))
plot_markers(mx_256, 1)
legend('Shimmer', 'Geta')
title('Channel 4')

sgtitle('Aligned signals scaled to 1 (fs=256 Hz)')

% %%% FMAX
if ~exist('fmax_e1', 'var')

    if exist(mat_name, 'file')
        load(mat_name);
    end

    if ~exist('fmax_e1', 'var')
        sgtitle('Select fmax range')
        [x, ~] = ginput();
        x = x + 1;

        e1_fmax_range = [];
        e2_fmax_range = [];
        e3_fmax_range = [];
        e4_fmax_range = [];
        channel1_fmax_range = [];
        channel2_fmax_range = [];
        channel3_fmax_range = [];
        channel4_fmax_range = [];

        for i = 1:length(mx_256)

            if any(and(x >= mx0_256(i), x <= mx0_256(i + 1)))
                e1_fmax_range = [e1_fmax_range; e1_256_al(mx0_256(i):mx0_256(i + 1))];
                e2_fmax_range = [e2_fmax_range; e2_256_al(mx0_256(i):mx0_256(i + 1))];
                e3_fmax_range = [e3_fmax_range; e3_256_al(mx0_256(i):mx0_256(i + 1))];
                e4_fmax_range = [e4_fmax_range; e4_256_al(mx0_256(i):mx0_256(i + 1))];
                channel1_fmax_range = [channel1_fmax_range; channel1_al(mx0_256(i):mx0_256(i + 1))];
                channel2_fmax_range = [channel2_fmax_range; channel2_al(mx0_256(i):mx0_256(i + 1))];
                channel3_fmax_range = [channel3_fmax_range; channel3_al(mx0_256(i):mx0_256(i + 1))];
                channel4_fmax_range = [channel4_fmax_range; channel4_al(mx0_256(i):mx0_256(i + 1))];
            end

        end

        if any(x >= mx0_256(end))
            e1_fmax_range = [e1_fmax_range; e1_256_al(mx0_256(end):end)];
            e2_fmax_range = [e2_fmax_range; e2_256_al(mx0_256(end):end)];
            e3_fmax_range = [e3_fmax_range; e3_256_al(mx0_256(end):end)];
            e4_fmax_range = [e4_fmax_range; e4_256_al(mx0_256(end):end)];
            channel1_fmax_range = [channel1_fmax_range; channel1_al(mx0_256(end):end)];
            channel2_fmax_range = [channel2_fmax_range; channel2_al(mx0_256(end):end)];
            channel3_fmax_range = [channel3_fmax_range; channel3_al(mx0_256(end):end)];
            channel4_fmax_range = [channel4_fmax_range; channel4_al(mx0_256(end):end)];
        end

        fmax_e1 = max(e1_fmax_range) * 0.95;
        fmax_e2 = max(e2_fmax_range) * 0.95;
        fmax_e3 = max(e3_fmax_range) * 0.95;
        fmax_e4 = max(e4_fmax_range) * 0.95;
        fmax_channel1 = max(channel1_fmax_range) * 0.95;
        fmax_channel2 = max(channel2_fmax_range) * 0.95;
        fmax_channel3 = max(channel3_fmax_range) * 0.95;
        fmax_channel4 = max(channel4_fmax_range) * 0.95;

        if exist(mat_name, 'dir')
            save(mat_name, 'fmax_e1', 'fmax_e2', 'fmax_e3', 'fmax_e4', 'fmax_channel1', 'fmax_channel2', 'fmax_channel3', 'fmax_channel4', '-append');
        else
            save(mat_name, 'fmax_e1', 'fmax_e2', 'fmax_e3', 'fmax_e4', 'fmax_channel1', 'fmax_channel2', 'fmax_channel3', 'fmax_channel4');
        end

    end

end

clf
subplot(221)
plot(channel1_al / max(channel1_al));
hold on
plot(e1_256_al / max(e1_256_al))
line([0 length(channel1_al)], [1 1] * fmax_channel1 / max(channel1_al));
line([0 length(e1_256_al)], [1 1] * fmax_e1 / max(e1_256_al));
plot_markers(mx_256, 1)
legend('Shimmer', 'Geta', 'Fmax Shimmer', 'Fmax Geta')
title('Channel 1')

subplot(222)
plot(channel2_al / max(channel2_al));
hold on
plot(e2_256_al / max(e2_256_al))
line([0 length(channel2_al)], [1 1] * fmax_channel2 / max(channel2_al));
line([0 length(e2_256_al)], [1 1] * fmax_e2 / max(e2_256_al));
plot_markers(mx_256, 1)
legend('Shimmer', 'Geta', 'Fmax Shimmer', 'Fmax Geta')
title('Channel 2')

subplot(223)
plot(channel3_al / max(channel3_al));
hold on
plot(e3_256_al / max(e3_256_al))
line([0 length(channel3_al)], [1 1] * fmax_channel3 / max(channel3_al));
line([0 length(e3_256_al)], [1 1] * fmax_e3 / max(e3_256_al));
plot_markers(mx_256, 1)
legend('Shimmer', 'Geta', 'Fmax Shimmer', 'Fmax Geta')
title('Channel 3')

subplot(224)
plot(channel4_al / max(channel4_al));
hold on
plot(e4_256_al / max(e4_256_al))
line([0 length(channel4_al)], [1 1] * fmax_channel4 / max(channel4_al));
line([0 length(e4_256_al)], [1 1] * fmax_e4 / max(e4_256_al));
plot_markers(mx_256, 1)
legend('Shimmer', 'Geta', 'Fmax Shimmer', 'Fmax Geta')
title('Channel 4')

%%% Select data
sgtitle('Select calclulations ranges')
[x, ~] = ginput();
x = x + 1;

e1_selected = [];
e2_selected = [];
e3_selected = [];
e4_selected = [];
channel1_selected = [];
channel2_selected = [];
channel3_selected = [];
channel4_selected = [];

for i = 1:length(mx_256)

    if any(and(x >= mx0_256(i), x <= mx0_256(i + 1)))
        e1_selected = [e1_selected; e1_256_al(mx0_256(i):mx0_256(i + 1))];
        e2_selected = [e2_selected; e2_256_al(mx0_256(i):mx0_256(i + 1))];
        e3_selected = [e3_selected; e3_256_al(mx0_256(i):mx0_256(i + 1))];
        e4_selected = [e4_selected; e4_256_al(mx0_256(i):mx0_256(i + 1))];
        channel1_selected = [channel1_selected; channel1_al(mx0_256(i):mx0_256(i + 1))];
        channel2_selected = [channel2_selected; channel2_al(mx0_256(i):mx0_256(i + 1))];
        channel3_selected = [channel3_selected; channel3_al(mx0_256(i):mx0_256(i + 1))];
        channel4_selected = [channel4_selected; channel4_al(mx0_256(i):mx0_256(i + 1))];
    end

end

if any(x >= mx0(end))
    e1_selected = [e1_selected; e1_256_al(mx0_256(end):end)];
    e2_selected = [e2_selected; e2_256_al(mx0_256(end):end)];
    e3_selected = [e3_selected; e3_256_al(mx0_256(end):end)];
    e4_selected = [e4_selected; e4_256_al(mx0_256(end):end)];
    channel1_selected = [channel1_selected; channel1_al(mx0_256(end):end)];
    channel2_selected = [channel2_selected; channel2_al(mx0_256(end):end)];
    channel3_selected = [channel3_selected; channel3_al(mx0_256(end):end)];
    channel4_selected = [channel4_selected; channel4_al(mx0_256(end):end)];
end

%%% save figure
sgtitle('Aligned signals scaled to 1 (fs=256 Hz)')
saveas(fig1, [ffig{1}, '_fs256', '.png'])

%%% calculate histogram
gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms shimmer');

subplot(221)
[wanted, bins] = calculate_histogram(channel1_selected, fmax_channel1);

bar(wanted, bins);
title('Shimmer channel 1')

subplot(222)
[wanted, bins] = calculate_histogram(channel2_selected, fmax_channel2);

bar(wanted, bins);
title('Shimmer channel 2')

subplot(223)
[wanted, bins] = calculate_histogram(channel3_selected, fmax_channel3);

bar(wanted, bins);
title('Shimmer channel 3')

subplot(224)
[wanted, bins] = calculate_histogram(channel4_selected, fmax_channel4);

bar(wanted, bins);
title('Shimmer channel 4')

saveas(gcf, [ffig{1} '_shimmer_hist_fs256' '.png'])

gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms geta');

subplot(221)
[wanted, bins] = calculate_histogram(e1_selected, fmax_e1);

bar(wanted, bins);
title('GETA channel 1')

subplot(222)
[wanted, bins] = calculate_histogram(e2_selected, fmax_e2);

bar(wanted, bins);
title('GETA channel 2')

subplot(223)
[wanted, bins] = calculate_histogram(e3_selected, fmax_e3);

bar(wanted, bins);
title('GETA channel 3')

subplot(224)
[wanted, bins] = calculate_histogram(e4_selected, fmax_e4);

bar(wanted, bins);
title('GETA channel 4')

saveas(gcf, [ffig{1} '_geta_hist_fs256' '.png'])
gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms side by side');

subplot(421)
[wanted, bins] = calculate_histogram(channel1_selected, fmax_channel1);

bar(wanted, bins);
title('Shimmer channel 1')

subplot(423)
[wanted, bins] = calculate_histogram(channel2_selected, fmax_channel2);

bar(wanted, bins);
title('Shimmer channel 2')

subplot(425)
[wanted, bins] = calculate_histogram(channel3_selected, fmax_channel3);

bar(wanted, bins);
title('Shimmer channel 3')

subplot(427)
[wanted, bins] = calculate_histogram(channel4_selected, fmax_channel4);

bar(wanted, bins);
title('Shimmer channel 4')

%%%%%%%%
subplot(422)
[wanted, bins] = calculate_histogram(e1, fmax_e1);

bar(wanted, bins);
title('GETA channel 1')

subplot(424)
[wanted, bins] = calculate_histogram(e2, fmax_e2);

bar(wanted, bins);
title('GETA channel 2')

subplot(426)
[wanted, bins] = calculate_histogram(e3, fmax_e3);

bar(wanted, bins);
title('GETA channel 3')

subplot(428)
[wanted, bins] = calculate_histogram(e4, fmax_e4);

bar(wanted, bins);
title('GETA channel 4')

saveas(gcf, [ffig{1} '_hist_fs256' '.png'])

%% reduced signals sync

delay1 = round(delay1_256 / fs_shimmer * fs_geta);
delay2 = round(delay2_256 / fs_shimmer * fs_geta);
delay3 = round(delay3_256 / fs_shimmer * fs_geta);
delay4 = round(delay4_256 / fs_shimmer * fs_geta);

if delay1 > 0
    channel1_reduced_al = [zeros(delay1, 1); channel1_reduced];
    e1_al = e1;
else
    channel1_reduced_al = channel1_reduced;
    e1_al = [zeros(-delay1, 1); e1];
end

if delay2 > 0
    channel2_reduced_al = [zeros(delay2, 1); channel2_reduced];
    e2_al = e2;
else
    channel2_reduced_al = channel2_reduced;
    e2_al = [zeros(-delay2, 1); e2];
end

if delay3 > 0
    channel3_reduced_al = [zeros(delay3, 1); channel3_reduced];
    e3_al = e3;
else
    channel3_reduced_al = channel3_reduced;
    e3_al = [zeros(-delay3, 1); e3];
end

if delay4 > 0
    channel4_reduced_al = [zeros(delay4, 1); channel4_reduced];
    e4_al = e4;
else
    channel4_reduced_al = channel4_reduced;
    e4_al = [zeros(-delay4, 1); e4];
end

fig1 = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Aligned signals 1 Hz');
subplot(221)
plot(channel1_reduced_al / max(channel1_reduced_al));
hold on
plot(e1_al / max(e1_al))
plot_markers(mx, 1)
legend('Shimmer', 'Geta')
title('Channel 1')

subplot(222)
plot(channel2_reduced_al / max(channel2_reduced_al));
hold on
plot(e2_al / max(e2_al))
plot_markers(mx, 1)
legend('Shimmer', 'Geta')
title('Channel 2')

subplot(223)
plot(channel3_reduced_al / max(channel3_reduced_al));
hold on
plot(e3_al / max(e3_al))
plot_markers(mx, 1)
legend('Shimmer', 'Geta')
title('Channel 3')

subplot(224)
plot(channel4_reduced_al / max(channel4_reduced_al));
hold on
plot(e4_al / max(e4_al))
plot_markers(mx, 1)
legend('Shimmer', 'Geta')
title('Channel 4')

sgtitle('Aligned signals scaled to 1 (fs=1 Hz)')
saveas(fig1, [ffig{1} '_fs1' '.png'])

if ~exist('fmax_e1_reduced', 'var')

    if exist(mat_name, 'file')
        load(mat_name);
    end

    if ~exist('fmax_e1_reduced', 'var')
        sgtitle('Select fmax range')
        [x, ~] = ginput();
        x = x + 1;

        e1_fmax_range = [];
        e2_fmax_range = [];
        e3_fmax_range = [];
        e4_fmax_range = [];
        channel1_fmax_range = [];
        channel2_fmax_range = [];
        channel3_fmax_range = [];
        channel4_fmax_range = [];

        for i = 1:length(mx)

            if any(and(x >= mx0(i), x <= mx0(i + 1)))
                e1_fmax_range = [e1_fmax_range; e1_al(mx0(i):mx0(i + 1))];
                e2_fmax_range = [e2_fmax_range; e2_al(mx0(i):mx0(i + 1))];
                e3_fmax_range = [e3_fmax_range; e3_al(mx0(i):mx0(i + 1))];
                e4_fmax_range = [e4_fmax_range; e4_al(mx0(i):mx0(i + 1))];
                channel1_fmax_range = [channel1_fmax_range; channel1_reduced_al(mx0(i):mx0(i + 1))];
                channel2_fmax_range = [channel2_fmax_range; channel2_reduced_al(mx0(i):mx0(i + 1))];
                channel3_fmax_range = [channel3_fmax_range; channel3_reduced_al(mx0(i):mx0(i + 1))];
                channel4_fmax_range = [channel4_fmax_range; channel4_reduced_al(mx0(i):mx0(i + 1))];
            end

        end

        if any(x >= mx0(end))
            e1_fmax_range = [e1_fmax_range; e1_al(mx0(end):end)];
            e2_fmax_range = [e2_fmax_range; e2_al(mx0(end):end)];
            e3_fmax_range = [e3_fmax_range; e3_al(mx0(end):end)];
            e4_fmax_range = [e4_fmax_range; e4_al(mx0(end):end)];
            channel1_fmax_range = [channel1_fmax_range; channel1_reduced_al(mx0(end):end)];
            channel2_fmax_range = [channel2_fmax_range; channel2_reduced_al(mx0(end):end)];
            channel3_fmax_range = [channel3_fmax_range; channel3_reduced_al(mx0(end):end)];
            channel4_fmax_range = [channel4_fmax_range; channel4_reduced_al(mx0(end):end)];
        end

        fmax_e1_reduced = max(e1_fmax_range) * 0.95;
        fmax_e2_reduced = max(e2_fmax_range) * 0.95;
        fmax_e3_reduced = max(e3_fmax_range) * 0.95;
        fmax_e4_reduced = max(e4_fmax_range) * 0.95;
        fmax_channel1_reduced = max(channel1_fmax_range) * 0.95;
        fmax_channel2_reduced = max(channel2_fmax_range) * 0.95;
        fmax_channel3_reduced = max(channel3_fmax_range) * 0.95;
        fmax_channel4_reduced = max(channel4_fmax_range) * 0.95;

        if exist(mat_name, 'dir')
            save(mat_name, 'fmax_e1_reduced', 'fmax_e2_reduced', 'fmax_e3_reduced', 'fmax_e4_reduced', 'fmax_channel1_reduced', 'fmax_channel2_reduced', 'fmax_channel3_reduced', 'fmax_channel4_reduced', '-append');
        else
            save(mat_name, 'fmax_e1_reduced', 'fmax_e2_reduced', 'fmax_e3_reduced', 'fmax_e4_reduced', 'fmax_channel1_reduced', 'fmax_channel2_reduced', 'fmax_channel3_reduced', 'fmax_channel4_reduced');
        end

    end

end

clf
subplot(221)
plot(channel1_reduced_al / max(channel1_reduced_al));
hold on
plot(e1_al / max(e1_al))
line([0 length(channel1_reduced_al)], [1 1] * fmax_channel1_reduced / max(channel1_reduced_al));
line([0 length(e1_al)], [1 1] * fmax_e1_reduced / max(e1_al));
plot_markers(mx, 1)
legend('Shimmer', 'Geta', 'Fmax Shimmer', 'Fmax Geta')
title('Channel 1')

subplot(222)
plot(channel2_reduced_al / max(channel2_reduced_al));
hold on
plot(e2_al / max(e2_al))
line([0 length(channel2_reduced_al)], [1 1] * fmax_channel2_reduced / max(channel2_reduced_al));
line([0 length(e2_al)], [1 1] * fmax_e2_reduced / max(e2_al));
plot_markers(mx, 1)
legend('Shimmer', 'Geta', 'Fmax Shimmer', 'Fmax Geta')
title('Channel 2')

subplot(223)
plot(channel3_reduced_al / max(channel3_reduced_al));
hold on
plot(e3_al / max(e3_al))
line([0 length(channel3_reduced_al)], [1 1] * fmax_channel3_reduced / max(channel3_reduced_al));
line([0 length(e3_al)], [1 1] * fmax_e3_reduced / max(e3_al));
plot_markers(mx, 1)
legend('Shimmer', 'Geta', 'Fmax Shimmer', 'Fmax Geta')
title('Channel 3')

subplot(224)
plot(channel4_reduced_al / max(channel4_reduced_al));
hold on
plot(e4_al / max(e4_al))
line([0 length(channel4_reduced_al)], [1 1] * fmax_channel4_reduced / max(channel4_reduced_al));
line([0 length(e4_al)], [1 1] * fmax_e4_reduced / max(e4_al));
plot_markers(mx, 1)
legend('Shimmer', 'Geta', 'Fmax Shimmer', 'Fmax Geta')
title('Channel 4')

%%% Select data
sgtitle('Select calclulations ranges')
[x, ~] = ginput();
x = x + 1;

e1_selected = [];
e2_selected = [];
e3_selected = [];
e4_selected = [];
channel1_selected = [];
channel2_selected = [];
channel3_selected = [];
channel4_selected = [];

for i = 1:length(mx)

    if any(and(x >= mx0(i), x <= mx0(i + 1)))
        e1_selected = [e1_selected; e1_al(mx0(i):mx0(i + 1))];
        e2_selected = [e2_selected; e2_al(mx0(i):mx0(i + 1))];
        e3_selected = [e3_selected; e3_al(mx0(i):mx0(i + 1))];
        e4_selected = [e4_selected; e4_al(mx0(i):mx0(i + 1))];
        channel1_selected = [channel1_selected; channel1_reduced_al(mx0(i):mx0(i + 1))];
        channel2_selected = [channel2_selected; channel2_reduced_al(mx0(i):mx0(i + 1))];
        channel3_selected = [channel3_selected; channel3_reduced_al(mx0(i):mx0(i + 1))];
        channel4_selected = [channel4_selected; channel4_reduced_al(mx0(i):mx0(i + 1))];
    end

end

if any(x >= mx0(end))
    e1_selected = [e1_selected; e1_al(mx0(end):end)];
    e2_selected = [e2_selected; e2_al(mx0(end):end)];
    e3_selected = [e3_selected; e3_al(mx0(end):end)];
    e4_selected = [e4_selected; e4_al(mx0(end):end)];
    channel1_selected = [channel1_selected; channel1_reduced_al(mx0(end):end)];
    channel2_selected = [channel2_selected; channel2_reduced_al(mx0(end):end)];
    channel3_selected = [channel3_selected; channel3_reduced_al(mx0(end):end)];
    channel4_selected = [channel4_selected; channel4_reduced_al(mx0(end):end)];
end

%%% save figure
sgtitle('Aligned signals scaled to 1 (fs=1 Hz)')
saveas(fig1, [ffig{1}, '_fs1', '.png'])

%%% calculate histogram
gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms shimmer');

subplot(221)
[wanted, bins] = calculate_histogram(channel1_selected, fmax_channel1_reduced);

bar(wanted, bins);
title('Shimmer channel 1')

subplot(222)
[wanted, bins] = calculate_histogram(channel2_selected, fmax_channel2_reduced);

bar(wanted, bins);
title('Shimmer channel 2')

subplot(223)
[wanted, bins] = calculate_histogram(channel3_selected, fmax_channel3_reduced);

bar(wanted, bins);
title('Shimmer channel 3')

subplot(224)
[wanted, bins] = calculate_histogram(channel4_selected, fmax_channel4_reduced);

bar(wanted, bins);
title('Shimmer channel 4')

saveas(gcf, [ffig{1} '_shimmer_hist_fs1' '.png'])

gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms geta');

subplot(221)
[wanted, bins] = calculate_histogram(e1_selected, fmax_e1_reduced);

bar(wanted, bins);
title('GETA channel 1')

subplot(222)
[wanted, bins] = calculate_histogram(e2_selected, fmax_e2_reduced);

bar(wanted, bins);
title('GETA channel 2')

subplot(223)
[wanted, bins] = calculate_histogram(e3_selected, fmax_e3_reduced);

bar(wanted, bins);
title('GETA channel 3')

subplot(224)
[wanted, bins] = calculate_histogram(e4_selected, fmax_e4_reduced);

bar(wanted, bins);
title('GETA channel 4')

saveas(gcf, [ffig{1} '_geta_hist_fs1' '.png'])
gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms side by side');

subplot(421)
[wanted, bins] = calculate_histogram(channel1_selected, fmax_channel1_reduced);

bar(wanted, bins);
title('Shimmer channel 1')

subplot(423)
[wanted, bins] = calculate_histogram(channel2_selected, fmax_channel2_reduced);

bar(wanted, bins);
title('Shimmer channel 2')

subplot(425)
[wanted, bins] = calculate_histogram(channel3_selected, fmax_channel3_reduced);

bar(wanted, bins);
title('Shimmer channel 3')

subplot(427)
[wanted, bins] = calculate_histogram(channel4_selected, fmax_channel4_reduced);

bar(wanted, bins);
title('Shimmer channel 4')

%%%%%%%%
subplot(422)
[wanted, bins] = calculate_histogram(e1, fmax_e1_reduced);

bar(wanted, bins);
title('GETA channel 1')

subplot(424)
[wanted, bins] = calculate_histogram(e2, fmax_e2_reduced);

bar(wanted, bins);
title('GETA channel 2')

subplot(426)
[wanted, bins] = calculate_histogram(e3, fmax_e3_reduced);

bar(wanted, bins);
title('GETA channel 3')

subplot(428)
[wanted, bins] = calculate_histogram(e4, fmax_e4_reduced);

bar(wanted, bins);
title('GETA channel 4')

saveas(gcf, [ffig{1} '_hist_fs1' '.png'])

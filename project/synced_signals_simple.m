clear all;
close all;

%% Load data files
subject = 'mira';
mat_name = strcat(subject, "_meta.mat");

if exist(mat_name, "file")
    load(mat_name);
else
    geta_file = 'mira_pokus.xlsx';
    shimmer_file1 = 'mira/2023_11_10_channel_13.csv'; %right
    shimmer_file2 = 'mira/2023_11_10_channel_10.csv'; %left

    order = [1, 2, 3, 4];

    save(mat_name, "geta_file", "shimmer_file1", "shimmer_file2", "order")
end

%% Define metadata
fs_shimmer = 256;
fs_geta = 1;

%% Reading data

% geta
tab = readtable(geta_file);

e1 = table2array(tab(:, order(1) * 2));
e2 = table2array(tab(:, order(2) * 2));
e3 = table2array(tab(:, order(3) * 2));
e4 = table2array(tab(:, order(4) * 2));

mm = table2array(tab(:, 10));

% shimmer
data1 = readtable(shimmer_file1);
data2 = readtable(shimmer_file2);

channel1_raw = table2array(data1(:, 18));
channel2_raw = table2array(data1(:, 20));
channel3_raw = table2array(data2(:, 18));
channel4_raw = table2array(data2(:, 20));

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
[channel1_256, channel1, channel2_256, channel2] = shimmer(channel1_raw, channel2_raw, fs_shimmer, false);
[channel3_256, channel3, channel4_256, channel4] = shimmer(channel3_raw, channel4_raw, fs_shimmer, false);

%% align
matname = strcat(subject, "_delay.mat");

if exist(matname, "dir")
    load([subject, "_delay.mat"]);
else
    delay1 = 1;
    delay2 = 2;
    delay3 = 2;
    delay4 = 2;

    save(strcat(subject, "_delay.mat"), "delay1", "delay2", "delay3", "delay4")
end

if delay1 > 0
    channel1 = [zeros(delay1, 1); channel1];
    channel1_256 = [zeros(delay1 * 256, 1); channel1_256];
else
    e1 = [zeros(-delay1, 1); e1];
    e1_256 = [zeros(-delay1 * 256, 1); e1_256];
end

if delay2 > 0
    channel2 = [zeros(delay2, 1); channel2];
    channel2_256 = [zeros(delay2 * 256, 1); channel2_256];
else
    e2 = [zeros(-delay2, 1); e2];
    e2_256 = [zeros(-delay2 * 256, 1); e2_256];
end

if delay3 > 0
    channel3 = [zeros(delay3, 1); channel3];
    channel3_256 = [zeros(delay3 * 256, 1); channel3_256];
else
    e3 = [zeros(-delay3, 1); e3];
    e3_256 = [zeros(-delay3 * 256, 1); e3_256];
end

if delay4 > 0
    channel4 = [zeros(delay4, 1); channel4];
    channel4_256 = [zeros(delay4 * 256, 1); channel4_256];
else
    e4 = [zeros(-delay4, 1); e4];
    e4_256 = [zeros(-delay4 * 256, 1); e4_256];
end

%% get fmax
%%% 256 Hz
if ~exist("fmax_256", "var")
    mat_name = strcat(subject, "_fmax.mat");

    if exist(mat_name, "file")
        load(mat_name)
    end

    if ~exist("fmax_256", "var")
        fmax_256 = get_fmax(mx0_256, channel1_256, e1_256, channel2_256, e2_256, channel3_256, e3_256, channel4_256, e4_256);

        if exist(mat_name, "file")
            save(mat_name, "fmax_256", "-append")
        else
            save(mat_name, "fmax_256")
        end

    end

end

%%% 1 Hz
if ~exist("fmax", "var")
    mat_name = strcat(subject, "_fmax.mat");

    if exist(mat_name, "file")
        load(mat_name)
    end

    if ~exist("fmax", "var")
        fmax = get_fmax(mx0, channel1, e1, channel2, e2, channel3, e3, channel4, e4);

        if exist(mat_name, "file")
            save(mat_name, "fmax", "-append")
        else
            save(mat_name, "fmax")
        end

    end

end

%% plot signals
%%% 256 Hz
fig_data_256 = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', '256 Hz data');
draw_plots(mx0_256, channel1_256, e1_256, channel2_256, e2_256, channel3_256, e3_256, channel4_256, e4_256, fmax_256);
sgtitle("Normalised signals (f_s = 256 Hz)")
saveas(fig_data_256, [subject '_fs256' '.png'])

%%% 1 Hz
fig_data = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', '1 Hz data');
draw_plots(mx0, channel1, e1, channel2, e2, channel3, e3, channel4, e4, fmax);
sgtitle("Normalised signals (f_s = 1 Hz)")
saveas(fig_data, [subject '_fs1' '.png'])

%% Plot single figs
fig = figure('units', 'normalized');
draw_single_plot(mx0, channel1, e1, fmax(:, 1))
savefig(strcat('figs/', subject, '_channel1.fig'))
title('Channel 1');
savefig(strcat('figs/', subject, '_channel1_title.fig'))

fig = figure('units', 'normalized');
draw_single_plot(mx0, channel2, e2, fmax(:, 2))
savefig(strcat('figs/', subject, '_channel2.fig'))
title('Channel 2');
savefig(strcat('figs/', subject, '_channel2_title.fig'))

fig = figure('units', 'normalized');
draw_single_plot(mx0, channel3, e3, fmax(:, 3))
savefig(strcat('figs/', subject, '_channel3.fig'))
title('Channel 3');
savefig(strcat('figs/', subject, '_channel3_title.fig'))

fig = figure('units', 'normalized');
draw_single_plot(mx0, channel4, e4, fmax(:, 4))
savefig(strcat('figs/', subject, '_channel4.fig'))
title('Channel 4');
savefig(strcat('figs/', subject, '_channel4_title.fig'))

%% calculate histograms
fig_hist = figure("Units", "normalized", "OuterPosition", [0 0 1 1]);

sgtitle("Select calculation range(s) (Click between markers)")

[x, ~] = ginput();
x = x + 1;

close(fig_hist)

%%% 256 Hz
[calc_s1_256, calc_s2_256, calc_s3_256, calc_s4_256, calc_g1_256, calc_g2_256, calc_g3_256, calc_g4_256] = select_ranges(x, mx0_256, channel1_256, e1_256, channel2_256, e2_256, channel3_256, e3_256, channel4_256, e4_256);
[wanted, hist_s1_256] = calculate_histogram(calc_s1_256, fmax_256(1, 1));
[~, hist_s2_256] = calculate_histogram(calc_s2_256, fmax_256(1, 2));
[~, hist_s3_256] = calculate_histogram(calc_s3_256, fmax_256(1, 3));
[~, hist_s4_256] = calculate_histogram(calc_s4_256, fmax_256(1, 4));

[~, hist_g1_256] = calculate_histogram(calc_g1_256, fmax_256(2, 1));
[~, hist_g2_256] = calculate_histogram(calc_g2_256, fmax_256(2, 2));
[~, hist_g3_256] = calculate_histogram(calc_g3_256, fmax_256(2, 3));
[~, hist_g4_256] = calculate_histogram(calc_g4_256, fmax_256(2, 4));

hist_s_256 = [hist_s1_256', hist_s2_256', hist_s3_256', hist_s4_256'];
hist_g_256 = [hist_g1_256', hist_g2_256', hist_g3_256', hist_g4_256'];

fig_hist_s_256 = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', '1 Hz histograms Shimmer');
draw_histograms(wanted, hist_s_256, []);
saveas(fig_hist_s_256, [subject, '_shimmer', '_hist_fs1', '.png']);

fig_hist_g_256 = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', '1 Hz histograms Geta');
draw_histograms(wanted, [], hist_g_256);
saveas(fig_hist_g_256, [subject, '_geta', '_hist_fs1', '.png']);

fig_hist_256 = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', '1 Hz histograms');
draw_histograms(wanted, hist_s_256, hist_g_256);
saveas(fig_hist_256, [subject, '_hist_fs1', '.png']);

%%% 1 Hz

[calc_s1, calc_s2, calc_s3, calc_s4, calc_g1, calc_g2, calc_g3, calc_g4] = select_ranges(x, mx0, channel1, e1, channel2, e2, channel3, e3, channel4, e4);

[wanted, hist_s1] = calculate_histogram(calc_s1, fmax(1, 1));
[~, hist_s2] = calculate_histogram(calc_s2, fmax(1, 2));
[~, hist_s3] = calculate_histogram(calc_s3, fmax(1, 3));
[~, hist_s4] = calculate_histogram(calc_s4, fmax(1, 4));

[~, hist_g1] = calculate_histogram(calc_g1, fmax(2, 1));
[~, hist_g2] = calculate_histogram(calc_g2, fmax(2, 2));
[~, hist_g3] = calculate_histogram(calc_g3, fmax(2, 3));
[~, hist_g4] = calculate_histogram(calc_g4, fmax(2, 4));

hist_s = [hist_s1', hist_s2', hist_s3', hist_s4'];
hist_g = [hist_g1', hist_g2', hist_g3', hist_g4'];

fig_hist_s = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', '1 Hz histograms Shimmer');
draw_histograms(wanted, hist_s, []);
saveas(fig_hist_s, [subject, '_shimmer', '_hist_fs1', '.png']);

fig_hist_g = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', '1 Hz histograms Geta');
draw_histograms(wanted, [], hist_g);
saveas(fig_hist_g, [subject, '_geta', '_hist_fs1', '.png']);

fig_hist = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', '1 Hz histograms');
draw_histograms(wanted, hist_s, hist_g);
saveas(fig_hist, [subject, '_hist_fs1', '.png']);

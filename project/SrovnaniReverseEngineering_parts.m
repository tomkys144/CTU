clear all;
close all;

geta_file = 'míra_pokus.xlsx';
shimmer_file = 'mira/2023_11_10_channel_13.csv';



ffig = strsplit(shimmer_file, '/');
ffig = ffig(1);

mat_name = join([ffig{1} "_fmax.mat"]);

%% GETA
tab = readtable(geta_file);

e1 = table2array(tab(:, 2));
e2 = table2array(tab(:, 4));
e3 = table2array(tab(:, 6));
e4 = table2array(tab(:, 8));

mm = table2array(tab(:, 10));

m = zeros([1 length(mm)]);

for k = 1:length(mm)

    if ~isempty(mm{k})
        m(k) = 1;
    end

end

mx = find(m);
mx0 = [1 mx];
figure('Name', 'GETA data')

subplot(2, 2, 1)
plot_markers(mx, max(e1));
hold on
plot(e1)
title('Channel 1')

subplot(2, 2, 2)
plot_markers(mx, max(e2));
hold on
plot(e2)
title('Channel 2')

subplot(2, 2, 3)
plot_markers(mx, max(e3));
hold on
plot(e3)
title('Channel 3')

subplot(2, 2, 4)
plot_markers(mx, max(e4));
hold on
plot(e4)
title('Channel 4')
sgtitle('Geta data')

%%% select fmax
if ~exist("fmax_e1", "var")

    if exist(mat_name, "file")
        load(mat_name);
    end

    if ~exist("fmax_e1", "var")
        sgtitle('Select fmax range')
        [x, ~] = ginput();
        x = x + 1;

        e1_fmax_range = [];
        e2_fmax_range = [];
        e3_fmax_range = [];
        e4_fmax_range = [];

        for i = 1:length(mx)

            if any(and(x >= mx0(i), x <= mx0(i + 1)))
                e1_fmax_range = [e1_fmax_range; e1(mx0(i):mx0(i + 1))];
                e2_fmax_range = [e2_fmax_range; e2(mx0(i):mx0(i + 1))];
                e3_fmax_range = [e3_fmax_range; e3(mx0(i):mx0(i + 1))];
                e4_fmax_range = [e4_fmax_range; e4(mx0(i):mx0(i + 1))];
            end

        end

        if any(x >= mx0(end))
            e1_fmax_range = [e1_fmax_range; e1(mx0(end):end)];
            e2_fmax_range = [e2_fmax_range; e2(mx0(end):end)];
            e3_fmax_range = [e3_fmax_ranged; e3(mx0(end):end)];
            e4_fmax_range = [e4_fmax_range; e4(mx0(end):end)];
        end

        fmax_e1 = max(e1_fmax_range) * 0.95;
        fmax_e2 = max(e2_fmax_range) * 0.95;
        fmax_e3 = max(e3_fmax_range) * 0.95;
        fmax_e4 = max(e4_fmax_range) * 0.95;

        save(mat_name, "fmax_e1", "fmax_e2", "fmax_e3", "fmax_e4");

    end

end

%%%%%% select data

sgtitle('Select calclulations ranges')
[x, ~] = ginput();
x = x + 1;

figure('Name', 'GETA data selected')
title('Selected GETA data')

subplot(2, 2, 1)
plot_markers(mx, max(e1));
hold on

for i = 1:length(mx)

    if any(and(x >= mx0(i), x <= mx0(i + 1)))
        plot(mx0(i):mx0(i + 1), e1(mx0(i):mx0(i + 1)), 'g');
    else
        plot(mx0(i):mx0(i + 1), e1(mx0(i):mx0(i + 1)), 'r');
    end

end

if any(x >= mx0(end))
    plot(mx0(end):length(e1), e1(mx0(end):end), 'g');
else
    plot(mx0(end):length(e1), e1(mx0(end):end), 'r');
end

line([0 length(e1)], [fmax_e1 fmax_e1])
title('Channel 1')

subplot(2, 2, 2)
plot_markers(mx, max(e2));
hold on

for i = 1:length(mx)

    if any(and(x >= mx0(i), x <= mx0(i + 1)))
        plot(mx0(i):mx0(i + 1), e2(mx0(i):mx0(i + 1)), 'g');
    else
        plot(mx0(i):mx0(i + 1), e2(mx0(i):mx0(i + 1)), 'r');
    end

end

if any(x >= mx0(end))
    plot(mx0(end):length(e2), e2(mx0(end):end), 'g');
else
    plot(mx0(end):length(e2), e2(mx0(end):end), 'r');
end

line([0 length(e2)], [fmax_e2 fmax_e2])
title('Channel 2')

subplot(2, 2, 3)
plot_markers(mx, max(e3));
hold on

for i = 1:length(mx)

    if any(and(x >= mx0(i), x <= mx0(i + 1)))
        plot(mx0(i):mx0(i + 1), e3(mx0(i):mx0(i + 1)), 'g');
    else
        plot(mx0(i):mx0(i + 1), e3(mx0(i):mx0(i + 1)), 'r');
    end

end

if any(x >= mx0(end))
    plot(mx0(end):length(e3), e3(mx0(end):end), 'g');
else
    plot(mx0(end):length(e3), e3(mx0(end):end), 'r');
end

line([0 length(e3)], [fmax_e3 fmax_e3])
title('Channel 3')

subplot(2, 2, 4)
plot_markers(mx, max(e4));
hold on

for i = 1:length(mx)

    if any(and(x >= mx0(i), x <= mx0(i + 1)))
        plot(mx0(i):mx0(i + 1), e4(mx0(i):mx0(i + 1)), 'g');
    else
        plot(mx0(i):mx0(i + 1), e4(mx0(i):mx0(i + 1)), 'r');
    end

end

if any(x >= mx0(end))
    plot(mx0(end):length(e4), e4(mx0(end):end), 'g');
else
    plot(mx0(end):length(e4), e4(mx0(end):end), 'r');
end

line([0 length(e4)], [fmax_e4 fmax_e4])
title('Channel 4')

%%% select data

e1_selected = [];
e2_selected = [];
e3_selected = [];
e4_selected = [];

for i = 1:length(mx)

    if any(and(x >= mx0(i), x <= mx0(i + 1)))
        e1_selected = [e1_selected; e1(mx0(i):mx0(i + 1))];
        e2_selected = [e2_selected; e2(mx0(i):mx0(i + 1))];
        e3_selected = [e3_selected; e3(mx0(i):mx0(i + 1))];
        e4_selected = [e4_selected; e4(mx0(i):mx0(i + 1))];
    end

end

if any(x >= mx0(end))
    e1_selected = [e1_selected; e1(mx0(i):end)];
    e2_selected = [e2_selected; e2(mx0(i):end)];
    e3_selected = [e3_selected; e3(mx0(i):end)];
    e4_selected = [e4_selected; e4(mx0(i):end)];
end

figure('Name', 'GETA data trimmed')

subplot(2, 2, 1)
plot(e1_selected)
hold on
line([0 length(e1_selected)], [fmax_e1 fmax_e1])
title('Channel 1')

subplot(2, 2, 2)
plot(e2_selected)
hold on
line([0 length(e2_selected)], [fmax_e2 fmax_e2])
title('Channel 2')

subplot(2, 2, 3)
plot(e3_selected)
hold on
line([0 length(e3_selected)], [fmax_e3 fmax_e3])
title('Channel 3')

subplot(2, 2, 4)
plot(e4_selected)
hold on
line([0 length(e4_selected)], [fmax_e4 fmax_e4])
title('Channel 4')
sgtitle('Geta data trimmed')

%% SHIMMER
fs_shimmer = 256;

%filename='001-TOMAS/2023_10_11_channel_13.csv';

data = readtable(shimmer_file);

channel1 = table2array(data(:, 18));
channel2 = table2array(data(:, 20));

figure('Name', 'Shimmer input data')
plot(channel1)
hold on
plot(channel2)

% make at start at y=0"
channel1 = channel1 - channel1(1);
channel2 = channel2 - channel2(2);

figure('Name', 'Shimmer raw data')
plot(channel1)
hold on
plot(channel2)
title('raw data')

% 1. KROK Filtrování - BAND PASS FILTER
high_pass_freq = 20;
low_pass_freq = 120;

[b, a] = butter(6, [high_pass_freq / fs_shimmer * 2 low_pass_freq / fs_shimmer * 2]);

channel1_bp = filter(b, a, channel1);
channel2_bp = filter(b, a, channel2);

figure('Name', 'Shimmer band pass')
plot(channel1_bp)
hold on
plot(channel2_bp)
title('band pass')

% 2.KROK absolutni hodnota
channel1_abs = abs(channel1_bp);
channel2_abs = abs(channel2_bp);

figure('Name', 'Shimmer absolute value')
plot(channel1_abs)
hold on
plot(channel2_abs)
title('absolute value')

% 3.KROK low pass
[b2, a2] = butter(6, 5 / fs_shimmer * 2);

channel1_env = filter(b2, a2, channel1_abs);
channel2_env = filter(b2, a2, channel2_abs);

figure('Name', 'Shimmer envelope')
plot(channel1_env)
hold on
plot(channel2_env)
title('envelope')

signal_1 = channel1_env;
num_samples = length(signal_1);
reduced_signal1 = arrayfun(@(i) mean(signal_1(i:min(i + fs_shimmer - 1, num_samples))), 1:fs_shimmer:num_samples)';

signal_2 = channel2_env;
num_samples = length(signal_2);
reduced_signal2 = arrayfun(@(i) mean(signal_2(i:min(i + fs_shimmer - 1, num_samples))), 1:fs_shimmer:num_samples)';

gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Shimmer 1s average');
plot(reduced_signal1);
hold on
plot(reduced_signal2);
title('1 sec averaged envelope')

saveas(gcf, [ffig{1} '.png'])

ylim([-0.2 1])

title('Select markers')
[x, ~] = ginput();
x = x + 1;
mx = round(x);
mx0 = [1; mx];

plot_markers(mx, max(max(reduced_signal1), max(reduced_signal2)))

if ~exist("fmax_channel1", "var")

    if exist(mat_name, "file")
        load(mat_name);
    end

    if ~exist("fmax_channel1", "var")
        ylim([-0.2 1])
        title('Select fmax range')
        [x, ~] = ginput();
        x = x + 1;

        signal_fmax1 = [];
        signal_fmax2 = [];

        for i = 1:length(mx)

            if any(and(x >= mx0(i), x <= mx0(i + 1)))
                signal_fmax1 = [signal_fmax1; reduced_signal1(mx0(i):mx0(i + 1))];
                signal_fmax2 = [signal_fmax2; reduced_signal2(mx0(i):mx0(i + 1))];
            end

        end

        if any(x >= mx0(end))
            signal_fmax1 = [signal_fmax1; reduced_signal1(mx0(end):end)];
            signal_fmax2 = [signal_fmax2; reduced_signal2(mx0(end):end)];
        end

        fmax_channel1 = max(signal_fmax1) * 0.95;
        fmax_channel2 = max(signal_fmax2) * 0.95;

        if exist(mat_name, "dir")
            save(mat_name, "fmax_channel1", "fmax_channel2", "-append");
        else
            save(mat_name, "fmax_channel1", "fmax_channel2");
        end

    end

end

line([0 length(reduced_signal1)], [fmax_channel1 fmax_channel1])

ylim([-0.2 max(fmax_channel1, fmax_channel2) + 0.2])

%%% select data
clf
hold on
plot(reduced_signal1);
hold on
plot(reduced_signal2);

line([0 length(reduced_signal1)], [fmax_channel1 fmax_channel1])
line([0 length(reduced_signal1)], [fmax_channel2 fmax_channel2])

ylim([-0.2 max(fmax_channel1, fmax_channel2) + 0.2])
saveas(gcf, [ffig{1} '_cut' '.png'])

title('Select calculations ranges')
plot_markers(mx, max(max(reduced_signal1), max(reduced_signal2)));
[x, ~] = ginput();
x = x + 1;

figure('Name', 'Shimmer selected data')
hold on

for i = 1:length(mx)

    if any(and(x >= mx0(i), x <= mx0(i + 1)))
        plot(mx0(i):mx0(i + 1), reduced_signal1(mx0(i):mx0(i + 1)), 'g');
        plot(mx0(i):mx0(i + 1), reduced_signal2(mx0(i):mx0(i + 1)), 'b');
    else
        plot(mx0(i):mx0(i + 1), reduced_signal1(mx0(i):mx0(i + 1)), 'r');
        plot(mx0(i):mx0(i + 1), reduced_signal2(mx0(i):mx0(i + 1)), 'm');
    end

end

if any(x >= mx0(end))
    plot(mx0(end):length(reduced_signal1), reduced_signal1(mx0(end):end), 'g');
    plot(mx0(end):length(reduced_signal2), reduced_signal2(mx0(end):end), 'b');
else
    plot(mx0(end):length(reduced_signal1), reduced_signal1(mx0(end):end), 'r');
    plot(mx0(end):length(reduced_signal2), reduced_signal2(mx0(end):end), 'm');
end

signal_selected1 = [];
signal_selected2 = [];

for i = 1:length(mx)

    if any(and(x >= mx0(i), x <= mx0(i + 1)))
        signal_selected1 = [signal_selected1; reduced_signal1(mx0(i):mx0(i + 1))];
        signal_selected2 = [signal_selected1; reduced_signal2(mx0(i):mx0(i + 1))];
    end

end

if any(x >= mx0(end))
    signal_selected1 = [signal_selected1; reduced_signal1(mx0(i):end)];
    signal_selected2 = [signal_selected1; reduced_signal2(mx0(i):end)];
end

figure('Name', 'Shimmer histogram 100 bins')
subplot(2, 1, 1)
histogram(signal_selected1, 100)
subplot(2, 1, 2)
histogram(signal_selected2, 100)

%% plot histograms
gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms shimmer');

subplot(221)
[wanted, bins] = calculate_histogram(reduced_signal1, fmax_channel1);

bar(wanted, bins);
title('Shimmer channel 1')

subplot(222)
[wanted, bins] = calculate_histogram(reduced_signal2, fmax_channel2);

bar(wanted, bins);
title('Shimmer channel 2')

saveas(gcf, [ffig{1} '_shimmer_hist' '.png'])

gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms geta');

subplot(221)
[wanted, bins] = calculate_histogram(e1, fmax_e1);

bar(wanted, bins);
title('GETA channel 1')

subplot(222)
[wanted, bins] = calculate_histogram(e2, fmax_e2);

bar(wanted, bins);
title('GETA channel 2')

subplot(223)
[wanted, bins] = calculate_histogram(e3, fmax_e3);

bar(wanted, bins);
title('GETA channel 3')

subplot(224)
[wanted, bins] = calculate_histogram(e4, fmax_e4);

bar(wanted, bins);
title('GETA channel 4')

saveas(gcf, [ffig{1} '_geta_hist' '.png'])
gcf = figure('units', 'normalized', 'outerposition', [0 0 1 1], 'Name', 'Histograms side by side');

subplot(421)
[wanted, bins] = calculate_histogram(reduced_signal1, fmax_channel1);

bar(wanted, bins);
title('Shimmer channel 1')

subplot(423)
[wanted, bins] = calculate_histogram(reduced_signal2, fmax_channel2);

bar(wanted, bins);
title('Shimmer channel 2')

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

saveas(gcf, [ffig{1} '_hist' '.png'])

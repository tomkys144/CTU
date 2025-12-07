%%% 442.120 Mixed-Signal Processing Systems Design, Homework assignment 1
%%% Authors:
%%% Tomáš Kysela, 12513690
close all;
clear all;
clc;

plotExport = true;

%%%%%%%%%%%%%%%%%%
% Analog Filters %
%%%%%%%%%%%%%%%%%%
%% c)

Wp = 2 * pi * 20e3; % rad/s
Ws = 2 * pi * 25e3; % rad/s
Rp = 0.2; % dB
Rs = -138.63; % dB

% Get filter order
[n, Wp] = cheb1ord(Wp, Ws, Rp, Rs, "s");
fprintf("Order of the filter is %.0d\n", n)

%Design filter
[b, a] = cheby1(n, Rp, Wp, "low", "s");

delta = 10;
w = (0:delta:30e3) * 2 * pi;

h = freqs(b, a, w);

% Plot magnitude
figure
plot(w / (2e3 * pi), mag2db(abs(h)), "linewidth", 2)
grid
xlabel("f [kHz]")
ylabel("A [dB]")
ylim("padded"); xlim("tight")

if plotExport
    set(gcf, "Units", "normalized", "OuterPosition", [0 0 1 1])
    fontsize(32, "points")
    set(gco, "LineWidth", 3)
    exportgraphics(gca, "filter-mag.png", "Resolution", 300);
end

figure
plot(w / (2e3 * pi), mag2db(abs(h)), "linewidth", 2)
grid
xlabel('Frequency (kHz)')
ylabel("A [dB]")
ylim("padded"); xlim([19, 26])

if plotExport
    set(gcf, "Units", "normalized", "OuterPosition", [0 0 1 1])
    fontsize(32, "points")
    set(gco, "LineWidth", 3)
    exportgraphics(gca, "filter-mag-detail.png", Resolution = 300);
end

% Plot group delay
gp = -diff(unwrap(angle(h))) ./ (delta * 2 * pi);

figure
plot(w(2:end) / (2e3 * pi), gp * 1e3, "LineWidth", 2)
xlabel('Frequency (kHz)')
ylabel('Group delay (ms)')
grid

if plotExport
    set(gcf, "Units", "normalized", "OuterPosition", [0 0 1 1])
    fontsize(32, "points")
    set(gco, "LineWidth", 3)
    exportgraphics(gca, "filter-gd.png", "Resolution", 300);
end

% plot s-plane
figure
zplane(b, a, "ctf")
grid
title('')

if plotExport
    set(gcf, "Units", "normalized", "OuterPosition", [0 0 1 1])
    fontsize(32, "points")
    set(gco, "MarkerSize", 20)
    set(gco, "LineWidth", 3)
    exportgraphics(gca, "filter-splane.png", "Resolution", 300);
end

%% d)

Wp = 2 * pi * 20e3; % rad/s
Ws = 2 * pi * 25e3; % rad/s
Rp = 0.2; % dB
Rs = -138.63; % dB
n = 3;

% find a rough area

step = 2 * pi * 100; % step od 100 Hz

[nn, Wpn] = cheb1ord(Wp, Ws, Rp, Rs, 's');

while (nn > n)
    Ws = Ws + step;

    [nn, ~] = cheb1ord(Wp, Ws, Rp, Rs, 's');
end
%find lowest freq.

Ws = Ws - step;

step = 2 * pi * 1; % step od 10 Hz

nn = inf;

while (nn > n)
    Ws = Ws + step;

    [nn, Wpn] = cheb1ord(Wp, Ws, Rp, Rs, 's');
end

fprintf("Found frequency of 2 pi %f rad/s\n", Ws/(2 * pi));

% design filter
[b, a] = cheby1(n, Rp, Wpn, "low", "s");

[h,w] = freqs(b, a);

% Plot magnitude
figure
semilogx(w / (2e3 * pi), mag2db(abs(h)), "linewidth", 2)
grid
xlabel("f [kHz]")
ylabel("A [dB]")
ylim("padded"); xlim("tight")

if plotExport
    set(gcf, "Units", "normalized", "OuterPosition", [0 0 1 1])
    fontsize(32, "points")
    set(gco, "LineWidth", 3)
    exportgraphics(gca, "filter-mag-oversampling.png", "Resolution", 300);
end

clear all
close all

fs=100e6;

%% HW 2.4

load("rf_data\rf_ln20.mat");

t = (0 : length(rf_data) - 1)/fs * 1e6;

env = abs(hilbert(rf_data));

figure
hold on
plot(t, rf_data)
plot(t, env, 'LineWidth', 2);
hold off

xlabel("time [{\mu}s]")
ylabel("RF signal")

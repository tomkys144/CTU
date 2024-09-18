close all
clear all
clc
%% Wage
data = load("mzdy.txt", '-ascii');
t = data(: , 1);
M = data(:, 2);

x = fit_wages(t, M);

M2009 = quarter2_2009(x);

figure(1)

plot(t, M, 'Marker','o', 'LineStyle','none', 'Color', 'blue')
hold on
t_est = cat(1,t,[2009.00, 2009.25, 2009.50, 2009.75, 2010.00]');
plot(t_est, x(1)+x(2)*t_est, 'LineStyle','-', 'Color', 'red')

plot(2009.25, M2009, LineStyle='none', Marker='x', Color='blue', MarkerSize=10)
hold off
xlabel('Period'), ylabel('Average Gross Wage')


legend({'input data','estimated data', 'estimated AGW for 2nd quarter 2009'}, 'Location','northwest')

%% Temperature

data = load('teplota.txt', '-ascii');
t = data(:, 1);
T = data(:, 2);

w = 2*pi/365;

x = fit_temps(t, T, w);

figure(2)

plot(t, T, Marker='o', LineStyle='none', Color='blue');
hold on

t_est = linspace(0,t(end)+100, t(end)+100);
T_est = x(1) + x(2)*t_est + x(3)*sin(w*t_est) + x(4)*cos(w*t_est);

plot(t_est, T_est, LineStyle='-', Color='red');
hold off

xlabel('Days'), ylabel('Temperature [^{\circ}C]')
clear all
close all
clc

%% Load data
sparam = sparameters('mereni/21-50R-gnd.s2p');

Z0 = sparam.Impedance;
f=sparam.Frequencies;
s_params = sparam.Parameters;

abcd_params = s2abcd(s_params, Z0);

C_param = 1./reshape(abcd_params(2,1,:), [],1);

%% Fit
Cx = 3.8e-13;
Rx = 50;
Rcs = 10;

ZL_fit = 1 ./ (1./Rx + 1./(1./(1i * 2 * pi() * Cx * f) + Rcs));

%% Plot
fig = figure('Name','Impedance','NumberTitle','off');
loglog(f/1e9,abs(C_param)/1e3,  'r', f/1e9,abs(ZL_fit)/1e3,'b')
legend('ZNB','Model','Location', 'Best')
xlabel('f [GHz]'), ylabel('|Z| [k\Omega]')
grid on
saveas(fig, 'res/21.png')
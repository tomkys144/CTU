clear all
close all
clc

%% Load data
sparam = sparameters('mereni/26-50R-ser.s2p');

Z0 = sparam.Impedance;
f=sparam.Frequencies;
s_params = sparam.Parameters;

abcd_params = s2abcd(s_params, Z0);

B_param = reshape(abcd_params(1,2,:), [],1);

%% Fit
Lx = 2e-9;
Rx = 49.95;

ZL_fit = 1i*2*pi()*f*Lx+Rx;

%% Plot
fig = figure('Name','Impedance','NumberTitle','off');
loglog(f/1e9,abs(B_param)/1e3,  'r', f/1e9,abs(ZL_fit)/1e3,'b')
legend('ZNB','Model','Location', 'Best')
xlabel('f [GHz]'), ylabel('|Z| [k\Omega]')
grid on
saveas(fig, 'res/26.png')
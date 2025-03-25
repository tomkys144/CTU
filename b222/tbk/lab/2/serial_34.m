clear all
close all
clc

%% Load data
sparam = sparameters('mereni/34-220nH-ser.s2p');

Z0 = sparam.Impedance;
f=sparam.Frequencies;
s_params = sparam.Parameters;

abcd_params = s2abcd(s_params, Z0);

B_param = reshape(abcd_params(1,2,:), [],1);

%% Fit
Lx=2.2e-7;
Rx=1.3;
Cp=5e-14;
Rp=1e5;

ZL_fit = 1 ./ (1./(1i*2*pi()*f*Lx+Rx)+1./(1./(1i*2*pi()*f*Cp))+1/Rp);

%% Plot
fig = figure('Name','Impedance','NumberTitle','off');
loglog(f/1e9,abs(B_param)/1e3,  'r', f/1e9,abs(ZL_fit)/1e3,'b')
legend('ZNB','Model','Location', 'Best')
xlabel('f [GHz]'), ylabel('|Z| [k\Omega]')
grid on
saveas(fig, 'res/34.png')
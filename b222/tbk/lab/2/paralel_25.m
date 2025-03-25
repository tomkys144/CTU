clear all
close all
clc

%% Load data
sparam = sparameters('mereni/25-100nFp10nF-gnd.s2p');

Z0 = sparam.Impedance;
f=sparam.Frequencies;
s_params = sparam.Parameters;

abcd_params = s2abcd(s_params, Z0);

C_param = 1./reshape(abcd_params(2,1,:), [],1);

%% Fit
Cx1 = 1.1e-8;
Lx1 = 5e-10;
Rx1 = 0.04;

ZL1 = Rx1 + 1i*((2 * pi() * f * Lx1) - (1./(2*pi()*f*Cx1)));

Cx2 = 1e-7;
Lx2 = 4e-10;
Rx2 = 0.04;

ZL2 = Rx2 + 1i*((2 * pi() * f * Lx2) - (1./(2*pi()*f*Cx2)));

ZL_fit = 1./(1./ZL1 + 1./ZL2);

%% Plot
fig = figure('Name','Impedance','NumberTitle','off');
loglog(f/1e9,abs(C_param)/1e3,  'r', f/1e9,abs(ZL_fit)/1e3,'b')
legend('ZNB','Model','Location', 'Best')
xlabel('f [GHz]'), ylabel('|Z| [k\Omega]')
grid on
saveas(fig, 'res/25.png')

%% Res freq


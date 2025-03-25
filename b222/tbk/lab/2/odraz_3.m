clear all
close all
clc

%% Load data
sparam = sparameters('mereni/3-1kR-odraz.s1p');

Z0 = sparam.Impedance;
s11 = reshape(sparam.Parameters, [],1);
f=sparam.Frequencies;

zparam = s2z(s11, Z0);



ZL = Z0*((1+s11)./(1-s11));

%% Fit
Cx = 1.5e-13;
Rx = 1e3;
Rcs = 0.5e3;

ZL_fit = 1 ./ (1./Rx + 1./(1./(1i * 2 * pi() * Cx * f) + Rcs));

s11_estim = (ZL_fit-Z0)./(ZL_fit+Z0);

sparam_fit = sparameters(s11_estim, f, Z0);

%% Plot
fig = figure('Name','Impedance','NumberTitle','off');
loglog(f/1e9,abs(ZL)/1e3,  'r', f/1e9,abs(ZL_fit)/1e3,'b')
legend('ZNB','Model','Location', 'Best')
xlabel('f [GHz]'), ylabel('|Z| [k\Omega]')
grid on
saveas(fig, 'res/3.png')
clear all
close all
clc

%% Load data
sparam = sparameters('mereni/12-470pF-odraz.s1p');

Z0 = sparam.Impedance;
s11 = reshape(sparam.Parameters, [],1);
f=sparam.Frequencies;

zparam = s2z(s11, Z0);



ZL = Z0*((1+s11)./(1-s11));

%% Fit
Cx = 4e-10;
Lx = 7e-10;
Rx = 1;

ZL_fit = Rx + 1i*((2 * pi() * f * Lx) - (1./(2*pi()*f*Cx)));

s11_estim = (ZL_fit-Z0)./(ZL_fit+Z0);

sparam_fit = sparameters(s11_estim, f, Z0);

%% Plot
fig = figure('Name','Impedance','NumberTitle','off');
loglog(f/1e9,abs(ZL)/1e3,  'r', f/1e9,abs(ZL_fit)/1e3,'b')
legend('ZNB','Model','Location', 'Best')
xlabel('f [GHz]'), ylabel('|Z| [k\Omega]')
grid on
saveas(fig, 'res/12.png')

%% Find resonance
f = 10000:1:100000;
Z_fit = @(f)((2 * pi() * f * Lx) - (1./(2*pi()*f*Cx)));
figure()
y=Z_fit(f);
plot(f,y)
hold on
plot(f, zeros(size(f)))

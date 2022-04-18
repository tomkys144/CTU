clear all;
close all;
clc;

%% graficky

startRZP = 100; % km
startRV = 125; % km
delayMin = 10; % min
delayHour = delayMin / 60; % hour

vRZP = 80; % km/h
vRV = 100; % km/h

t_max = abs(startRZP - startRV)/vRZP; % h
t = 0 : 1/60 : t_max;

sRZP = t * vRZP + startRZP;
sRV = startRV - (t - delayHour) * vRV;

figure(1);
clf;
plot(t, sRZP, 'r');
hold on;
plot (t (t >= delayHour), sRV (t >= delayHour), 'b');
xlabel('time [h]');
ylabel('distance [km]');
legend('RZP', 'RV');

fprintf('Autonehoda se stala cca na %.2f km\n', 118);
fprintf('Sanita A dorazila na místo nehody cca za %.2f minut\n', 0.23*60);

%% maticemi
startA=100; % km
startB=125; % km
delay=10/60; % 10 min.v hodinách
vA=80; % km/h
vB=100; % km/h
A=[1 -vA;1 vB];
B=[startA;startB + delay * vB];
x=A\B;
S_accident=x(1);%x1
t_accident=x(2);%x
title(['autonehoda byla na ' num2str(S_accident) 'km, dojezdová doba byla ' num2str(t_accident*60) 'minut'])
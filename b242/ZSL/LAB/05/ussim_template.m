clear all
close all
clc

addpath('field_ii_ver_3_30_windows')

field_init;

%% 1.1 setting up the acoustic environment

c = 1540; % TODO in meters per second (m/s)
set_field('c',c);

fs = 100e6; % TODO in hertzs (Hz)
set_sampling(fs);

no_elements = 128;
width = .2e-3; % TODO element width in meters (m)
height = 5e-3; % TODO element height in meters (m)
kerf = .02e-3; % TODO spacing between elements in meters (m)
no_sub_x = 1; % TODO number of subdivisions in x
no_sub_y = 4; % TODO number of subdivisions in y
focus = [0 0 30e-3]; % TODO coordinates of the fixed focus point [x y z] in meters (m)
Th = xdc_linear_array (no_elements, width, height, kerf, no_sub_x, no_sub_y, focus);

%% 1.2 modelling impulse response

fc = 7.5e6; % TODO central frequency
bw = 0.5; % TODO fractional bandwidth
bwr = -6; % TODO fractional bandwidth reference level
tpe = -40; %  TODO drop in trailing pulse envelope for cutoff time estimation
tc = gauspuls('cutoff',fc,bw,bwr,tpe);
t = - tc:1/fs:tc;
y = gauspuls(t,fc,bw);

figure()
subplot(2,1,1)
plot(t,y)
title({'Impulse response of an piezoelectric element','in time domain (top) and in frequency domain (bottom)'})
xlabel('t [s]')
axis tight
subplot(2,1,2)
f = linspace(-fs/2,fs/2,512);
plot(f,fftshift(abs(fft([y zeros(1,512 - length(y))]))))
xlabel('f [Hz]')


%% 1.3 acoustic field

xdc_impulse(Th,y);

d = 35;

exc = [1 0 0 0 0 0]; % TODO excitation of the elements by Dirac impulse
xdc_excitation(Th,exc);

points = [(-1e-3:0.02e-3:1e-3)' zeros([101 1]) d*1e-3*ones([101 1])]; % TODO define the coordinates of the line going through the fixed focus point from -1 mm to +1 mm by 0.02 mm
[hp, ~] = calc_hp(Th, points);

t = (1:size(hp,1))/fs;
x = -1:.02:1;

figure()
imagesc(x,t,hp)
colormap(gray)
ylabel('Time [s]')
xlabel('Distance [mm]')
title({'Time-dependent changes in pressure on a line going through the fixed focus point',sprintf('(%d mm parallel from the transducer)', d)})


figure()
plot(t,hp(:,51))
title('Acoustic pressure in the fixed focus point')
xlabel('Time [s]')
ylabel('Acoustic pressure [Pa]')

figure()
Pm_i = max(abs(hp),[],1);
plot(x,20*log10(Pm_i/max(Pm_i)))
title({'Normalized pressure maxima',sprintf('for a line %d mm parallel from the tranducer', d)})
xlabel('Distance [mm]')
ylabel('Acoustic pressure [dB]')
axis tight

% TODO examine the properties of the acoustic fields at different places
% and with different central frequency following instructions for HW 1.2.2
% and HW 1.2.3 at https://cw.fel.cvut.cz/b232/courses/zsl/labs2024_09_ussim




%% BONUS apodization

points = []; TODO 
xdc_impulse(Th,y);
[hp, ~] = calc_hp(Th, points);

apo = 0; % TODO apodization weights for each element, 
xdc_apodization(Th,0,apo);
xdc_impulse(Th,y);
[hp1, ~] = calc_hp(Th, points);

figure()
hold on
Pm_i = max(abs(hp),[],1);
plot(x,20*log10(Pm_i/max(Pm_i)),'b')
Pm_i1 = max(abs(hp1),[],1);
plot(x,20*log10(Pm_i1/max(Pm_i1)),'r')
title({'Normalized pressure maxima','for a line 30 mm parallel from the tranducer'})
xlabel('Distance [mm]')
ylabel('Acoustic pressure [dB]')
legend('original','apodization (hann)')
axis tight


field_end

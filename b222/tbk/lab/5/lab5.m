clear all
close all
clc

%% Load data
sparam = sparameters('s11_vivaldi_ant.s1p');

Z0 = sparam.Impedance;
f=sparam.Frequencies;
sparam = reshape(sparam.Parameters, [],1);

f3_idx = find(f==3e9);
f8_idx = find(f==8e9);
f11_idx = find(f==11e9);

%%
s3 = sparam(f3_idx);
s8 = sparam(f8_idx);
s11 = sparam(f11_idx);

%%
z = reshape(s2z(sparam,Z0), [],1);

z3 = z(f3_idx);
z8 = z(f8_idx);
z11 = z(f11_idx);

real(z11);
imag(z11);

%%
g3 = abs(s3);
g8 = abs(s8);
g11 = abs(s11);

g11^2*100
(1-g11^2)*100
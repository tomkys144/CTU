clear all;
close all;
clc;

% m ... mark
% c ... credits

m = [1.5 1 3 1 1 2.5 2];
c = [4 6 6 0 0 4   3];

[E,SD,MED,W] = kos_prumer(m, c);

fprintf('Prumer: %.2f\nSmerodatna odchylka: %.2f\nMedian: %.2f\nVazeny prumer: %.2f\n', E, SD, MED, W);
%% vyhra
c = [1.27, 1.02, 4.70, 3.09, 9.00];
k = 3000;
x = vyhra(c, k)

% x = [0.0000e+00 2.6946e+03 0.0000e+00 1.1772e-13 3.0539e+02]' or
% x = [0.0000e+00 2.6946e+03 0.0000e+00 1.1772e-13 3.0539e+02]

c = [1.27, 4.70, 9.00];
k = 3000;
m = 400;
x = vyhra2(c, k, m)
% x = [2046.90 553.10 400.00]' or
% x = [2046.90 553.10 400.00]

%% minimax
x = [1 2 3 3 2; 4 1 2 5 6; 7 8 9 -5 7];
y = [7 4 1 2 5];
[a, b, r] = minimaxfit(x, y)

% a = [-2.776 0.194 -0.030]
% b = 9.403
% r = 0.194
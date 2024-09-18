% im = mean(double(imread('A.png')) / 255.0, 3);
im = mean(double(imread('ph.jpg')) / 255.0, 3);

[M, N] = size(im);

tx = 80;
ty = -15;
s = 1.2;
phi_rot = 30/180 * pi;
[cx, cy] = ffcenter(im);

% scale, rotate, translate:
[x, y] = meshgrid(1:N, 1:M);
[x_, y_] = translation(x, y, -tx, -ty);
[x_, y_] = scaling(x_, y_, 1 / s, cx, cy);
[x_, y_] = rotation(x_, y_, -phi_rot, cx, cy);
im_rst = interp2(im, x_, y_, 'linear', 0);

% fourier-mellin
[cx, cy] = ffcenter(im);
H = size(im, 2) - cx - 3;

[s_estimated, phi_estimated] = fourier_mellin(im, im_rst, H);

% undo rotation and scale:
[x, y] = meshgrid(1:N, 1:M);
[x_, y_] = rotation(x, y, -phi_estimated, cx, cy);
[x_, y_] = scaling(x_, y_, s_estimated, cx, cy);
scale_rot_undone = interp2(im_rst, x_, y_, 'linear', 0);

% also estimate translation:
[sx, sy] = phase_corr(im, scale_rot_undone);
[x_, y_] = translation(x, y, -sx, -sy);
all_undone = interp2(scale_rot_undone, x_, y_, 'linear', 0);

imagesc(im - all_undone); axis equal

im = mean(double(imread('A.png')) / 255.0, 3);

[M, N] = size(im);

% translate:
tx = 80;
ty = -15;
[x, y] = meshgrid(1:N, 1:M);
[x_, y_] = translation(x, y, -tx, -ty);
im_t = interp2(im, x_, y_, 'linear', 0);
imwrite(im_t, 'A_t_80_-15.png');

cx = 256; cy = 256;
s = 1.4;
[x_, y_] = scaling(x, y, 1 / s, cx, cy);
im_s = interp2(im, x_, y_, 'linear', 0);
imwrite(im_s, 'A_s_1.4.png');

phi = 30/180 * pi;
[x_, y_] = rotation(x, y, -phi, cx, cy);
im_r = interp2(im, x_, y_, 'linear', 0);
imwrite(im_r, 'A_r_30.png');

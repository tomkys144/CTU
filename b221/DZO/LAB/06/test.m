im1 = double(imread('./A.png')) / 255.0;
im2 = double(imread('./A_t_80_-15.png')) / 255.0;

[dx, dy] = phase_corr(im1, im2);

disp(dx)
disp(dy)

clear all
close all
clc
%% read input images

% A = double(imread('data/mona_lisa.png'));
% B = double(imread('data/ginevra_benci.png'));

A = double(imread('data/car_low.png'));
B = double(imread('data/car_high.png'));

figure("Name", "Input Images", "NumberTitle", "off")
subplot(121)
imshow(A / 255); title("A");
subplot(122)
imshow(B / 255); title("B")

%% compute gradients

[GxA, GyA] = calc_grad(A);

figure("Name", "Gradient Of Picture A", "NumberTitle", "off")
subplot(121)
imshow(GxA / 255 + 0.5); title("G_x");
subplot(122)
imshow(GyA / 255 + 0.5); title("G_y");

[GxB, GyB] = calc_grad(B);

figure("Name", "Gradient Of Picture B", "NumberTitle", "off")
subplot(121)
imshow(GxB / 255 + 0.5); title("G_x");
subplot(122)
imshow(GyB / 255 + 0.5); title("G_y");

%% read/generate mask

% M = double(imread('data/mona_mask.png'));

M = get_mask(GxA, GyA, GxB, GyB);

figure("Name", "Gradient Selection Mask", "NumberTitle", "off")
imshow(M / 255)
%% merge gradients

[Gx, Gy] = merge_grad(GxA, GyA, GxB, GyB, M);

figure("Name", "Merged Gradients", "NumberTitle", "off")
subplot(121)
imshow(Gx / 255 + 0.5); title("G_x");
subplot(122)
imshow(Gy / 255 + 0.5); title("G_y");

%% compute divergence

divI = calc_div(Gx, Gy);

figure("Name", "Divergence Of Merged Gradients", "NumberTitle", "off")
imshow(divI / 255 + 0.5);

%% compute naive merge

O = merge_image(A, B, M);

figure("Name", "Naive Merge", "NumberTitle", "off")
imshow(O / 255);
%% save naive merge

imwrite(O / 255, 'car_0_before.png');

%% solve using Gauss-Seidel

O = solve_GS(A, B, M, divI);

figure("Name", "Poisson GS", "NumberTitle", "off")
imshow(O / 255);

%% solve using Poisson

O = solve_FT(A, B, M, divI);

figure("Name", "Poisson FT", "NumberTitle", "off")
imshow(O / 255);
%% save output image

imwrite(O / 255, 'car_1_after.png');

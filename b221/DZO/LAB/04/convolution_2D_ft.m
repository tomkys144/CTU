function image_out = convolution_2D_ft(image, kernel)
%CONVOLUTION_2D_FT 2D convolution using Fourier Transform
% image:
%   the input grayscale image (2D array)
% kernel:
%   the convolutional kernel (2D array)

%% TODO 2: implement convolution using Fourier transform
isize = size(image);

I = fft2(image);
K = fft2(kernel,isize(1), isize(2));

O = I.*K;

image_out = ifft2(O);
end

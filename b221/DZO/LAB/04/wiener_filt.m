function image_out = wiener_filt(image, kernel, lambda)
%WIENER_FILT Wiener filtration
% image:
%   the input (blurred) grayscale image (2D array)
% kernel:
%   the convolutional kernel (2D array) which is causing the blur
% lambda:
%   parameter preventing the division by zero

% TODO 4: implement Wiener filter
% - transform both the image and the kernel into frequency domain, apply
%   the formula for the estimation of the unblured image and transform
%   the result back to the spatial domain
isize = size(image);
G = (fft2(image));
H = (fft2(kernel,isize(1),isize(2)));

H_con = conj(H);

F = (H_con .* G)./(abs(H).^2 + lambda);

image_out = ifft2(F);

image_out = abs(image_out);

end


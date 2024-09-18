function image_out = bilateral_filt( image, ksize, space_stddev, intensity_stddev )
%BILATERAL Implementation of a bilateral filter using Gaussian functions
% image:
%   the input (noisy) grayscale image (2D array)
% ksize:
%   size of the filtering window (1x2 matrix)
% space_stddev:
%   standard deviation of the Gaussian over pixel distances
% intensity_stddev:
%   standard deviation of the Gaussian over pixel value distances

%% TODO 5: implement Bilateral filter
% - go through all image (x,y) and filter window (s,t) coordinates
%   - do the DC padding as in your convolution_2D implementation
% - for each coordinate quadruple (x,y,s,t) compute the space weight
%   - Gaussian "G" over the distance of the current pixel (defined by 
%     (x,y,s,t)) from the window center pixel (x,y)
% - for each coordinate quadruple (x,y,s,t) compute the intensity weight
%   - Gaussian "b" over the difference of the pixel values at the current
%     pixel (defined by (x,y,s,t)) and the pixel at the window center (x,y)
% - multiply the weights and the current pixel and sum these over
%   the window
% - normalize each output pixel by the sum of the corresponding weight
isize = size(image);

image_out = zeros(isize);
center = ksize/2;

if mod(center(1),1) ~= 0
    center(1) = center(1)+0.5;
end

if mod(center(2),1) ~= 0
    center(2) = center(2)+0.5;
end

kernel = zeros(ksize);
for x=1:ksize(1)
    for y=1:ksize(2)
        kernel(x,y) = exp(-(((x-center(1))^2)/(space_stddev^2) + ((y-center(2))^2)/(space_stddev^2)));
    end
end
kernel = kernel ./ sum(sum(kernel));

kernel_center = ksize/2;
if mod(kernel_center(1),1) ~= 0
    kernel_center(1) = kernel_center(1)-0.5;
end

if mod(kernel_center(2),1) ~= 0
    kernel_center(2) = kernel_center(2)-0.5;
end

for s=1:isize(1)
    for t=1:isize(2)
        s_min = max(s-kernel_center(1),1);
        s_max = min(s+kernel_center(1),isize(1));
        t_min = max(t-kernel_center(2),1);
        t_max = min(t+kernel_center(2),isize(2));

        k_min = s_min-s+kernel_center(1)+1;
        k_max = s_max-s+kernel_center(1)+1;
        j_min = t_min-t+kernel_center(2)+1;
        j_max = t_max-t+kernel_center(2)+1;

        window = image(s_min:s_max, t_min:t_max);
        kernel_window = kernel(k_min:k_max, j_min:j_max);
        
        b = (1/intensity_stddev)*exp(-(window-(image(s,t)).^2/(intensity_stddev^2)));
        W = kernel_window.*b;
        image_out(s,t) = sum(W(:).*window(:))/sum(W(:));
    end
end
end
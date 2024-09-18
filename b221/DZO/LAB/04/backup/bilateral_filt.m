function image_out = bilateral_filt( image, ksize, space_stddev, intensity_stddev )
%BILATERAL Implementation of a bilateral filter using Gaussian functions
% image:
%   the input (noisy) grayscale image (2D array)
% ksize:
%   side size of the filtering window (scalar)
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
% - normalize each output pixel by the sum of the corresponding weights

image_out = zeros(size(image));

end


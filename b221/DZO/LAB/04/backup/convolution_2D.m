function image_out = convolution_2D(image, kernel)
%CONVOLUTION_2D 2D convolution between an image and kernel
% image:
%   the input grayscale image (2D array)
% kernel:
%   the convolutional kernel (2D array)

%% TODO 1a: implement brute-force convolution using loops
% - implement "DC" padding
%   - for the pixels in areas, where the kernel would look outside of
%     the original image, use the nearest image pixel (clip the coordinates)
image_out = zeros(size(image));
sz = size(image);
kernel_center = size(kernel)/2;
for x=1:sz(1)
    for y=1:sz(2)
        acc = 0;
        for k=1:size(kernel)
            posx = k-kernel_center(1);
            if mod(posx,1) ~= 0
                posx = posx - 0.5;
            end
            for j=1:size(kernel)
                posy = j-kernel_center(2);
                if mod(posy,1) ~= 0
                    posy = posy - 0.5;
                end
                if x+posx >= 1 && x+posx <= sz(1)
                    if y+posy >= 1 && y+posy <= sz(2)
                        acc = acc + image(x+posx, y+posy)*kernel(k,j);
                    end
                end
            end
        end
        image_out(x,y) = acc;
    end
end
end

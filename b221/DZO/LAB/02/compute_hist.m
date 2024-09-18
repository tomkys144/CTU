function [img_hist] = compute_hist(img, intensity_levels)
%COMPUTE_HIST Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('intensity_levels', 'var')
        intensity_levels = 256;
    end
    
    
    img_hist = zeros(intensity_levels, 1);
    
    norm = size(img,1)*size(img,2)
    
    for i=1:size(img,1)
        for j=1:size(img,2)
            i_lvl = round((intensity_levels-1)*img(i,j))+1;
            img_hist(i_lvl) = img_hist(i_lvl) + 1;
        end
    end
    
    img_hist = img_hist/norm;
end


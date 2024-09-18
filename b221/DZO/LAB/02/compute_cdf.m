function [img_cdf] = compute_cdf(img, intensity_levels)
%COMPUTE_CDF Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('intensity_levels', 'var')
        intensity_levels = 256;
    end
    
    hst = compute_hist(img, intensity_levels);
    
    img_cdf = zeros(intensity_levels,1);  % <= to be replaced
    
    img_cdf(1)=hst(1);
    
    for i=2:size(hst,1)
        img_cdf(i) = img_cdf(i-1)+hst(i);
    end
end


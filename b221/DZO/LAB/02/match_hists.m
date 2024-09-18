function img_matched = match_hists(img, img_target, intensity_levels)
if ~exist('intensity_levels', 'var')
    intensity_levels = 256;
end

% get both CDFs
cdf = compute_cdf(img, intensity_levels);
cdf_target = compute_cdf(img_target, intensity_levels);

% create histogram matching lookup table
matching_lut = zeros(intensity_levels, 1);
for i=1:length(cdf)
    lut = cdf(i);
    dist = abs(lut - cdf_target);
    [~, idx] = min(dist);
    
    matching_lut(i) = idx;
end

img_matched = zeros(size(img));

% match the histograms
for i=1:size(img,1)
    for j=1:size(img,2)
        l = img(i,j);
        idx = round(l*(intensity_levels-1)+1);
        idx_matched = matching_lut(idx);
        l_matched = (idx_matched-1)/(intensity_levels-1);
        
        img_matched(i,j) = l_matched;
    end
end

end

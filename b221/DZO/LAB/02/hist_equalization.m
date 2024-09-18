function eq_img = hist_equalization(img)
    intensity_levels = 256;
    img_size = size(img);

    % compute the image CDF
    img_cdf = compute_cdf(img, intensity_levels);

    % equalize the image
    eq_img = zeros(img_size);
    
    for i=1:size(img,1)
        for j=1:size(img,2)
            idx = round(img(i,j)*(intensity_levels-1)+1);
            eq_l = img_cdf(idx);
            eq_img(i,j) = eq_l;
        end
    end
end
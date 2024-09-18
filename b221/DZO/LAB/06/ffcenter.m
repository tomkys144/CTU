function [cx, cy] = ffcenter(im)
    c = floor((size(im) + 2) / 2);
    cx = c(2);
    cy = c(1);
end

function [dx, dy] = phase_corr(im1, im2)
    % function [dx, dy] = translation_from_phase_corr(im1, im2)
    % using phase correlation, this function computes
    % the vector (dx, dy) by which the second image im2 has to be shifted
    % so that it matches the first one (im1)
    isize = size(im1);
    f1 = fft2(im1);
    f2 = fft2(im2);

    r = (f2 .* conj(f1)) ./ abs(f2 .* f1);

    Ir = ifftshift(ifft2(r));

    IR_max = max(max(Ir));

    [dx, dy] = find(Ir == IR_max);

    dx = dx - floor(isize(1) / 2) - 1;
    dy = dy - floor(isize(2) / 2) - 1;
end

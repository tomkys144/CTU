function [x0, y0, r] = fit_circle_ransac(X, num_iter, threshold)
    % function [x0 y0 r] = fit_circle_ransac(X, num_iter, threshold)
    %
    % INPUT:
    % X: n-by-2 vector
    %    with data
    % num_iter: number of RANSAC iterations
    % threshold: maximal  distance of an inlier from the circumference
    %
    % OUTPUT:
    % cartesian coordinates of the circle

    best_num = 0;
    best_x = 0;
    best_y = 0;
    best_r = 0;

    for i = 1:num_iter
        idx = round((size(X, 1) - 1) * rand(3, 1) + 1);
        X_part = X(idx, :);

        [e, d, f] = fit_circle_nhom(X_part);

        [x0, y0, r] = quad_to_center(d, e, f);

        point_dist = dist(X, x0, y0, r);

        res = zeros(size(point_dist));
        res(abs(point_dist) <= threshold) = 1;

        if best_num < sum(res)
            best_num = sum(res);
            best_x = x0;
            best_y = y0;
            best_r = r;
        end

    end

    x0 = best_x;
    y0 = best_y;
    r = best_r;
end

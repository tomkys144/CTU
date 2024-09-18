function [x, y, r] = GN_iter(X, x0, y0, r0)
    % [x y r] = GN_iter(X, x0, y0, r0)
    %
    % makes the Gauss-Newton iteration.
    %
    % INPUT:
    % X: n-by-2 matrix
    %    with data
    % x0, y0 are the coordinates of the circle center.
    % r0 is the circle radius
    %
    % OUTPUT:
    % coordinates and radius after one step of GN method.

    g = dist(X, x0, y0, r0);

    dx = ((x0 - X(:, 1)) ./ sqrt((x0 - X(:, 1)).^2 + (y0 - X(:, 2)).^2))';
    dy = ((y0 - X(:, 2)) ./ sqrt((x0 - X(:, 1)).^2 + (y0 - X(:, 2)).^2))';
    dr = -1 * ones(1, length(dx));

    g_der = [dx; dy; dr];

    K = [x0; y0; r0];

    tmp1 = inv(g_der * g_der');
    tmp2 = tmp1 * g_der;
    res = tmp2 * g';
    K_new = K - res;

    x = K_new(1);
    y = K_new(2);
    r = K_new(3);
end

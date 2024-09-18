function [x y r] = grad_iter(X, x0, y0, r0, a)
    % [x y r] = grad_iter(X, x0, y0, r0, a)
    %
    % makes the gradient method iteration.
    %
    % INPUT:
    % X: n-by-2 matrix
    %    with data
    % x0, y0 are the coordinates of the circle center.
    % r0 is the circle radius
    % a is the stepsize
    %
    % OUTPUT:
    % coordinates and radius after one step of gradient method.

    K = [x0; y0; r0];

    dx = -2 * ((X(:, 1) - x0) .* (sqrt((X(:, 1) - x0).^2 + (X(:, 2) - y0).^2) - r0)) ./ sqrt((X(:, 1) - x0).^2 + (X(:, 2) - y0).^2);
    dy = -2 * ((X(:, 2) - y0) .* (sqrt((X(:, 1) - x0).^2 + (X(:, 2) - y0).^2) - r0)) ./ sqrt((X(:, 1) - x0).^2 + (X(:, 2) - y0).^2);
    dr = -2 * (sqrt((X(:, 1) - x0).^2 + (X(:, 2) - y0).^2) - r0);

    f_der = [sum(dx); sum(dy); sum(dr)];

    K_new = K - a * f_der;

    x = K_new(1);
    y = K_new(2);
    r = K_new(3);
end

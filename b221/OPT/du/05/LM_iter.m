function [x, y, r, success] = LM_iter(X, x0, y0, r0, mu)
    % [x y r success] = LM_iter(X, x0, y0, r0, mu)
    %
    % makes the Levenberg-Marquardt iteration.
    %
    % INPUT:
    % X: n-by-2 matrix
    %    with data
    % x0, y0 are the coordinates of the circle center.
    % r0 is the circle radius
    % mu is the damping factor (the factor which multiplies the
    % regularizing identity matrix)

    % OUTPUT:
    % success == 1 if the iteration is successful, i.e.
    % value of criterion f is decreased after the update
    % of x.
    % success == 0 in the oposite case.
    %
    % x,y,r are updated parameters if success == 1.
    % x,y,r = x0,y0,r0 if success == 0.

    f = get_objective_function(X);

    g = dist(X, x0, y0, r0);

    dx = ((x0 - X(:, 1)) ./ sqrt((x0 - X(:, 1)).^2 + (y0 - X(:, 2)).^2))';
    dy = ((y0 - X(:, 2)) ./ sqrt((x0 - X(:, 1)).^2 + (y0 - X(:, 2)).^2))';
    dr = -1 * ones(1, length(dx));

    g_der = [dx; dy; dr];

    K = [x0; y0; r0];

    tmp1 = inv((g_der * g_der') + (mu * eye(3)));
    tmp2 = tmp1 * g_der;
    res = tmp2 * g';
    K_new = K - res;

    if f(K_new) < f(K)
        success = 1;
        x = K_new(1);
        y = K_new(2);
        r = K_new(3);
    else
        success = 0;
        x = K(1);
        y = K(2);
        r = K(3);
    end

end

function [d, e, f] = fit_circle_hom(X)
    % function [d e f] = fit_circle_hom(X)
    %
    % INPUT:
    % X: n-by-2 vector
    %    with data
    %
    % OUTPUT:
    % quadric coordinates of the circle

    A = [X(:, 1).^2 + X(:, 2).^2 X(:, 1) X(:, 2) ones(size(X, 1), 1)];

    [~, ~, V] = svd(A);

    sol = V(:, end);

    a = (sol(1));
    d = (sol(2)) / a;
    e = (sol(3)) / a;
    f = (sol(4)) / a;
end

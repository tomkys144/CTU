function [d, e, f] = fit_circle_nhom(X)
    % function [d e f] = fit_circle_nhom(X)
    %
    % INPUT:
    % X: n-by-2 vector
    %    with data
    %
    %
    % OUTPUT:
    % quadric coordinates of the circle

    A = [X ones(size(X, 1), 1)];
    b = (- (X(:, 1).^2) - (X(:, 2).^2));

    sol = A \ b;

    d = sol(1);
    e = sol(2);
    f = sol(3);
end

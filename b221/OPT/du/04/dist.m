function d = dist(X, x0, y0, r)
    % function d = dist(X,x0,y0,r)
    %
    % INPUT:
    % X: n-by-2 vector
    %    with data
    % x0, y0 are the coordinates of the circle center.
    % r is the circle radius
    %
    % OUTPUT:
    % d: 1-by-N vector of *signed* distances of all points
    %    from the circumference.

    [N, ~] = size(X);
    d = zeros(1, N);

    for i = 1:N
        dist = sqrt((X(i, 1) - x0)^2 + (X(i, 2) - y0)^2);

        if dist < 0
            d(i) = dist + r;
        else
            d(i) = dist - r;
        end

    end

end

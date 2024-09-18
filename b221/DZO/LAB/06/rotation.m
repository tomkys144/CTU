function [x_, y_ ] = rotation(x, y, phi, cx, cy)
    % function [x_, y_ ] = rotation(x, y, phi, cx, cy)
    % rotates points in anticlockwise direction by phi
    % around center (cx, cy).

    C = cos(phi);
    S = sin(phi);
    x_ = C * (x - cx) - S * (y - cy) + cx;
    y_ = S * (x - cx) + C * (y - cy) + cy;
end

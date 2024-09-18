function [x_, y_] = scaling(x, y, s, cx, cy)
    % function [x_, y_ ] = scaling(x, y, s, cx, cy)
    % scales points by s from center (cx, cy).
    %    x_ = s * (x - cx) + cx;
    %    y_ = s * (y - cy) + cy;

    x_ = s * (x - cx) + cx;
    y_ = s * (y - cy) + cy;
end

function [Gx, Gy] = calc_grad(I)
    kernel_x = [-1; 1];
    kernel_y = [-1 1];

    isize = size(I);
    ksize_x = size(kernel_x);
    ksize_y = size(kernel_y);
    k_center_x = ksize_x/2;
    k_center_y = ksize_y/2;

    Gx = zeros(isize);
    Gy = zeros(isize);

    for x = 1 : isize(1)
        for y = 1 : isize(2)
            acc = 0;
            for k = 1 : ksize_x(1)
                posx = k - k_center_x(1);
                if mod(posx, 1) ~= 0
                    posx = posx - 0.5;
                end

                for j = 1 : ksize_x(2)
                    posy = j - k_center_x(2);
                    if mod(posy, 1) ~= 0
                        posy = posy - 0.5;
                    end

                    if x + posx >=1 && x + posx <= isize(1)
                        if y + posy >= 1 && y + posy <= isize(2)
                            tmp = I(x + posx, y + posy, :) * kernel_x(k, j);
                            acc = acc + tmp;
                        end
                    end
                end
            end
            Gx(x, y, :) = acc;

            acc = 0;
            for k = 1 : ksize_y(1)
                posx = k - k_center_y(1);
                if mod(posx, 1) ~= 0
                    posx = posx - 0.5;
                end

                for j = 1 : ksize_y(2)
                    posy = j - k_center_y(2);
                    if mod(posy, 1) ~= 0
                        posy = posy - 0.5;
                    end

                    if x + posx >=1 && x + posx <= isize(1)
                        if y + posy >= 1 && y + posy <= isize(2)
                            acc = acc + (I(x + posx, y + posy, :) * kernel_y(k, j));
                        end
                    end
                end
            end
            Gy(x, y, :) = acc;

        end
    end

    % Gxmax = max(Gx, [], 'all');
    % Gxmin = min(Gx, [], 'all');
    % Gx = 255 / (Gxmax - Gxmin) * (Gx - Gxmin);
    % Gx = Gx + (255 / 2);

    % Gymax = max(Gy, [], 'all');
    % Gymin = min(Gy, [], 'all');
    % Gy = 255 / (Gymax - Gymin) * (Gy - Gymin);
    % Gy = Gy + (255 / 2);
end

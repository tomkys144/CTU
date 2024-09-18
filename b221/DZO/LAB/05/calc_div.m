function [divI] = calc_div(Gx, Gy)
    kernel_x = [-1; 1];
    kernel_y = [-1 1];

    isize = size(Gx);
    ksize_x = size(kernel_x);
    ksize_y = size(kernel_y);
    k_center_x = ksize_x/2;
    k_center_y = ksize_y/2;

    div_x = zeros(isize);
    div_y = zeros(isize);

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
                            tmp = Gx(x + posx, y + posy, :) * kernel_x(k, j);
                            acc = acc + tmp;
                        end
                    end
                end
            end
            div_x(x, y, :) = acc;

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
                            acc = acc + (Gy(x + posx, y + posy, :) * kernel_y(k, j));
                        end
                    end
                end
            end
            div_y(x, y, :) = acc;

        end
    end

    divI = div_x + div_y;

    % divImax = max(divI, [], 'all');
    % divImin = min(divI, [], 'all');
    % divI = 255 / (divImax - divImin) * (divI - divImin);
end

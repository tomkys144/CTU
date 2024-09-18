function O = solve_GS(A, B, M, divI)
    O = merge_image(A, B, M);

    isize = size(O);

    max_iter = 10^2;

    textprogressbar('Solving Poisson equation iteratively using Gauss-Seidel method ');

    for i = 1:max_iter

        for x = 1:isize(1)

            for y = 1:isize(2)

                if M(x, y) ~= -1
                    acc = zeros(1, 1, 3);

                    if (x + 1) <= isize(1)
                        acc = acc + O(x + 1, y, :);
                    else
                        acc = acc + O(x, y, :);
                    end

                    if (x - 1) >= 1
                        acc = acc + O(x - 1, y, :);
                    else
                        acc = acc + O(x, y, :);
                    end

                    if (y + 1) <= isize(2)
                        acc = acc + O(x, y + 1, :);
                    else
                        acc = acc + O(x, y, :);
                    end

                    if (y - 1) >= 1
                        acc = acc + O(x, y - 1, :);
                    else
                        acc = acc + O(x, y, :);
                    end

                    res = acc - divI(x, y, :);
                    res = res / 4;
                    O(x, y, :) = res;
                end

            end

        end

        textprogressbar((i / max_iter) * 100);
    end

    textprogressbar('Done');
end

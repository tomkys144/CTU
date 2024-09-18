function [a, b, r] = minimaxfit(x, y)
    % min z
    % cr.
    % |sum(xa)+b-y| <= z -> ...
    % sum(xa) + b - ky - z <= 0
    % -sum(xa) - b + ky - z <= 0
    % k = 1

    [m, n] = size(x);

    f = [zeros(1, m) 0 0 1]; % x = [a1 ... am b k z]

    A = [x' ones(n, 1) -y' -ones(n, 1);
         -x' -ones(n, 1) y' -ones(n, 1)];
    b = zeros(2 * n, 1);

    Aeq = [zeros(1, m) 0 1 0];
    beq = 1;

    [res, r] = linprog(f, A, b, Aeq, beq);

    a = res(1:end - 3);
    b = res(end - 2);
end

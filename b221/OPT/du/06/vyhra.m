function x = vyhra(c, k)
    % min z
    % cr.
    % x1 + x2 + x3 + x4 + x5 = k
    % c1 * x1 + c2 * x2 - z <= 0
    % c2 * x2 + c3 * x3 + c4 * x4 - z <= 0
    % c4 * x4 + c5 * x5 - z <= 0
    % x,z >= 0
    f = [zeros(1, 5) -1];

    A = [-c(1) -c(2) 0 0 0 1;
         0 -c(2) -c(3) -c(4) 0 1;
         0 0 0 -c(4) -c(5) 1];
    b = [0 0 0];

    Aeq = [ones(1, 5) 0];
    beq = k;

    lb = zeros(1, 5 + 1);

    res = linprog(f, A, b, Aeq, beq, lb);
    x = res(1:end - 1);
end

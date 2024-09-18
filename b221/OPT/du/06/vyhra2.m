function x = vyhra2(c, k, m)
    f = [zeros(1, 3) -1];

    A = [-c(1) 0 0 1;
         0 -c(2) 0 1;
         0 0 -c(3) 1];
    b = [0 0 0];

    Aeq = [ones(1, 3) 0];
    beq = k;

    lb = [m * ones(1, 3) 0];
    ub = inf * ones(1, 3 + 1);

    res = linprog(f, A, b, Aeq, beq, lb, ub);
    x = res(1:end - 1);
end

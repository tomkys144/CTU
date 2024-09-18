function O = solve_FT(A, B, M, divI)
    isize = size(divI);
    L = [0 1 0; 1 -4 1; 0 1 0];

    divIf = fft2(divI);
    Lf = fft2(L, isize(1), isize(2));

    Lf_con = conj(Lf);
    lambda = 10^(-30);

    Of = (Lf_con .* divIf) ./ (abs(Lf).^2 + lambda);
    O = real(ifft2(Of));

    Omax = max(O, [], 'all');
    Omin = min(O, [], 'all');
    O = 255 / (Omax - Omin) * (O - Omin);
end

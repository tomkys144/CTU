function x = fit_temps(t,T, omega)
%FIT_TEMPS Summary of this function goes here

tmp1 = ones(size(t));
tmp2 = sin(omega*t);
tmp3 = cos(omega*t);

P = [tmp1, t, tmp2, tmp3];

x = P\T;
end


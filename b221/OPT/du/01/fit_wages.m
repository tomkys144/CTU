function x = fit_wages(t,M)
%FIT_WAGES Summary of this function goes here
%   Detailed explanation goes here

tmp = ones(size(t));

P = [tmp, t];

x = P\M;
end


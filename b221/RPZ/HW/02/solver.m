syms x y ux uy sx sy r;

cov = [sx^2 r*sx*sy; r*sx*sy sy^2];
u = [ux;uy];
f = [x;y];

fxy = 1/(2*pi*sx*sy*sqrt(1-r^2))*exp((-1)/(2*(1-r^2))*(((x-ux)/sx)^2-2*r*((x-ux)/sx)*((y-uy)/sy)+((y-uy)/sy)^2));

S = solve(fxy == 0,[x y]);

disp(S.x)
close all
clear all
clc

%% init
x = sym('x');
y = sym('y');
z = x*y;

g = [x+y-z-1; -x+y+z+3; x-y+z-1];

N = 200;

X0 = [10 10];

%% gradient

grad = [diff(g,x) diff(g,y)];

disp(grad)

X = X0;

for k=1:N-1
    gk = subs(g,[x y],X);
    gradk = subs(grad,[x y], X);
    disp (gk,gradk)
    X = gk-gradk;
    disp (X);
end
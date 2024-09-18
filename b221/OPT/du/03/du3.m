load line;
subplot(221)
drawfitline(A);

A=load('data/walk4.txt')';
conn=load('data/connected_points.txt');

k = 2
[U, C, b0] = fitaff(A, 2);
subplot(222)
playmotion(conn,A,U*C + b0);
subplot(223)
plottraj2(C);

subplot(224)
d = erraff(A);
semilogy(d(1:end-1))

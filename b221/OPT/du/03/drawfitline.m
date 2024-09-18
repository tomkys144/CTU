function drawfitline(A)
% function drawfitline(A)
%
% INPUT:
% A: m-by-2 matrix
%    with data
%
[U,C,b0] = fitaff(A,1);

B = b0 + U*C;

[Min, i_min] = min(B(1,:));
[Max, i_max] = max(B(1,:));
plot([Min Max],[B(2,i_min) B(2,i_max)], "Color","green");
hold on
plot(A(1,:), A(2,:), "Color","red","LineStyle","none","Marker","x")
for i=1:size(A,2)
    plot([A(1,i) B(1,i)],[A(2,i) B(2,i)], "Color","red")
end
hold off
axis equal
end

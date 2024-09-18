function plottraj2(C)
% function plottraj2(C)
%
% INPUT: 
% C: 2-by-m matrix
%    with data
%

for i=1:size(C,2)-1
    plot([C(1,i) C(1,i+1)],[C(2,i) C(2,i+1)], "Color","red")
    hold on
end

hold off
end
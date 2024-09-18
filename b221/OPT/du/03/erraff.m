function d = erraff(A)
% function d = erraff(A)
%
% INPUT: 
% A: m-by-n matrix
%    with data
%
% OUTPUT:
% d: m-by-1 matrix
%
a_cog = sum(A,2)/size(A,2);
tmp = repmat(a_cog, [1, size(A,2)]);
A_cog = A-tmp;
e = eig(A_cog*A_cog');


d = zeros(size(A,1),1);

for k=1:size(A,1)
    d(k) = sum(e(1:end-k));
end
end

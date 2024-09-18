function [U,C] = fitlin(A,k)
% function [U,C] = fitlin(A,k)
%
% INPUT: 
% A: m-by-n matrix
%    with data
% k: scalar, dimension of linear approximation
%
% OUTPUT:
% U: m-by-k matrix
%	columns form an orthonormal basis
% C: k-by-n matrix
%	columns contain coordinates w.r.t the basis
%
tmp = A*A';
[V,~] = eig(tmp);

U = V(:,end-k+1:end);
C = U'*A;

end
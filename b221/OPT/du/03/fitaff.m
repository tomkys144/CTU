function [U,C,b0] = fitaff(A,k)
% function [U,C,b0] = fitaff(A,k)
%
% INPUT: 
% A: m-by-n matrix
%    with data
% k: scalar, dimension of affine approximation
%
% OUTPUT:
% U: m-by-k matrix
%	columns form an orthonormal basis
% C: k-by-n matrix
%	columns contain coordinates w.r.t the basis
% b0: m-by-1 matrix
%	point of the affine space
%

a_cog = sum(A,2)/size(A,2);
tmp = repmat(a_cog, [1, size(A,2)]);
A_cog = A-tmp;

[U, C] = fitlin(A_cog,k);

b0 = a_cog;

end
function XC2=dctxc2(x) ;

% Function DCTXC2: Discrete cosine transform  
%                  DCT-2 Oppenheim definition (2N extension)
%
% Usage:  XC2=dctxc2(x)
%   x    ... discrete-time real sequence
%   XC2  ... discrete cosine transform sequence

N=length(x) ;
beta=[1/2 ones(1,N-1)];

dctmtx2=zeros(N) ;
n=1:N;
for k=1:N,
    dctmtx2(k,:)=cos(pi*(k-1)*(2*(n-1)+1)/(2*N));
end


XC2=2*dctmtx2*(x(:));


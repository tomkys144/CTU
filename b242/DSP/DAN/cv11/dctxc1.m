function XC1=dctxc1(x) ;

% Function DCTXC1: Discrete cosine transform  
%                  DCT-1 Oppenheim definition (2N-2 extension)
%
% Usage:  XC1=dctxc1(x)
%   x    ... discrete-time real sequence
%   XC1  ... discrete cosine transform sequence

N=length(x) ;
alpha=[1/2 ones(1,N-2) 1/2]';

dctmtx1=zeros(N) ;
n=1:N;
for k=1:N,
    dctmtx1(k,:)=cos(pi*(k-1)*(n-1)/(N-1));
end



XC1=(2)*dctmtx1*(x(:).*alpha);

function x=idctxc2(XC2) ;

% Function IDCTXC2: Inverse Discrete cosine transform  
%                   DCT-2 Oppenheim definition (2N extension)
%
% Usage:  XC2=idctxc2(XC2)
%   XC2  ... discrete cosine transform sequence
%   x    ... discrete-time real sequence

N=length(XC2) ;
beta=[1/2 ones(1,N-1)];

idctmtx2=zeros(N) ;
k=1:N;
for n=1:N,
    idctmtx2(n,:)=cos(pi*(2*(n-1)+1)*(k-1)/(2*N));
end
x=idctmtx2*(XC2(:).*beta')./N;

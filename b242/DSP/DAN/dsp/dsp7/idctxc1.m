function x=idctxc1(XC1) ;

% Function IDCTXC1: Inverse Discrete cosine transform  
%                   IDCT-1 Oppenheim definition (2N-2 extension)
%
% Usage:  x=idctxc1(XC1)
%   XC1  ... discrete cosine transform sequence
%   x    ... discrete-time real sequence

N=length(XC1) ;
alpha=[1/2 ones(1,N-2) 1/2]';

idctmtx1=zeros(N) ;
k=1:N;
for n=1:N,
    idctmtx1(n,:)=cos(pi*(k-1)*(n-1)/(N-1));
end

x=idctmtx1*(XC1(:).*alpha)./(N-1);

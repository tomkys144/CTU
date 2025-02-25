function c_d = diffceps ( c, N ) ;
%Function DIFFCEPS: Differential (delta) cepstrum computation.
%
%Usage: deltacep = diffceps ( incep, N ) ;
%
%Input parameters:
%    incep - matrix of cepstral coefficients (particular cepstra are in rows)
%    N - order of numerical estimation of the first derivative
%
%Outputs:
%   outcep - matrix of delta cepstral coefficients 

%                              Made by PP
%                            CVUT FEL K13131
%                         Last change 7 Dec 2016

firstc=c(1,:);
length_c = size ( c, 1 ) ;
lastc=c(length_c,:);

for i=1:N,
    c=[firstc; c; lastc] ;  
end;

length_c = size ( c, 1 ) ;
order_c = size ( c, 2 ) ;



for i=N+1:length_c-N,
  
  c_d(i-N,:) = zeros(1,order_c) ;
  pom = 0 ;
  for j=1:N,
    c_d(i-N,:) = c_d(i-N,:) + j*c(i+j,:) - j*c(i-j,:) ;
    pom = pom + j*j ;
  end ;
  c_d(i-N,:) = c_d(i-N,:) ./ pom ;
  
end


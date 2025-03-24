%Function CD5: Exponentially weighted distance of two cepstral vectors.
%
%Usage: D=cd5(c1,c2,p);
%  c1  - the first vector of cepstral coefficients - !! WITHOUT c[0] !!
%  c2  - the second vector of cepstral coefficients  - !! WITHOUT c[0] !!
%  p   - number of cepstral coefficients
%                                           <minimum of length(c1),length(c2)>

%                 Made by Petr Pollak, 28.4.1994

function D=cd5(c1,c2,p);

if nargin<3,
  p=min([length(c1) length(c2)]);
elseif  p<min([length(c1) length(c2)]),
  p=min([length(c1) length(c2)]);
end;

c1=c1(1:p);
c2=c2(1:p);

w=1*exp(-(0:p-1));

D=sum(w.*w.*((c1-c2).^2));

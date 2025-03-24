%potlačování šumu ve stacionárním signálu
%filtrace ve frekvenční oblasti
% OLA s obecným oknem -> segmentace s překryvem ->
%    xi[n] -> DFT -> Xi[k] -> Wienerův filtr ->Yi[k] -> IDFT -> yi[n] ->
% -> sčítání překryvů
%
% Wienerův filtr H[k] = sqrt(Ss[k]/Sx[k]) - výkonová spektra Ss - výkonový
% spektrum čistého signálu, Sx - výkonové spektrum signálu se šumem
% x[n] = s[n] + u[n]
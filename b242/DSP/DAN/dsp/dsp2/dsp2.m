%LPC - linear predictive coding -> reprezentace signálu méně parametry
%kritérium - minimalizace výkonu chybového signálu
%normální rovnice
%[R0 .  Rp-1][a1]    [R1]
%[R1  .    .][. ] = -[. ]
%[Rp-1 .  R0][ap]    [Rp]
%řád prediktoru maximálně desítky (komprese)
%funkce [koeficienty, výkon chyby predikce]=lpc(signál,řád filtru)


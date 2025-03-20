#import "@local/ctu-report:0.1.0": *
#import "@preview/subpar:0.2.1"
#import "@preview/unify:0.7.1": unit

#show: it => ctu-report(
  doc-category: "BAM31BSG Laboratorní protokol",
  doc-title: "Lab 04: Hlas a řeč",
  author: "Tomáš Kysela",
  language: "cs",
  show-outline: false,
  it,
)

#set par(justify: true)

= Analýza vlastní řeči

#figure(
  table(
    columns: 6,
    [], [*a*], [*e*], [*i*], [*o*], [*u*],
    [*F0 (Hz)*], [103.62], [108.30], [113.93], [116.25], [155.28],
    [*F1 (Hz)*], [716.13], [603.95], [245.28], [555.38], [326.11],
    [*F2 (Hz)*], [1161.18], [1742.91], [2298.63], [965.04], [831.40],
    [*F3 (Hz)*], [2458.85], [2380.06], [3182.10], [2696.07], [2432.25],
    [*F4 (Hz)*], [3883.95], [3673.59], [3899.48], [4031.29], [3564.43],
    [*F5 (Hz)*], [4931.69], [4901.36], [4859.05], [4703.95], [4724.29],
    [*BW1 (Hz)*], [145.28], [44.02], [40.48], [173.92], [119.48],
    [*BW2 (Hz)*], [105.28], [231.90], [78.60], [93.41], [178.32],
    [*BW3 (Hz)*], [577.65], [730.82], [367.29], [318.37], [374.01],
    [*BW4 (Hz)*], [170.81], [260.74], [319.12], [277.41], [480.21],
    [*BW5 (Hz)*], [297.97], [430.74], [346.44], [1346.17], [347.44],
    [*Jitter (#sym.mu\s)*], [64.81], [30.83], [29.24], [25.34], [9.17],
    [*Shimmer (dB)*], [0.40], [0.38], [0.40], [0.23], [0.19],
    [*NHR*], [0.105578], [0.010531], [0.015106], [0.006568], [0.002538],
  ),
  caption: [ Naměřené parametry nahrávek ],
)

= Syntéza řeči
#figure(
  table(
    columns: 6,
    [], [*a*], [*e*], [*i*], [*o*], [*u*],
    [*F0 (Hz)*], [103], [108], [114], [116], [155],
    [*F1 (Hz)*], [718], [605], [245], [555], [324],
    [*F2 (Hz)*], [1200], [1750], [2300], [965], [900],
    [*F3 (Hz)*], [2470], [2380], [3180], [2696], [2432],
    [*F4 (Hz)*], [3884], [3680], [3900], [4031], [3564],
    [*F5 (Hz)*], [4931], [4900], [4860], [4704], [4724],
    [*F6 (Hz)*], [5100], [5010], [5100], [5000], [5023],
    [*BW1 (Hz)*], [145], [44], [41], [174], [100],
    [*BW2 (Hz)*], [105], [232], [79], [93], [178],
    [*BW3 (Hz)*], [578], [730], [367], [318], [45],
    [*BW4 (Hz)*], [171], [261], [319], [277], [300],
    [*BW5 (Hz)*], [298], [431], [346], [1346], [347],
    [*BW6 (Hz)*], [596], [300], [300], [600], [400],
  ),
  caption: [ Parametry užité k syntéze řeči ],
)

= Spektrální analýza nahrávek

#figure(
  image("Figure_4.png"),
  caption: [ Spektrogramy nahrávek ],
)

= Závěr

Z nahrávek je poznat, že v syntéze řeči chybí Jitter, Shimmer, či nedokonalosti hlasivek pro generování zvuku. Díky nim a nedostatku intonace je snadno rozpoznatelné, kterou nahrávku jsme nahrávali od člověka a která byla uměle generována.

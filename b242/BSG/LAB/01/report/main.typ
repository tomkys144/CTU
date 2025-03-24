#import "@local/ctu-report:0.1.0": *
#import "@preview/subpar:0.2.1"

#show: it => ctu-report(
  doc-category: "BAM31BSG Laboratorní protokol",
  doc-title: "Lab 01: Měření a hodnocení doby reakce",
  author: "Tomáš Kysela",
  language: "cs",
  show-outline: false,
  it,
)

#set par(justify: true)

= Úvod

Reakční doba je časový interval mezi podnětem (světelným nebo zvukovým) a odpovědí subjektu. Rychlost reakce ovlivňují
faktory jako typ a intenzita podnětu, úroveň pozornosti, věk, únava nebo trénovanost. Cílem úlohy je měřit reakční časy
a ověřit zda muži mají kratší reakční dobu než ženy.

= Metodika

Měřené probíhalo pomocí přístroje Biopac, pomocí vzorové úlohy #link("https://www.biopac.com/curriculum/l11-reaction-time-i-auditory-stimulus/")[ L11 Reaction Time I ].

= Analýza dat

Vypočtené hodnoty byl rozděleny do skupin podle časování stimulů a dle pohlaví měřeného subjektu, viz @hodnoty, @boxplot
a @histogram.

Pomocí SW testu normality jsme ověřili že náhodná data u muže mohou být normálně rozdělena, $ p = .1376$, u ženy mohou
být normálně rozdělena, $p = .2385$, periodická u muže mohou být normálně rozdělena, $p = .1519$, a u ženy nejsou
normálně rozdělena, $p = .0233$.

Pomocí t-testu jsme ověřili, že není významný rozdíl mezi reakční dobou na náhdoný stimul u ženy a muže, $t(38) = .7804, p = .44$.

Pomocí M-W testu jsme ověřili, že ženy reakční doba na periodický signál je kratší než u muže, $p=0.00014$.

#figure(
  table(
    columns: 5,
    table.header([], [*Náhodné muž*], [*Náhodné žena*], [*Periodické muž*], [*Periodické žena*]),
    [1], [0.2280], [0.2420], [0.3020], [0.1960],
    [2], [0.3278], [0.2220], [0.2920], [0.1720],
    [3], [0.1900], [0.2400], [0.2100], [0.1560],
    [4], [0.2180], [0.2560], [0.2320], [0.2920],
    [5], [0.2220], [0.2540], [0.2360], [0.1800],
    [6], [0.2820], [0.2540], [0.2420], [0.1800],
    [7], [0.2600], [0.2080], [0.2520], [0.2080],
    [8], [0.2100], [0.2420], [0.2300], [0.2100],
    [9], [0.2300], [0.2300], [0.2580], [0.2180],
    [10], [0.2240], [0.2120], [0.2160], [0.1880],
    [11], [0.1880], [0.1980], [0.2540], [0.2020],
    [12], [0.2460], [0.2060], [0.3200], [0.1760],
    [13], [0.2340], [0.2300], [0.2540], [0.2160],
    [14], [0.2200], [0.2420], [0.1880], [0.2480],
    [15], [0.2740], [0.2300], [0.1920], [0.1840],
    [16], [0.2520], [0.2460], [0.2080], [0.1640],
    [17], [0.2520], [0.2580], [0.2320], [0.1560],
    [18], [0.2060], [0.2120], [0.2180], [0.2060],
    [19], [0.2440], [0.2200], [0.2120], [0.2120],
    [20], [0.2373], [0.2120], [0.2280], [0.1740],
    [*$mu$*], [*0.2373*], [*0.2370*], [*0.2388*], [*0.1969*],
    [*$sigma$*], [*0.0327*], [*0.0187*], [*0.0348*], [*0.0324*],
    [*min*], [*0.1880*], [*0.1980*], [*0.1880*], [*0.1560*],
    [*max*], [*0.3280*], [*0.2580*], [*0.3200*], [*0.2920*],
  ),
  caption: [ Tabulka naměřených reakčních časů (s) ],
) <hodnoty>

#figure(image("assets/hist.png"), caption: [Boxplot naměřených výsledků]) <boxplot>

#subpar.grid(
  figure(image("assets/rand.png"), caption: [ Náhodné časování stimulů ]),
  <rand>,
  figure(image("assets/per.png"), caption: [ Periodické časování stimulů ]),
  <per>,
  caption: [ Histogramy rozložení měření ],
  label: <histogram>,
)

= Závěr

Úvodní hypotézu jsme vyvrátili,avšak je pravděpodobné, že při opakovaném měření více subjektů by došlo k potvrzení
hypotézy.

= Otázky

1) 8.5692 metru

#import "@local/ctu-report:0.1.0": *
#import "@preview/subpar:0.2.1"
#import "@preview/unify:0.7.1": *

#show: it => ctu-report(
  doc-category: "BAM31BSG Laboratorní protokol",
  doc-title: "Lab 03: Analýza svalové únavy",
  author: "Tomáš Kysela",
  language: "cs",
  show-outline: false,
  it,
)

#set par(justify: true)

= Úvod

Svalová únava je proces postupného poklesu schopnosti svalu vyvíjet sílu, který je způsoben metabolickými změnami a změnami v aktivaci motorických jednotek. Pro objektivní hodnocení únavy se využívá elektromyografie (EMG), která umožňuje sledovat změny ve spektru signálu.

= Metodika

Měření probíhala pomocí přístroje Biopac. Na předloktí byly umístěny elektrody do pozic pro měření flexorů zápěstí. @criswell2011cram Následně byl proveden stisk dynamometru co nejdéle subjekt vydržel, obvykle přibližně 2 minuty.

#figure(image("assets/flexor.png", width: 4cm), caption: [Umístění elektrod při experimentu @Kysela2024])

= Analýza dat

#figure(image("assets/data.png"), caption: [ Naměřená data ])

Byl vybrán úsek počínající prvním vyvinutím 80% maximální síly a končící na 45%. Tento úsek byl rozdělen na segmenty délky 1 sekunda s překryvem 50%. V jednotlivých segmentech byly analyzovány parametry _Směrodatná odchylka_, _Peak-to-peak amplituda_, _Počet průchodů nulou_, _Mediánová frekvence_, _První spektrální moment_ a _Druhý spektrální moment_. Jelikož síla stisku postupně klesala, rozhodl jsem se _P-P amplitudu_ váhovat průměrnou silou stisku. Výsledky jsou ukázány v #ref(<res>, supplement: "Obrázku"). Následně byla provedena korelace parametrů s časem. Jako velmi silná korelace se ukazuje napříč měřeními korelace času a P-P amplitudy, dále pak záporný vztah mezi časem a Mediánovou frekvencí.

= Závěr

Potvrdili jsme napříč třemi měřeními, že se zvyšující se únavou klesá mediánová frekvence vzruchů, naopak však stoupá jejich amplituda.

#bibliography("ref.bib", style: "iso-690-numeric")

#subpar.grid(
  figure(
    image("assets/res1.png"),
    caption: [Subjekt 1, levá ruka],
  ),
  <sub1left>,
  figure(
    image("assets/res2.png"),
    caption: [Subjekt 1, pravá ruka],
  ),
  <sub1right>,
  figure(
    image("assets/res3.png"),
    caption: [Subjekt 2, levá ruka],
  ),
  <sub2left>,
  caption: [Výsledky výpočtu parametrů],
  label: <res>,
)

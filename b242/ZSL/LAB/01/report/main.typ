
#import "@local/ctu-report:0.1.0": *
#import "@preview/subpar:0.2.1"

#show: it => ctu-report(
  doc-category: "BAM33ZSL Laboratorní protokol",
  doc-title: "Lab 01: Úvod do Matlabu, testování hypotéz",
  author: "Tomáš Kysela",
  language: "cs",
  show-outline: false,
  it
)

#set par(justify: true)


= Filtrace, binární masky

Pomocí prahování byla nalezena maska kosti a mozku. Dále byl gaussovským filtrem upraven původní obrázek a byla nalezena lepší maska mozku bez okolní tkáně.

#subpar.grid(
  figure(
    image("/assets/ct_brain.jpg", width: 5cm),
    caption: [
      Původní obrázek
    ]
  ), <original>,
  figure(
    image("/assets/skull.png", width: 5cm),
    caption: [
      Binární maska lebky
    ]
  ), <skull>,
  figure(
    image("/assets/brain.png", width: 5cm),
    caption: [
      Binární maska mozku
    ]
  ), <brain>,
  figure(
    image("/assets/brain-filt.png", width: 5cm),
    caption: [
      Binární maska mozku po filtraci
    ]
  ), <brain-filt>,
  columns: (6cm, 6cm),
  caption: [Výsledné obrázky úlohy 1],
  label: <full>,
)

= Dvouvzorkový Studentův t-test

Implementace dodána v přiloženém souboru ``` my_ttest2.m ```

= Korekce testování hypotéz

#subpar.grid(
  figure(
    table(
      columns: 6,
      [cond], [1], [2], [3], [4], [5],
      [1], [], [*0.1415*], [2.7576e-06], [*0.8845*], [2.1331e-06],
      [2], [], [], [7.3856e-08], [*0.1294*], [8.3879e-08],
      [3], [], [], [], [2.9599e-07], [*0.4399*],
      [4], [], [], [], [], [3.3915e-07],
      [5], [], [], [], [], [],
    ),
    caption: [Proměnná 1]
  ),
  figure(
    table(
      columns: 6,
      [cond], [1], [2], [3], [4], [5],
      [1], [], [0.0042], [*0.8433*], [3.0689e-05], [*0.6049*],
      [2], [], [], [*0.0275*], [1.3483e-10], [0.0033],
      [3], [], [], [], [2.1954e-04], [*0.8350*],
      [4], [], [], [], [], [3.7318e-07],
      [5], [], [], [], [], [],
    ),
    caption: [Proměnná 2]
  ),
  caption: [Tabulka p-hodnot (tučně zvýrazněny významné hodnoty)]
)

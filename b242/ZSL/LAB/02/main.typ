#import "@local/ctu-report:0.1.0": *
#import "@preview/subpar:0.2.1"

#show: it => ctu-report(
  doc-category: "BAM33ZSL Laboratorní protokol",
  doc-title: "Lab 02: CT images",
  author: "Tomáš Kysela",
  language: "cs",
  show-outline: false,
  it,
)

#set par(justify: true)

= CT Data processing

== Zobrazení dané tkáně

Rozsah úrovní jasu byl nastaven na 0 až 1000.

#figure(
  image(
    "assets/bones.png",
    width: 10cm,
  ),
  caption: [Screenshot CT s nastavením úrovní jasu 0 až 1000],
)

== Segmentace pomocí UL prahování

Dolní prah byl nastaven na 404, horní na 1373.

#figure(
  image(
    "assets/seg.png",
    width: 10cm,
  ),
  caption: [Screenshot segmentace pomocí UL prahování],
)

== Manuální segmentace

#figure(
  image(
    "assets/man_seg.png",
    width: 10cm,
  ),
  caption: [Screenshot manuální segmentace],
)

== Objemová vizualizace

#figure(
  image(
    "assets/volume.png",
    width: 10cm,
  ),
  caption: [Screenshot objemové vizualizace],
)

= Segmentace CT obrazu

#subpar.grid(
  figure(
    image(
      "assets/boneA.png",
      width: 5cm,
    ),
  ),
  figure(
    image(
      "assets/boneB.png",
      width: 5cm,
    ),
  ),
  figure(
    image(
      "assets/boneD.png",
      width: 5cm,
    ),
  ),
  figure(
    image(
      "assets/boneE.png",
      width: 5cm,
    ),
  ),
  figure(
    image(
      "assets/boneF.png",
      width: 5cm,
    ),
  ),
  figure(
    image(
      "assets/bone_sagA.png",
      width: 5cm,
    ),
  ),
  figure(
    image(
      "assets/bone_sagD.png",
      width: 5cm,
    ),
  ),
  columns: (6cm, 6cm),
  caption: [Výsledek segmentace obrazu CT],
)

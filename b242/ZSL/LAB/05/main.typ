#import "@local/ctu-report:0.2.0": *
#import "@preview/subpar:0.2.1"
#import "@preview/unify:0.7.1": num, qty, add-unit

#show: it => ctu-report(
  doc-category: "BAM33ZSL Laboratorní protokol",
  doc-title: "Lab 05: Ultrasound theory",
  author: "Tomáš Kysela",
  language: "en",
  show-outline: false,
  it,
)

#set par(justify: true)

= US field simulation

== Time dependent changes in pressure field

#subpar.grid(
  figure(image("assets/time-7.5-25.png", width: 7cm), caption: [ depth 25mm ]),
  figure(image("assets/time-7.5-30.png", width: 7cm), caption: [ depth 30mm ]),
  figure(image("assets/time-7.5-35.png", width: 7cm), caption: [ depth 35mm ]),
  caption: [ Time dependent changes for central frequency #qty("7.5", "Mega Hertz")],
  label: <fig:time75>,
)

#subpar.grid(
  figure(image("assets/time-5-25.png", width: 7cm), caption: [ depth 25mm ]),
  figure(image("assets/time-5-30.png", width: 7cm), caption: [ depth 30mm ]),
  figure(image("assets/time-5-35.png", width: 7cm), caption: [ depth 35mm ]),
  caption: [ Time dependent changes for central frequency #qty("5", "Mega Hertz")],
  label: <fig:time5>,
)

#subpar.grid(
  figure(image("assets/time-10-25.png", width: 7cm), caption: [ depth 25mm ]),
  figure(image("assets/time-10-30.png", width: 7cm), caption: [ depth 30mm ]),
  figure(image("assets/time-10-35.png", width: 7cm), caption: [ depth 35mm ]),
  caption: [ Time dependent changes for central frequency #qty("10", "Mega Hertz")],
  label: <fig:time10>,
)

== Normalised pressure maxima

#subpar.grid(
  figure(image("assets/norm-7.5-25.png", width: 7cm), caption: [ depth 25mm ]),
  figure(image("assets/norm-7.5-30.png", width: 7cm), caption: [ depth 30mm ]),
  figure(image("assets/norm-7.5-35.png", width: 7cm), caption: [ depth 35mm ]),
  caption: [ Normalised pressure maxima for central frequency #qty("7.5", "Mega Hertz")],
  label: <fig:norm75>,
)

#subpar.grid(
  figure(image("assets/norm-5-25.png", width: 7cm), caption: [ depth 25mm ]),
  figure(image("assets/norm-5-30.png", width: 7cm), caption: [ depth 30mm ]),
  figure(image("assets/norm-5-35.png", width: 7cm), caption: [ depth 35mm ]),
  caption: [ Normalised pressure maxima for central frequency #qty("5", "Mega Hertz")],
  label: <fig:norm5>,
)

#subpar.grid(
  figure(image("assets/norm-10-25.png", width: 7cm), caption: [ depth 25mm ]),
  figure(image("assets/norm-10-30.png", width: 7cm), caption: [ depth 30mm ]),
  figure(image("assets/norm-10-35.png", width: 7cm), caption: [ depth 35mm ]),
  caption: [ Normalised pressure maxima for central frequency #qty("10", "Mega Hertz")],
  label: <fig:norm10>,
)

== Discussion

We can see, that with higher central frequency the central lobe gets narrower as well as side lobes in focal point. Before and after the focal point there is much higher number of side lobes with higher frequency.

= B-mode of water-filled cyst phantom

#figure(image("assets/cyst.png"), caption: [ Simulated image of cysts, 60 lines, depth 50mm ])

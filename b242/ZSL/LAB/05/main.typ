#import "@local/ctu-report:0.2.0": *
#import "@preview/subpar:0.2.1"
#import "@preview/unify:0.7.1": num, qty, add-unit

#show: it => ctu-report(
  doc-category: "BAM33ZSL Laboratorní protokol",
  doc-title: "Lab 04: Ultrasound theory",
  author: "Tomáš Kysela",
  language: "en",
  show-outline: false,
  it,
)

#set par(justify: true)

#add-unit("rayl", "rayl", "upright(\"rayl\")")

= US exercises

== Ultrasound resolution

$
  lambda = c / f arrow.double f = c / lambda = c / qty("0.5", "milli meter")
$

assuming tissue is fat, $c = qty("1450", "meter per second")$

$
  f = qty("1450", "meter per second") / qty("0.5", "milli meter") = qty("2.9", "mega hertz")
$

$
  "depth" = 500 lambda = qty("250", "milli meter")
$

== Reflectivity

$
  Z_"adi" = rho_"adi" dot c_"tissue" = qty("911", "kilo gram per meter cubed") dot qty("1540", "meter per second") &= qty("1.403e6", "rayl") \
  Z_"car" = rho_"car" dot c_"tissue" = qty("1100", "kilo gram per meter cubed") dot qty("1540", "meter per second") &= qty("1.694e6", "rayl")
$

$
  R_"adi-bone" = (Z_"adi" - Z_"bone")^2 / (Z_"adi" + Z_"bone")^2 = (qty("1.403e6", "rayl") - qty("6.75e6", "rayl"))^2 / (qty("1.403e6", "rayl") + qty("6.75e6", "rayl"))^2 &= 0.43 \
  R_"car-bone" = (Z_"car" - Z_"bone")^2 / (Z_"car" + Z_"bone")^2 = (qty("1.694e6", "rayl") - qty("6.75e6", "rayl"))^2 / (qty("1.694e6", "rayl") + qty("6.75e6", "rayl"))^2 &= 0.36
$

== Sampling frequency

$
  lambda = "depth" / 500 = qty("10", "centi meter") / 500 = qty("0.2", "milli meter") \
  f = c / lambda = qty("1540", "meter per second") / qty("0.2", "milli meter") = qty("7.7", "mega hertz") \
  f_s = f / 200 = qty("38.5", "kilo hertz")
$

= US excitation pulse

#figure(image("assets/bw05.png", width: 10cm))

== Bandwidth influence

As seen in @img:bwcomp higher bandwidth makes higher jitter and lower peaks in frequency domain. In time domain these signals are mostly the same. Higher bandwidth can improve axial resolution, but leads to lower penetration.

#figure(
  image("assets/bwcomp.png", width: 10cm),
  caption: [Comparison of 2 different bandwidths],
) <img:bwcomp>

== Central frequency influence

As seen in @img:fccomp lower central frequency makes much "wider" impulse in time domain and much more consentrated response in frequency domain. This can help with penetration, but can lead to lower image resolution.

#figure(
  image("assets/fccomp.png", width: 10cm),
  caption: [Comparison of 2 different central frequencies],
) <img:fccomp>

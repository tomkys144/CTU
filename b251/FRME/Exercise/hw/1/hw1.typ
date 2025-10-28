#import "@preview/ieee-monolith:0.1.0": ieee
#import "@preview/zap:0.4.0"
#import "@preview/circuiteria:0.2.0"
#import "@preview/unify:0.7.1": add-unit, num, qty, unit
#import "@preview/subpar:0.2.2"
#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/neoplot:0.0.3" as gp


#show: ieee.with(
  title: [Fundamentals of RF and Microwave Engineering \ Homework assignment 1],
  authors: (
    (
      name: "Tomáš Kysela",
    ),
  ),
)

#let nonumber = math.equation.with(
  block: true,
  numbering: none,
)


#add-unit("mil", "mil", "\"mil\"")

= Exercise 1

$u( z , t ) = U_0 cos(omega t - beta z)$

== $u( z , t ) = U_0 cos(10 pi dot 10^5 t - 2.2 dot 10^(-2) z)$
=== Calculate the phase velocity and wavelength
$
  v_(p h) = omega / beta
  = (10 pi dot 10^5 unit("per second")) / (2.2 dot 10^(-2) unit("per meter"))
  = (10 pi)/(2.2) dot 10^7 unit("meter per second")
  = (50 pi)/(11) dot 10^7 unit("meter per second")
  approx qty("1.428e8", "meter per second")
$

$
  lambda = (2 pi) / beta
  = (2 pi) / (2.2 dot 10^(-2) unit("per meter"))
  = 10/11 pi dot 10^2 unit("meter")
  approx qty("285.6", "meter")
$

=== Calculate for each distance $d$ the time delay $Delta t$ and the phase shift $Delta phi$

$d = qty("6", "kilo meter")$

$
  Delta t = d / v_(p h)
  = qty("6e3", "meter")/qty("1.428e8", "meter per second")
  = 6 / 1.428 dot 10^(-5) unit("second")
  = 500/119 dot 10^(-5) unit("second")
  = qty("42.02", "micro second")
$

$
  Delta phi = beta d
  = 2.2 dot 10^(-2) unit("per meter") dot qty("6", "kilo meter")
  = qty("5.311e-2", "radian") = qty("3.043", "degree")
$

$d = qty("250", "mil") = qty("6.35", "milli meter")$

$
  Delta t = d / v_(p h)
  = qty("6.35e-3", "meter")/qty("1.428e8", "meter per second")
  = 6.35 / 1.428 dot 10^(-11) unit("second")
  = 3175/714 dot 10^(-11) unit("second")
  = qty("44.47", "pico second")
$

$
  Delta phi = beta d
  = 2.2 dot 10^(-2) unit("per meter") dot qty("6.35", "milli meter")
  = qty("1.397e-4", "radian")
  = qty("8e-3", "degree")
$

=== Calculate the frequency $f_d$ at which $d$ corresponds exactly to one wavelength

$
  f_(d=qty("6", "kilo meter")) = v_(p h) / (d)
  = ((50 pi)/(11) dot 10^7 unit("meter per second")) / qty("6", "kilo meter")
  = (250 pi)/33 unit("kilo hertz")
  approx qty("23.8", "kilo hertz")
$

$
  f_(d=qty("6.35", "milli meter")) = v_(p h) / (d)
  = ((50 pi)/(11) dot 10^7 unit("meter per second")) / qty("6.35", "milli meter")
  approx qty("22.49", "giga hertz")
$

== $i( z , t ) = I_0 cos(11 pi dot 10^9 t - 130 z)$
=== Calculate the phase velocity and wavelength
$
  v_(p h) = omega / beta
  = (11 pi dot 10^9 unit("per second")) / (130 unit("per meter"))
  = (11 pi)/(130) dot 10^9 unit("meter per second")
  approx qty("2.658e8", "meter per second")
$

$
  lambda = (2 pi) / beta
  = (2 pi) / qty("130", "per meter")
  = pi/65 unit("meter")
  approx qty("4.833", "centi meter")
$

=== Calculate for each distance $d$ the time delay $Delta t$ and the phase shift $Delta phi$

$d = qty("6", "kilo meter")$

$
  Delta t = d / v_(p h)
  = qty("6e3", "meter")/qty("2.658e8", "meter per second")
  = 6 / 2.658 dot 10^(-5) unit("second")
  = 1000/443 dot 10^(-5) unit("second")
  = qty("22.57", "micro second")
$

$
  Delta phi = beta d
  = 130 unit("per meter") dot qty("6", "kilo meter")
  = qty("5.376", "radian") = qty("308.02", "degree")
$

$d = qty("250", "mil") = qty("6.35", "milli meter")$

$
  Delta t = d / v_(p h)
  = qty("6.35e-3", "meter")/qty("2.658e8", "meter per second")
  = 6.35 / 2.658 dot 10^(-11) unit("second")
  = 3175/1329 dot 10^(-11) unit("second")
  = qty("23.89", "pico second")
$

$
  Delta phi = beta d
  = 130 unit("per meter") dot qty("6.35", "milli meter")
  = qty("8.255e-1", "radian")
  = qty("47.3", "degree")
$

=== Calculate the frequency $f_d$ at which $d$ corresponds exactly to one wavelength

$
  f_(d=qty("6", "kilo meter")) = v_(p h) / (d)
  = ((11 pi)/(130) dot 10^9 unit("meter per second")) / qty("6", "kilo meter")
  approx qty("44.3", "kilo hertz")
$

$
  f_(d=qty("6.35", "milli meter")) = v_(p h) / (d)
  = ((11 pi)/(130) dot 10^9 unit("meter per second")) / qty("6.35", "milli meter")
  approx qty("41.86", "giga hertz")
$


= Exercise 2
#figure(
  caption: [Circuit with marked impedances],
  zap.circuit({
    import zap: *

    node("In1", (-3, 8), fill: false)
    node("In2", (-3, 0), fill: false)

    node("nR1", (-1, 8))
    node("nR12", (-1, 4))
    node("nR2", (-1, 0))

    node("nL12", (1, 4))
    node("nL2", (1, 0))

    node("Out1", (3, 4), fill: false)
    node("Out2", (3, 0), fill: false)

    resistor("R1", "nR1", "nR12", label: $R_1$)
    resistor("R2", "nR12", "nR2", label: $R_2$)

    inductor("L1", (1, 8), "nL12", label: $L_1$, variant: "ieee")
    inductor("L2", "nL12", "nL2", label: $L_2$, variant: "ieee")

    wire("In1", "nR1")
    wire("In2", "nR2")

    wire("nR1", (1, 8))
    wire("nR12", "nL12")
    wire("nR2", "nL2")

    wire("nL12", "Out1")
    wire("nL2", "Out2")

    draw.line((-3, 7.8), (-3, 0.2), mark: (end: ">"), name: "uin")
    draw.content("uin", text[$U_(i n)$], anchor: "east")

    draw.line((3, 3.8), (3, 0.2), mark: (end: ">"), name: "uout")
    draw.content("uout", text[$U_(o u t)$], anchor: "west")

    draw.rect((-1.5, 7), (2, 5), stroke: (dash: "dashed", paint: red), name: "z1")
    draw.content("z1.east", text(fill: red)[$Z_1$], anchor: "west")

    draw.rect((-1.5, 3), (2, 1), stroke: (dash: "dashed", paint: green), name: "z2")
    draw.content("z2.east", text(fill: green)[$Z_2$], anchor: "west")
  }),
)
== Calculate inductance $L_2$ in such a way that the ratio $U_(o u t) / U_(i n)$ is valid for ideal components and is frequency independent
#nonumber(
  $
    Z_1 = (L_1 R_1 s) / (R_1 + L_1 s) \
    Z_2 = (L_2 R_2 s) / (R_2 + L_2 s)
  $,
)

#nonumber(
  $
    Z_(1+2) & = Z_1 + Z_2
              = (L_1 R_1 s) / (R_1 + L_1 s) + (L_2 R_2 s) / (R_2 + L_2 s) \
            & = (L_1 R_1 s (R_2 + L_2 s) + L_2 R_2 s(R_1 + L_1 s))
              / ((R_1 + L_1 s) (R_2 + L_2 s)) \
            & = (L_1 R_1 R_2 s + L_2 R_1 R_2 s + L_1 L_2 R_1 s^2 + L_1 L_2 R_2 s^2)
              / ((R_1 + L_1 s) (R_2 + L_2 s))
  $,
)
#nonumber(
  $
    H(s) & = U_(o u t)/U_(i n) = Z_2 / (Z_1 + Z_2)
           = (L_2 R_2 s) / (R_2 + L_2 s) dot
           ((R_1 + L_1 s) (R_2 + L_2 s)) / (L_1 R_1 R_2 s + L_2 R_1 R_2 s+ L_1 L_2 R_1 s^2 + L_1 L_2 R_2 s^2) \
         & = (L_2 R_2 (R_1 + L_1 s)) / (L_1 R_1 R_2 + L_2 R_1 R_2 + L_1 L_2 R_1 s + L_1 L_2 R_2 s)
           = (L_2 R_1 R_2 + L_1 L_2 R_2 s) / (L_1 R_1 R_2 + L_2 R_1 R_2 + L_1 L_2 R_1 s + L_1 L_2 R_2 s)
  $,
)
To get $L_2$ independent of $s$, we must find balance of coefficients with $s$ and without $s$:
#nonumber(
  $
    (L_1 L_2 R_2) / (L_1 L_2 R_1 + L_1 L_2 R_2) & = (L_2 R_1 R_2) / (L_1 R_1 R_2 + L_2 R_1 R_2) \
                              R_2 / (R_1 + R_2) & = L_2 / (L_1 + L_2) \
                                      bold(L_2) & = bold((L_1 R_2) / R_1)
  $,
)

== How large is $L_2$ and the ratio $U_(o u t) / U_(i n)$ for the case of $L_1 = qty("10", "nano henry")$, $R_1 = qty("150", "ohm")$, $R_2 = qty("30", "ohm")$?

#nonumber(
  $
    L_2 = (L_1 R_2) / R_1 = qty("10", "nano henry") dot qty("30", "ohm")/qty("150", "ohm") = qty("2", "nano henry")
  $,
)

#nonumber(
  $
    H(s) &= (L_2 R_1 R_2 + L_1 L_2 R_2 s) / (L_1 R_1 R_2 + L_2 R_1 R_2 + L_1 L_2 R_1 s + L_1 L_2 R_2 s) \
    &= (qty("2", "nano henry") dot qty("150", "ohm") dot qty("30", "ohm") + qty("10", "nano henry") dot qty("2", "nano henry") dot qty("30", "ohm") dot s) / (qty("10", "nano henry") dot qty("150", "ohm") dot qty("30", "ohm") + qty("2", "nano henry") dot qty("150", "ohm") dot qty("30", "ohm") + qty("10", "nano henry") dot qty("2", "nano henry") dot qty("150", "ohm") dot s + qty("10", "nano henry") dot qty("2", "nano henry") dot qty("30", "ohm") dot s) \
    &= (qty("9000", "nano henry ohm squared") + qty("600", "nano henry squared ohm") dot s) / (qty("54000", "nano henry ohm squared") + qty("3600", "nano henry squared ohm") dot s) = 1/6
  $,
)

= Exercise 3

#figure(
  zap.circuit({
    import zap: *

    node("in", (0, 0), fill: false)
    node("split", (2, 0))
    node("merge", (10, 0))
    node("out", (12, 0), fill: false)

    capacitor("C1", "split", (6, 0), label: $C_1$, i: $i_(C_1)$)
    capacitor("C1", (2, 2), (6, 2), label: $C_2$, i: $i_(C_2)$)

    resistor("R1", (6, 0), "merge", label: $R_1$)
    resistor("R2", (6, 2), (10, 2), label: $R_2$)

    wire("in", "split", i: $i$)
    wire("split", (2, 2))
    wire((10, 2), "merge")
    wire("merge", "out")

    draw.line((3, 3.6), (9, 3.6), mark: (end: ">"), name: "u")
    draw.content("u", text[$u\ \ $], anchor: "west")

    draw.rect((3, 1.2), (5, -0.5), stroke: (dash: "dashed", paint: green), name: "z1")
    draw.content("z1.east", text(fill: green)[$Z_1$], anchor: "west")

    draw.rect((3, 3.2), (5, 1.5), stroke: (dash: "dashed", paint: green), name: "z2")
    draw.content("z2.east", text(fill: green)[$Z_2$], anchor: "west")

    draw.rect((7, 1.2), (9, -0.5), stroke: (dash: "dashed", paint: red), name: "z3")
    draw.content("z3.east", text(fill: red)[$Z_3$], anchor: "west")

    draw.rect((7, 3.2), (9, 1.5), stroke: (dash: "dashed", paint: red), name: "z4")
    draw.content("z4.east", text(fill: red)[$Z_4$], anchor: "west")

    draw.rect((2.9, 1.3), (9.6, -0.6), stroke: (dash: "dashed", paint: blue), name: "z5")
    draw.content("z5.south", text(fill: blue)[$\ Z_5$], anchor: "north")

    draw.rect((2.9, 3.3), (9.6, 1.4), stroke: (dash: "dashed", paint: blue), name: "z6")
    draw.content("z6.south", text(fill: blue)[$\ Z_6$], anchor: "south")

    draw.rect((2.8, 3.4), (9.7, -1.2), stroke: (dash: "dashed", paint: orange), name: "z")
    draw.content("z.south", text(fill: orange)[$\ Z$], anchor: "north")
  }),
  caption: [Circuit with marked impedances],
)

#pagebreak()
== Determine the locus curve in the Z-plane of this parallel circuit.
#nonumber(
  $
    Z_1 & = 1 / (j omega C_1) \
    Y_1 & = j omega C_1
  $,
)
#let csvdata = ```
0   0   .5  .5
0   1   -.5 .5
1   1   1    0
```.text

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    gp.exec(
      ```gnuplot
      reset
      set term svg size 500,400
      set termoption enhanced
      set xrange[-1:3]
      set yrange[-2:2]
      set grid
      set xlabel "Re(Z/Z_0)"
      set ylabel "Im(Z/Z_0)"
      set arrow from 0,-2 to 0,0 lt  rgbcolor "forest-green" lw 2
      set label "ω = 0" at 0.05,-1.8 textcolor "forest-green"
      set label "ω = ∞" at 0.05,0 textcolor "forest-green"
      plot NaN t ''
      ```,
    ),
    caption: [Impedance],
  ),
  figure(
    gp.exec(
      ```gnuplot
      reset
      set term svg size 500,400
      set xrange[-1:3]
      set yrange[-2:2]
      set grid
      set xlabel "Re(Y/Y_0)"
      set ylabel "Im(Y/Y_0)"
      set arrow to 0,2 lt  rgbcolor "forest-green" lw 2
      set label "ω = 0" at 0.05,0.1 textcolor "forest-green"
      set label "ω = ∞" at 0.05,1.9 textcolor "forest-green"
      plot NaN t ''
      ```,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z_1$],
)

#nonumber(
  $
    Z_2 & = 1 / (j omega C_2) \
    Y_2 & = j omega C_2
  $,
)

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    gp.exec(
      ```gnuplot
      reset
      set term svg size 500,400
      set termoption enhanced
      set xrange[-1:3]
      set yrange[-2:2]
      set grid
      set xlabel "Re(Z/Z_0)"
      set ylabel "Im(Z/Z_0)"
      set arrow from 0,-2 to 0,0 lt  rgbcolor "forest-green" lw 2
      set label "ω = 0" at 0.05,-1.8 textcolor "forest-green"
      set label "ω = ∞" at 0.05,0 textcolor "forest-green"
      plot NaN t ''
      ```,
    ),
    caption: [Impedance],
  ),
  figure(
    gp.exec(
      ```gnuplot
      reset
      set term svg size 500,400
      set xrange[-1:3]
      set yrange[-2:2]
      set grid
      set xlabel "Re(Y/Y_0)"
      set ylabel "Im(Y/Y_0)"
      set arrow to 0,2 lt  rgbcolor "forest-green" lw 2
      set label "ω = 0" at 0.05,0.1 textcolor "forest-green"
      set label "ω = ∞" at 0.05,1.9 textcolor "forest-green"
      plot NaN t ''
      ```,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z_2$],
)

#nonumber(
  $
    Z_3 & = R_1 \
    Y_3 & = 1 / R_1
  $,
)

#let zdata = ```
x,y
0,0
3,0
```.text

#let ydata = ```
x,y
0,0
3,0
```.text

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    gp.exec(
      ```gnuplot
        reset
        $data <<EOD

      ```.text
        + zdata
        + ```gnuplot

        EOD
        set datafile sep ',' columnheaders
        set term svg size 500,400
        set xrange[-1:3]
        set yrange[-2:2]
        set grid
        set xlabel "Re(Z/Z_0)"
        set ylabel "Im(Z/Z_0)"
        set key off

        set label "ω = 0, R_1 = 0" at 0,0.15 textcolor "red"
        set label "ω = ∞, R_1 = 0" at 0,-0.15 textcolor "red"
        set label "ω = 0, R_1 = ∞" at 2.2,0.15 textcolor "red"
        set label "ω = ∞, R_1 = ∞" at 2.2,-0.15 textcolor "red"

        plot $data with linespoints lt rgbcolor "red" lw 2 dt 2
        ```.text,
    ),
    caption: [Impedance],
  ),
  figure(
    gp.exec(
      ```gnuplot
        reset
        $data <<EOD

      ```.text
        + ydata
        + ```gnuplot

        EOD
        set datafile sep ',' columnheaders
        set term svg size 500,400
        set xrange[-1:3]
        set yrange[-2:2]
        set grid
        set xlabel "Re(Y/Y_0)"
        set ylabel "Im(Y/Y_0)"
        set key off

        set label "ω = 0, R_1 = ∞" at 0,0.15 textcolor "red"
        set label "ω = ∞, R_1 = ∞" at 0,-0.15 textcolor "red"
        set label "ω = 0, R_1 = 0" at 2.2,0.15 textcolor "red"
        set label "ω = ∞, R_1 = 0" at 2.2,-0.15 textcolor "red"

        plot $data with linespoints lt rgbcolor "red" lw 2 dt 2
        ```.text,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z_3$],
)

#nonumber(
  $
    Z_4 & = R_2 \
    Y_4 & = 1 / R_2
  $,
)

#let zdata = ```
x,y
0.32,0
```.text

#let ydata = ```
x,y
3.125,0
```.text

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    gp.exec(
      ```gnuplot
        reset
        $data <<EOD

      ```.text
        + zdata
        + ```gnuplot

        EOD
        set datafile sep ',' columnheaders
        set term svg size 500,400
        set xrange[-1:3]
        set yrange[-2:2]
        set grid
        set xlabel "Re(Z)"
        set ylabel "Im(Z)"
        set key off

        set label "ω = 0" at 0.32,0.15 textcolor "red"
        set label "ω = ∞" at 0.32,-0.15 textcolor "red"

        plot $data with linespoints lt rgbcolor "red" lw 2 dt 2
        ```.text,
    ),
    caption: [Impedance],
  ),
  figure(
    gp.exec(
      ```gnuplot
        reset
        $data <<EOD

      ```.text
        + ydata
        + ```gnuplot

        EOD
        set datafile sep ',' columnheaders
        set term svg size 500,400
        set xrange[-1:4]
        set yrange[-2:2]
        set grid
        set xlabel "Re(Y/Y_0)"
        set ylabel "Im(Y/Y_0)"
        set key off

        set label "ω = 0" at 3.125,0.15 textcolor "red"
        set label "ω = ∞" at 3.125,-0.15 textcolor "red"

        plot $data with linespoints lt rgbcolor "red" lw 2 dt 2
        ```.text,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z_4$],
)

#nonumber(
  $
    Z_5 & = R_1 + 1 / (j omega C_1) = R_1 - j 1/(omega C_1) \
    Y_5 & = 1 / Z_5 = (C_1^2 R_1 omega^2)/(C_1^2 R_1^2 omega^2 + 1) + j (C omega) / (C_1^2 R_1^2 omega^2 + 1)
  $,
)

#let zdata = ```
x,y
0,0
3,0
```.text

#let ydata = ```
x,y
0,0
3,0
```.text

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    gp.exec(
      ```gnuplot
        reset
        $data <<EOD

      ```.text
        + zdata
        + ```gnuplot

        EOD
        set datafile sep ',' columnheaders
        set term svg size 500,400
        set xrange[-1:3]
        set yrange[-2:2]
        set grid
        set xlabel "Re(Z)"
        set ylabel "Im(Z)"
        set key off

        set arrow from 0,-2 to 0,0 lt rgbcolor "blue"

        set label "ω = ∞, R_1 = 0" at 0.1,0.15 textcolor "blue"
        set label "ω = 0, R_1 = 0" at 0.1,-1.8 textcolor "blue"
        set label "ω = ∞, R_1 = ∞" at 2.2,0.15 textcolor "blue"
        set label "ω = -, R_1 = ∞" at 2.2,-1.8 textcolor "blue"

        plot $data with linespoints lt rgbcolor "blue" lw 2 dt 2
        ```.text,
    ),
    caption: [Impedance],
  ),
  figure(
    gp.exec(
      ```gnuplot
        reset
        $data <<EOD

      ```.text
        + ydata
        + ```gnuplot

        EOD
        set datafile sep ',' columnheaders
        set term svg size 500,400
        set xrange[-1:4]
        set yrange[-2:2]
        set grid
        set xlabel "Re(Y/Y_0)"
        set ylabel "Im(Y/Y_0)"
        set key off

        set label "ω = 0" at 3.125,0.15 textcolor "red"
        set label "ω = ∞" at 3.125,-0.15 textcolor "red"

        plot $data with linespoints lt rgbcolor "red" lw 2 dt 2
        ```.text,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z_5$],
)

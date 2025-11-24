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
      name: "Tomáš Kysela (12513690)",
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

#let zdata = ```
x,y
0,-0.360896
```.text

#let ydata = ```
x,y
0,2.77088
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
        set xlabel "Re(Z_1/Z_0)"
        set ylabel "Im(Z_1/Z_0)"
        set key off

        plot $data with linespoints lt rgbcolor "forest-green" lw 2 dt 2 ps 2
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
        set yrange[-2:4]
        set grid
        set xlabel "Re(Y_1/Y_0)"
        set ylabel "Im(Y_1/Y_0)"
        set key off

        plot $data with linespoints lt rgbcolor "forest-green" lw 2 dt 2 ps 2
        ```.text,
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

#let zdata = ```
x,y
0,-0.179836
```.text

#let ydata = ```
x,y
0,+5.56062
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
        set xlabel "Re(Z_2/Z_0)"
        set ylabel "Im(Z_2/Z_0)"
        set key off

        plot $data with linespoints lt rgbcolor "forest-green" lw 2 dt 2 ps 2
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
        set yrange[-2:7]
        set grid
        set xlabel "Re(Y_2/Y_0)"
        set ylabel "Im(Y_2/Y_0)"
        set key off

        plot $data with linespoints lt rgbcolor "forest-green" lw 2 dt 2 ps 2
        ```.text,
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

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    gp.exec(
      ```gnuplot
      reset
      set datafile sep ',' columnheaders
      set term svg size 500,400
      set xrange[-1:3]
      set yrange[-2:2]
      set grid
      set xlabel "Re(Z_3/Z_0)"
      set ylabel "Im(Z_3/Z_0)"
      set key off

      set arrow to 3,0 lt  rgbcolor "red" lw 2

      set label "R_1 = 0" at 0,0.15 textcolor "red"
      set label "R_1 = ∞" at 2.5,0.15 textcolor "red"

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
      set xlabel "Re(Y_3/Y_0)"
      set ylabel "Im(Y_3/Y_0)"
      set key off

      set arrow from 3,0 to 0,0 lt  rgbcolor "red" lw 2

      set label "R_1 = ∞" at 0.2,0.15 textcolor "red"
      set label "R_1 = 0" at 2.5,0.15 textcolor "red"

      plot NaN t ''
      ```,
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
        set xlabel "Re(Z_4/Z_0)"
        set ylabel "Im(Z_4/Z_0)"
        set key off

        plot $data with linespoints lt rgbcolor "red" lw 2 dt 2 ps 2
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
        set xlabel "Re(Y_4/Y_0)"
        set ylabel "Im(Y_4/Y_0)"
        set key off

        plot $data with linespoints lt rgbcolor "red" lw 2 dt 2 ps 2
        ```.text,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z_4$],
)

#nonumber(
  $
    Z_5 & = R_1 + 1 / (j omega C_1) = R_1 - j 1/(omega C_1) \
    Y_5 & = 1 / Z_5 = (C_1^2 R_1 omega^2)/(C_1^2 R_1^2 omega^2 + 1) + j (C_1 omega) / (C_1^2 R_1^2 omega^2 + 1)
  $,
)

#let ydata = ```
x,y
0.,2.7708847204661975
0.1530858973903861,2.7624010529862404
0.3033851554541153,2.737258908799635
0.4482776932977851,2.6963571718131174
0.585456069238918,2.6411062183255316
0.7130348114414807,2.573310994047828
0.8296138570829833,2.4950329972088054
0.9342949902093102,2.408449400677125
1.0266571063344514,2.3157249622101705
1.1067006556846528,2.2189075318122224
1.1747733373564342,2.119852422367792
1.2314884401333615,2.0201759699830153
1.2776449964965166,1.9212350407128491
1.3141560423652423,1.824127246960671
1.341988474706942,1.7297060197761807
1.3621157033593763,1.6386050434825286
1.3754826666017568,1.5512674711372667
1.3829817991783036,1.467976454217353
1.3854380839647786,1.3888846019826084
1.383601230835971,1.3140409067643835
1.3781431664849646,1.2434143834149605
1.3696592754058659,1.176914177910092
1.3586721276441287,1.1144062314767353
1.3456367157350688,1.055726781599033
1.3309464764757852,1.0006930778621608
1.3149395829690838,0.9491117210735833
1.29790515810092,0.9007850234442236
1.2800891865094253,0.8555157538903931
1.2616999944728111,0.8131105880278787
1.2429132326540688,0.7733825350348814
1.2238763414390346,0.7361525679261022
1.2047125079283105,0.7012506423868948
1.185524141728912,0.6685162532275124
1.166395906836712,0.6377986469292123
1.1473973515977824,0.6089567833711369
1.128585179821146,0.5818591191084905
1.1100052049082372,0.556383267885104
1.0916940262951846,0.53241558077089
1.073680464211428,0.5098506778268576
1.0559867851690896,0.4885909549955812
1.0386297469874366,0.46854608354686844
1.0216214886951476,0.44963251450343905
1.0049702874364659,0.4317729967228066
0.9886812015831741,0.4148961144702758
0.9727566166381488,0.3989358481841611
0.9571967082034281,0.38383116054891947
0.9419998342595876,0.3695256088291421
0.9271628672407375,0.35596698357846795
0.9126814748646935,0.34310697324526973
0.8985503573644736,0.33090085379134865
0.004901464909925901,8.670311420784395E-6
0.004805829449436947,8.335267794857508E-6
0.004712965910877539,8.016252633441523E-6
0.0046227681982501725,7.712354518873627E-6
0.0045351352434131265,7.4227219273807215E-6
0.004449970722849106,7.1465587728185195E-6
0.004367182792874574,6.883120319966328E-6
0.004286683841930269,6.631709433636916E-6
0.004208390258705195,6.391673133218783E-6
0.004132222214947904,6.162399425264701E-6
0.00405810346191141,5.943314389417308E-6
0.0039859611394624265,5.733879495356833E-6
0.003915725596962322,5.533589130598999E-6
0.0038473302250974823,5.341968320892027E-6
0.0037807112979007618,5.158570626684341E-6
0.003715807824264271,4.982976200681616E-6
0.00365256140829738,4.814789992902114E-6
0.0035909161179328536,4.653640090890011E-6
0.003530818361229009,4.499176183872686E-6
0.0034722167698569974,4.351068140662912E-6
0.0034150620893001965,4.20900469202259E-6
0.0033593070753273786,4.072692209031251E-6
0.0033049063963333267,3.941853569749673E-6
0.0032518165411699117,3.816227107144489E-6
0.003199995732117639,3.695565631851181E-6
0.003149403842672662,3.5796355239069633E-6
0.0031000023198470943,3.468215888087161E-6
0.003051754110701691,3.3610977679345462E-6
0.0030046235928494485,3.2580834139848842E-6
0.0029585765086867274,3.158985602068018E-6
0.002913579903125142,3.0636269979058655E-6
0.0028696020646128578,2.9718395645399878E-6
0.002826612469248217,2.8834640094048845E-6
0.0027845817278017563,2.7983492681216483E-6
0.0027434815354749212,2.716352022322237E-6
0.002703284624235108,2.6373362490298463E-6
0.002663964717577126,2.561172799317279E-6
0.0026254964875709738,2.4877390041448917E-6
0.00258785551406477,2.4169183054438905E-6
0.002551018245920188,2.3485999106611496E-6
0.0025149619641654584,2.28267846911935E-6
0.0024796647469582963,2.2190537686724345E-6
0.0024451054362578713,2.1576304512520757E-6
0.002411263606111199,2.098317746006957E-6
0.0023781195324651884,2.0410292188341914E-6
0.002345654164421053,1.9856825371916767E-6
0.0023138490968528497,1.9321992491625215E-6
0.002282686544316662,1.8805045758183389E-6
0.0022521493161813673,1.830527215997893E-6
0.002222220792916068,1.7821991626816997E-6
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
        set xlabel "Re(Z_5/Z_0)"
        set ylabel "Im(Z_5/Z_0)"
        set key off

        set arrow to 3,0 lt rgbcolor "blue"

        set label "R_1 = 0" at 0.1,0.15 textcolor "blue"
        set label "R_1 = ∞" at 2.5,0.15 textcolor "blue"

        plot NaN t ''
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
        set yrange[-1:3]
        set grid
        set xlabel "Re(Y_5/Y_0)"
        set ylabel "Im(Y_5/Y_0)"
        set key off
        set style arrow 11 head nofilled size .2, 20, 4 fixed lt rgbcolor "blue"

        set arrow from 0.002222220792916068,1.7821991626816997E-6 to 0,0 lt rgbcolor "blue" as 11

        set label "R_1 = 0" at 0,2.5 textcolor "blue"
        set label "R_1 = ∞" at 0,0.2 textcolor "blue"

        plot $data u 1:2 smooth path w l lc "blue" ti "smooth path",
        ```.text,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z_5$],
)

#nonumber(
  $
    Z_6 & = R_2 + 1 / (j omega C_2) = R_2 - j 1/(omega C_2) \
    Y_6 & = 1 / Z_6 = (C_2^2 R_2 omega^2)/(C_2^2 R_2^2 omega^2 + 1) + j (C_2 omega) / (C_2^2 R_2^2 omega^2 + 1)
  $,
)

#let zdata = ```
x,y
0.36,-0.179836
```.text

#let ydata = ```
x,y
2.22303,+1.1105
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
        set xlabel "Re(Z_6/Z_0)"
        set ylabel "Im(Z_6/Z_0)"
        set key off

        plot $data with linespoints lt rgbcolor "blue" lw 2 dt 2 ps 2
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
        set yrange[-2:7]
        set grid
        set xlabel "Re(Y_6/Y_0)"
        set ylabel "Im(Y_6/Y_0)"
        set key off

        plot $data with linespoints lt rgbcolor "blue" lw 2 dt 2 ps 2
        ```.text,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z_6$],
)

#nonumber(
  $
    Z_7 & = (C_1 C_2 R_1 R_2 omega^2 -1 - j (C_1 R_1 omega + C_2 R_2 omega))/(C_1 C_2 R_1 omega^2 + C_1 C_2 R_2 omega^2 - j(omega C_1 + omega C_2))\
    Y_7 &= (C_1 C_2 R_1 omega^2 + C_1 C_2 R_2 omega^2 - j(omega C_1 + omega C_2)) / (C_1 C_2 R_1 R_2 omega^2 -1 - j (C_1 R_1 omega + C_2 R_2 omega))
  $,
)

#let zdata = ```
x,y
0.11111243885139206,-0.1940010816973301
0.11509227684158184,-0.18759233394726504
0.12787836700481842,-0.17082138368124855
0.15017670421867332,-0.1501622247977894
0.1796173969794318,-0.1328604999581699
0.2111055106921834,-0.1228942057965549
0.24000012311396127,-0.1200265981510863
0.26405031994932704,-0.1219264236130418
0.2830313716688306,-0.12626132943332913
0.2976689216474258,-0.13146356845787346
0.30890026017531425,-0.1366790003974849
0.3175609208758314,-0.1415145708506885
0.3243063546094136,-0.14582951870297803
0.32962437856419163,-0.14960696888772299
0.3338708876805561,-0.1528844234653217
0.3373045391552658,-0.15571884420528206
0.34011415829522357,-0.1581702027440479
0.3424387948609222,-0.16029438573670882
0.3443819496759846,-0.1621406533368269
0.34602155884359265,-0.16375121236421167
0.347416998751952,-0.1651616967010918
0.34861402681089915,-0.16640197281536925
0.3496482950701729,-0.16749700095624498
0.3505478734810884,-0.16846763652437716
0.35133508101360117,-0.16933133028614933
0.35202782873492255,-0.17010272046562694
0.35264061538690833,-0.17079412448224132
0.35318527300664015,-0.17141594335469126
0.35367153091202624,-0.17197699264055522
0.35410744636810715,-0.1724847727416468
0.35449973643750987,-0.17294568969671278
0.3548540358956944,-0.1733652357734168
0.3551750993246043,-0.17374813750403476
0.355466960694691,-0.17409847736937098
0.35573306030354856,-0.17441979413488296
0.355976346450952,-0.17471516586213182
0.3561993574149457,-0.17498727882675863
0.35640428795825735,-0.17523848493919353
0.3565930436037922,-0.17547084975697927
0.35676728517740636,-0.17568619277286018
0.3569284655582755,-0.17588612133989964
0.35707786015382537,-0.17607205933703518
0.3572165922926978,-0.17624527147219934
0.3573456544803734,-0.17640688395474577
0.35746592626940704,-0.17655790213596756
0.3575781893461643,-0.1766992256093207
0.35768314031835147,-0.17683166117530583
0.3577814015949856,-0.17695593400567997
0.3578735306770418,-0.17707269728447933
0.3579600281185683,-0.17718254055666244
0.3580413443712838,-0.17728599697696207
0.35811788568805264,-0.1773835496201391
0.358190019230256,-0.17747563698796417
0.3582580774994253,-0.1775626578268722
0.35832236219341335,-0.1776449753525062
0.3583831475709558,-0.17772292096262762
0.3584406833949729,-0.17779679750757765
```.text

#let ydata = ```
x,y
2.223031561249912,3.881388366486966
2.3761174586402998,3.8729046990070084
2.8084876304888318,3.751609864346301
3.3297322169345653,3.329411177832991
3.59851422785167,2.6617711171580356
3.5379711442189965,2.059615367094353
3.3330367661581506,1.6668869139058728
3.1215819186143867,1.441404499812118
2.9467491872547273,1.3145555833460913
2.811128990493113,1.2415170735335648
2.7072642656129386,1.197882363147903
2.6272646090752105,1.1707870812285979
2.5648857037647703,1.1533417165341862
2.5155545961345864,1.1417374523043222
2.475989530309293,1.133792270650719
2.443833610781477,1.1282117526611166
2.417378453455742,1.124202655980868
2.3953700649484575,1.1212642344713202
2.376875357008607,1.1190717854062204
2.3611905187989732,1.11740959542635
2.347777691944862,1.1161311866476653
2.3362207366338477,1.11513510533218
2.3261939514540058,1.1143498080918877
2.317439669413467,1.113724011550688
2.309752006994163,1.1132204015809164
2.3029649310401568,1.1128114538974327
2.2969433930998915,1.1124766084568511
2.29157666927128,1.1122003281415207
2.286773304265455,1.111970745013408
2.2824572352995736,1.1117787032185726
2.278564792856506,1.1116170736242028
2.2750423596561937,1.111480257173234
2.2718445283726196,1.1113638209831862
2.2689326406347323,1.1112642289347732
2.266273619968324,1.1111786402728336
2.2638390331467044,1.1111047576749375
2.2616043303624216,1.1110407116538177
2.259548226393383,1.1109849718940352
2.257652193686731,1.110936278729208
2.2559000448468582,1.1108935898037555
2.2542775869749234,1.1108560382717692
2.2527723340850776,1.1108228998263465
2.2513732667196673,1.1107935665349304
2.2500706301223476,1.110767525955112
2.248855764065841,1.110744344373122
2.2477209587895737,1.1107236532803866
2.2466593325706024,1.1107051384078905
2.245664727295782,1.1106885307919958
2.2447316190745044,1.110673599462096
2.243855041467694,1.1106601454295115
2.2430305193393383,1.110647996725378
2.242254011684228,1.1106370042880394
2.2415218620669775,1.110627038541394
2.2408307555364004,1.110617986537595
2.240177681066487,1.1106097495625569
2.2395598987286784,1.1106022411224665
2.2389749109265873,1.110595385245112
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
        set xrange[0:0.5]
        set yrange[-0.5:0]
        set grid
        set xlabel "Re(Z/Z_0)"
        set ylabel "Im(Z/Z_0)"
        set key off
        set style arrow 11 head nofilled size .015, 20, 4 fixed lt rgbcolor "orange"

        set arrow from 0.3584406833949729,-0.17779679750757765 to 0.36,-0.179836 lt rgbcolor "orange" as 11

        set label "R_1 = 0" at 0.1,-0.21 textcolor "orange"
        set label "R_1 = ∞" at 0.35,-0.21 textcolor "orange"

        plot $data u 1:2 smooth path w l lc "orange" ti "smooth path",
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
        set xrange[2:4]
        set yrange[1:4]
        set grid
        set xlabel "Re(Y/Y_0)"
        set ylabel "Im(Y/Y_0)"
        set key off
        set style arrow 11 head nofilled size .08, 20, 4 fixed lt rgbcolor "orange"

        set arrow from 2.2389749109265873,1.110595385245112 to 2.22303,1.1105 lt rgbcolor "orange" as 11

        set label "R_1 = 0" at 2.2,3.8 textcolor "orange"
        set label "R_1 = ∞" at 2.2,1.3 textcolor "orange"

        plot $data u 1:2 smooth path w l lc "orange" ti "smooth path",
        ```.text,
    ),
    caption: [Admittance],
  ),

  caption: [Locus curves of $Z$],
)

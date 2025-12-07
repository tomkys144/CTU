#import "@preview/ieee-monolith:0.1.0": ieee
#import "@preview/unify:0.7.1": add-unit, num, qty, unit
#import "@preview/subpar:0.2.2"


#show: ieee.with(
  title: [442.120 Mixed-Signal Processing Systems Design \ Homework assignment 1],
  authors: (
    (
      name: "Tomáš Kysela",
      department: [12513690],
    ),
    (
      name: "?",
      department: [?],
    ),
  ),
)

#let nonumber = math.equation.with(
  block: true,
  numbering: none,
)

#add-unit("mil", "mil", "\"mil\"")

= Analog Filters

Consider a 10-bit analog-to-digital converter (ADC) with a rail-to-rail input range of #qty("-1", "Volt") to #qty("1", "Volt"). Assume that the ADC is preceded by an analog anti-aliasing filter.

== Calculate the least significant bit (LSB) of the ADC.


$
  "LSB" = (V_(r+) - V_(r-))/2^N = (qty("1", "Volt") - (qty("-1", "Volt")))/2^10 = qty("2", "Volt")/2^10 = qty("1.953", "Milli Volt")
$


== Determine the minimum required attenuation $A_"min"$ (in $unit("Decibel", space: "#h(0em)")$) of an anti-aliasing filter at the first aliasing frequency to ensure that out-of-band signals do not introduce distortion larger than 1 LSB.


$
  A_"min,mV" = "LSB"/(V_(r+) - V_(r-)) = qty("1.953", "Milli Volt")/(qty("1", "Volt") - (qty("-1", "Volt"))) = qty("1.953", "Milli Volt")/qty("2", "Volt") = num("9.764e-4")
$

$
  A_"min" = 20 log(A_"min,mV") = 20 log(num("9.764e-4")) = qty("-138.63", "Decibel")
$

== Design a Chebyshev 1 analog anti-aliasing filter in MATLAB.

The specifications are: $Omega_p = 2 pi dot qty("20", "kilo hertz")$, $A_"max" = qty("0.2", "decibel")$, $Omega_s = 2 pi dot qty("25", "kilo hertz")$, and the previously determined $A_"min"$.

=== Find the minimum filter order that fulfills the specifications.

Using function `cheb1ord` we calculated minimum order of the filter as 27.

=== Plot and explain the magnitude spectrum, the group delay, and the s-plane of the filter.

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    image(
      "code/filter-mag.png",
      width: auto,
    ),
    caption: [Magnitude],
  ),
  figure(
    image(
      "code/filter-mag-detail.png",
      width: auto,
    ),
    caption: [Detail of magnitude around design constraints],
  ),

  figure(
    image(
      "code/filter-gd.png",
      width: auto,
    ),
    caption: [Group delay],
  ),
  figure(
    image(
      "code/filter-splane.png",
      width: auto,
    ),
    caption: [s-plane],
  ),
)

== Exploit oversampling to relax the requirements on the analog anti-aliasing filter. Assume that the order of the Chebyshev 1 filter is fixed to 3.

=== Design the analog filter and choose the smallest possible sampling frequency so that the sampling system still has an attenuation $A_"min"$ in the stopband for out-of-band distortion.

We found smallest possible stopband frequency of $Omega_s = 2 pi dot 428.5141 unit("kilohertz")$. Using this result and formula @sample we can calculate smallest possible sampling frequency.

$
  Omega_"sample" = Omega_p + Omega_s = 2 pi dot 448.5141 unit("kilohertz")
$ <sample>

= Sampling

Consider a continuous-time signal $x(t) = cos(omega_0 t)$ sampled at times $t_n = n T + Delta_n$, where $Delta_n$ is a small, zero-mean Gaussian random variable with variance $sigma_Delta^2$.

== Assume that $Delta_n$ is small, i.e., $abs(Delta_n) << 1$. Using a first-order Taylor series expansion, approximate $x[n] = x(n T + Delta_n)$ as a sum of the ideal sample $x(n T)$ and a noise term $e[n]$ that depends on $Delta_n$.

For this problem we will use equation @taylor, which defines first-order Taylor series around center point $t_0 = a$ with shift of $h$.

$
  f(a + h) approx f(a) + f'(a) times h
$ <taylor>

Setting center of expansion $t_0$ as $n T$ and shift as $Delta_n$ we can calculate $x(t_0)$ given by equation @ideal and it's derivative given by equation @derivative.

$
  x(t_0) = x(n T) = cos(omega_0 n T)
$ <ideal>

$
  x'(t_0) = x'(n T) = -omega_0 sin(omega_0 n T)
$ <derivative>

Now if we substitute all these equation we get equation describing $x[n]$:

$
  x[n] approx x(n T) + Delta_n x'(n T) = cos(omega_0 n T) - Delta_n omega_0 sin(omega_0 n T)
$

From this we get signal component shown in equation @signal and a noise term given by equation @noise.

$
  s[n] = cos(omega_0 n T) = x(n T)
$ <signal>

$
  e[n] = - Delta_n omega_0 sin(omega_0 n T)
$ <noise>

== Compute the average power of the signal component $s[n]$.

Using results from previous section, mainly equation @signal, we can calculate average power of signal component using equation @power.

$
  P_s & = EE(abs(s[n])^2) = EE(abs(cos(omega_0 n T))^2) = EE(cos^2(omega_0 n T)) \
      & = EE(1/2 + 1/2 cos(2 omega_0 n T)) = 1/2 + EE(1/2 cos(2 omega_0 n T)) = 1/2 + 0 = 1/2
$ <power>

== Compute the average power of the noise component e[n], using the fact that $Delta_n$ is zero-mean with variance $sigma^2_Delta$, and that $E[sin^2(omega_0 n T)] = 1/2$

Combining equation @noise and general formula for average power of signal, we get equation @noisepower.

$
  P_e &= EE(abs(e[n])^2) = EE(Delta_n^2 omega_0^2 sin^2(omega_0 n T)) = omega_0^2 dot EE(Delta_n^2) dot EE(sin^2(omega_0 n T)) = 1/2 omega_0^2 sigma^2_Delta
$ <noisepower>

== Using your results from the previous steps, write an expression for the Signal-to-Noise Ratio (SNR) in decibels (#unit("decibel")), i.e., $"SNR"_unit("decibel") = 10 log_10(P_s/P_e)$, and simplify your result to express the SNR as a function of $omega_0$ and $sigma_Delta$.

Using the expression from the assignment and equations @power and @noisepower we can calculate SNR, which is done in equation @snr.

$
  "SNR"_unit("decibel") &= 10 log_10(P_s/P_e) = 10 log_10((1/2)/(1/2 omega_0^2 sigma^2_Delta)) = 10 log_10(1/(omega_0^2 sigma^2_Delta))\
  &= -20 log_10(omega_0 sigma_Delta)
$ <snr>

== Discuss the dependence of the SNR on the signal frequency $omega_0$ and the jitter variance $sigma^2_Delta$. How does the SNR change for higher frequencies or larger jitter?

From the equation @snr we can clearly see, that with higher frequencies SNR gets lower, exactly #qty("20", "decibel") per decade of frequency. Same goes with jitter variance, this time only by #qty("10", "decibel"). This means, that for higher frequencies we need ADC with much lower jitter variance, so that we do not loose information in quantization noise.

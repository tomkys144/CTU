#import "@preview/ieee-monolith:0.1.0": ieee
#import "@preview/zap:0.4.0"
#import "@preview/circuiteria:0.2.0"
#import "@preview/unify:0.7.1": add-unit, num, qty, unit
#import "@preview/subpar:0.2.2"
#import "@preview/neoplot:0.0.3" as gp
#import "@preview/muchpdf:0.1.2": muchpdf


#show: ieee.with(
  title: [Fundamentals of RF and Microwave Engineering \ Homework assignment 2],
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

#nonumber(
  $
    lambda_0 = c_0 / f = qty("299 792 458", "meter per second") / qty("1.5", "giga hertz") = qty("0.199862", "meter")
  $,
)

#nonumber(
  $
    lambda_2 = lambda_0/sqrt(epsilon_r) = qty("0.199862", "meter") / sqrt(0.25) = qty("0.126404", "meter")
  $,
)

#nonumber(
  $
    beta_2 = (2 pi) / lambda_2 = (2 pi) / qty("0.126404", "meter") = qty("49.7073", "per meter")
  $,
)

#nonumber(
  $
    beta_2 l_2 = qty("49.7073", "per meter") dot qty("25", "Milli meter") = 1.24268
  $,
)

#nonumber(
  $
    Z_("in"2)
    &= Z_(0, 2) (Z_L + j Z_(0, 2) tan(beta_2 l_2))/(Z_(0, 2) + j Z_L tan(beta_2 l_2))
    = qty("50", "ohm") dot ((12.5 + j 25) unit("ohm") + j qty("50", "ohm")dot tan(1.24268))/(qty("50", "ohm") + j (12.5 + j 25) unit("ohm") dot tan(1.24268))\
    Z_("in"2) &= (158.567 - j 118.239) unit("ohm")
  $,
)

#nonumber(
  $
    beta_1 l_1 = (2 pi)/lambda_1 lambda_1/8 = pi/4
  $,
)

#nonumber(
  $
    Z_("in")
    &= Z_(0, 1) (Z_("in"2) + j Z_(0, 1) tan(beta_1 l_1))/(Z_(0, 1) + j Z_("in"2) tan(beta_1 l_1))
    = qty("25", "ohm") dot ((158.567 - j 118.239) unit("ohm") + j qty("25", "ohm")dot tan(pi/4))/(qty("25", "ohm") + j (158.567 - j 118.239) unit("ohm") dot tan(pi/4))\
    bold(Z_("in")) &= bold((4.3409 - j 21.0787) unit("ohm"))\
    bold(Z_"in") &= bold(qty("21.5211", "Ohm") " " angle qty("282.637", "Degree"))
  $,
)

#pagebreak()

= Exercise 2

#nonumber(
  $
    X_C_S & = 1/(2 Pi f C_S) = qty("19.9984", "Ohms") \
    x_C_S & = X_C_S / Z_0 = 0.399967 approx 0.4
  $,
)

#figure(
  image("E2.png", width: 50%),
  caption: [Circuit with marked sections],
)

#figure(
  image(
    "Charte2.svg",
  ),
  caption: [Solution for Exercise 2, All arrows start at $R_S = qty("0", "Ohms")$ and point to $R_S = infinity unit("Ohm")$],
)

= Exercise 3

== Determine the resistance $R_L$ in relation to $Z_0$
#nonumber(
  $
    "VSWR"_L = (1+abs(Gamma))/(1-abs(Gamma))\
    abs(Gamma) = ("VSWR"_L - 1)/("VSWR"_L + 1) = (10 - 1)/(10 + 1) = 9/11\
    Gamma = plus.minus 9/11
  $,
)

#nonumber(
  $
    Gamma = (R_L - Z_0)/(R_L + Z_0)\
    R_L/Z_0 = (1 + Gamma)/(1 - Gamma)\
    (R_L/Z_0)_1 = (1 + 9/11) / (1 - 9/11) =10\
    (R_L/Z_0)_2 = (1 - 9/11) / (1 + 9/11) = 1/10
  $,
)

Since $R_L < Z_0$ than solution must be $(R_L/Z_0) = 1/10$

== Calculate the resistance values of $R_L$ and $Z_0$, that $abs(Z_("in",1)) = R_L$

#nonumber(
  $
    beta l_1 = (2 pi)/lambda lambda/4 = pi/2 arrow tan(beta l_1) = infinity\
    Z_("in", 1) = Z_0^2/(j X_L) = Z_0^2/(j qty("100", "Ohm"))
  $,
)

#nonumber(
  $
    R_L/Z_0 = abs(Z_("in", 1))/Z_0 = abs((Z_0^2/(j X_L))/Z_0) = abs(Z_0/(j X_L))\
    Z_0 = abs(j X_L) R_L / Z_0 = abs(j qty("100", "Ohm")) / 10 = qty("10", "Ohm")\
  $,
)

#nonumber(
  $
    Z_("in", 1) = Z_0^2/(j X_L) = (qty("10", "Ohm"))^2 / (j qty("100", "Ohm")) = j qty("1", "Ohm")\
    R_L = abs(Z_("in", 1)) = qty("1", "Ohm")
  $,
)

== Calculate the resistance $Z_p$ of the parallel circuit of $R_L$ and the resistance $Z_("in", 1)$

#nonumber(
  $
    beta l_2 = (2 pi)/lambda lambda = 2 pi arrow tan(beta l_2) = 0\
    Z_("in", 2) = Z_0 R_L/Z_0 = R_L = qty("1", "Ohm")
  $,
)

#nonumber(
  $
    Z_p = (Z_("in", 1) R_L)/(Z_("in", 1)+ R_L) = (j qty("1", "Ohm") dot qty("1", "Ohm"))/(j qty("1", "Ohm") + qty("1", "Ohm")) = (j qty("1", "Ohm Squared"))/((1+j) unit("Ohm")) = (1+j)/2 unit("Ohm")
  $,
)

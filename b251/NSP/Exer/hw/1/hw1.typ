#import "@preview/ieee-monolith:0.1.0": ieee
#import "@preview/subpar:0.2.2"
#import "@preview/physica:0.9.7": *

#show: ieee.with(
  title: [442.022 Nonlinear Signal Processing \ Assignment 1\ Memoryless & Fading Memory Systems],
  authors: (
    (
      name: "Tomáš Kysela",
      department: "12513690",
    ),
    (
      name: "?",
      department: "?",
    ),
  ),
)

= Universal Approximators and System Identification
== Implement a polynomial model

#figure(
  image("fitPoly.png", height: 30%),
  caption: [MSEs of polynomials of different orders],
) <fig:fitPoly>

#figure(
  image("resPoly.png", height: 30%),
  caption: [Traing/Testing data and polynomial models of best orders],
)

In Figure @fig:fitPoly we can see that error of Testing data starts getting bigger after order of 12. This happens due to overfitting. Because of this we should choose order of at most 12. Since MSE is nearly constant between orders 8 and 12, it is probably best to use order 8, since it saves as computational power and space. For this order MSE of train/test dataset is 0.1695~/~0.1422. This is also the best result for test data. The best result for training data is for order 12 0.1473, but test data get MSE of 0.1843.

== Split test set into test and validation sets

#figure(
  image("fitVal.png", height: 30%),
  caption: [MSEs of polynomials of different orders],
) <fig:fitVal>

#figure(
  image("resVal.png", height: 30%),
  caption: [Traing/Testing data and polynomial models of best orders],
)
Based on validation set Polynomial model of order 7 with train/validation/test MSEs of 0.1695~/~0.1279~/~0.1631. This result is different based on choice of datasets, since we randomly choose 60% of test data as validation and 40% as test data. This split gives bigger accuracy for validation data, based on which we choose best model. Smaller test dataset would not be possible, since it would be too small for any relevant results.
== Implement a Gaussian radial basis function (RBF) model

#figure(
  image("fitRBF.png", height: 30%),
  caption: [MSEs of RBF models of different orders],
) <fig:fitRBF>

#figure(
  image("resRBF.png", height: 30%),
  caption: [Traing/Testing data and RBF models of best orders],
)

In Figure @fig:fitRBF, we can see, that higher order makes model much accurate. Unlike with polynomial model, overfitting does not occur with higher order models. But after order 8, the accuracy does not increase, so there is no real advantage to use these orders.

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    image("fitRBFTrain.png", height: auto),
    caption: [Train data],
  ),
  figure(
    image("fitRBFTest.png", height: auto),
    caption: [Test data],
  ),

  caption: [Comparison of MSEs for different Lenghtscales],
  label: <fig:fitRBFMulti>,
)

Figure @fig:fitRBFMulti shows comparison of different Lenghtscales. There is clear advantage in higher scales until scale of 10. This difference is bigger for lower order models. With order of 15 all differences are negligible. This task could be implemented like this thanks to lower dimension of data. As dimensions increase, the volume of the space increases exponentially, making it hard to cover the space densely with RBF centers manually.

== Implement a simple feed-forward neural network

#figure(
  image("fitMLP.png", height: 30%),
  caption: [MSEs during training epochs],
) <fig:fitMLP>

#figure(
  image("resMLP.png", height: 30%),
  caption: [Traing/Testing data and final model],
)

The network was designed to be 2 layer network with first layer of hidden size 32, than ReLu activation layer, another layer of size 32 and tanh activation layer. This proved to be quite effective design as seen in figure @fig:fitMLP. Other tried approaches didn't either reach same success level (for example when sigmoid activation layers were used), or the training was significantly slower.

== Comapare the models

Polynomial models were fastest to train and simplest to understand. Their big disadvantage is their prones for overfitting. On the other hand RBF filters fixed this issue with tradeoff of being not great to predict results outside training area. For best general purpose model, the neural network proved to be the most robust. But understanding what's going on and training the model is significantly harder than with the other two models.


= Harmonic Analysis and Equalization
An arbitrary memory-less system $f(dot)$ can be approximated by its $K^("th")$ -order Taylor series expansion
$
  hat(f)(x[n]) = sum_(k=0)^K 1/(k!) evaluated(dv(f(z), z, k))_(z=c) (x[n]-c)^k
$
around the center $c$ for any input signal $x[n]$.
== Analytically derive the coefficients $alpha_0, ... , alpha_3$ for a generic system $f(dot)$

Fitst, let's calculate all the terms of 3rd order Taylor series. This is done in equations @eq:tterm1, @eq:tterm2 and @eq:tterm3 (0-th term was skipped)

$
  taylorterm(f, x[n], c, 1) = f^((1))(c) x[n] - f^((1))(c) c
$ <eq:tterm1>

$
  taylorterm(f, x[n], c, 2) = (f^((2))(c))/2! (x^2[n] - 2x[n]c + c^2)
$ <eq:tterm2>

$
  taylorterm(f, x[n], c, 3) = (f^((3))(c))/3! (x^3[n] - 3 x^2[n] c + 3 x[n] c^2 - c^3)
$ <eq:tterm3>

Next in equations @eq:talph0, @eq:talph1, @eq:talph2 and @eq:talph3 $x[n]$ and calculate $alpha_k$

$
  f(c) - f^((1))(c) c + (f^((2))(c))/2 c^2 - (f^((3))(c))/6 c^3 = alpha_0
$ <eq:talph0>

$
  f^((1))(c) x[n] - (f^((2))(c))/2! 2x[n]c + (f^((3))(c))/3! 3 x[n] c^2 & = alpha_1 x[n] \
                         f^((1))(c) - f^((2))(c) c + (f^((3))(c))/2 c^2 & = alpha_1
$ <eq:talph1>

$
  (f^((2))(c))/2! x^2[n] - (f^((3))(c))/3! 3 x^2[n] c & = alpha_2 x^2[n] \
                    (f^((2))(c))/2 - (f^((3))(c))/2 c & = alpha_2
$ <eq:talph2>

$
  (f^((3))(c))/3! x^3[n] & = alpha_3 x^3[n] \
          (f^((3))(c))/6 & = alpha_3
$ <eq:talph3>

Now consider the system
$
  f(z) = sigma(z) = 1/(1 + e^(-z))
$

== Determine the necessary derivatives of $sigma(z)$ and implement the approximation and plot the true system's response $f(z)$ vs. the approximated system response $hat(f)(z)$ at expansion centers $c in {0, 2}$ for the input range $z in [-2, 4]$.

First we determine the derivatives of $sigma$. This is done in equations @eq:sig0, @eq:sig1, @eq:sig2 and @eq:sig3.

$
  sigma^((0))(z) = 1/(1+e^(-z))
$ <eq:sig0>

$
  sigma^((1))(z) = e^(-z)/(1+e^(-z))^2
$ <eq:sig1>

$
  sigma^((2))(z) = (2e^(-2z))/(1+e^(-z))^3 - e^(-z)/(1+e^(-z))^2
$ <eq:sig2>

$
  sigma^((3))(z) = e^(-z)/(1+e^(-z))^2 - (6e^(-2z))/(1+e^(-z))^3 + (6e^(-3z))/(1+e^(-z))^4
$ <eq:sig3>

For $c = 0$ we get equation @eq:c0 $c = 2$ we get equation @eq:c1.

$
  hat(f) = 1/2 + 1/4 z + 0 z^2 - 1/48 z^3
$ <eq:c0>

$
  hat(f) & = (e^2 (-1 + 13 e^2 - 7 e^4 + 3 e^6))/(3 (1 + e^2)^4) + (e^2 - 6 e^4 + 5 e^6)/(1 + e^2)^4 z \
         & - (e^2 (1 - 8 e^2 + 3 e^4))/(2 (1 + e^2)^4) z^2 + (e^2 - 4 e^4 + e^6)/(6 (1 + e^2)^4) z^3
$ <eq:c1>

#figure(
  image("taylor.png", height: 30%),
  caption: [Plot of approximations and original system],
)

== Analytically derive the coefficients $beta_0, ... , beta_3$ for a generic system $f(A cos(theta_0 n))$
First we substitute the given system equation into generic system equation giving us:
$
  hat(f)(x[n]) = alpha_0 + alpha_1 (A cos(theta_0 n)) + alpha_2 (A cos(theta_0 n))^2 + alpha_3 (A cos(theta_0 n))^3
$

Next we use trigonometric identities to modify second and third order terms:

$
  alpha_2 (A cos(theta_0 n))^2 = alpha_2 A^2 1/2 (1 + cos(2 theta_0 n)) = (alpha_2 A^2)/2 + (alpha_2 A^2)/2 cos(2 theta_0 n)
$

$
  alpha_3 (A cos(theta_0 n))^3 & = alpha_3 A^3 1/4 (3 cos(theta_0 n) + cos(3 theta_0 n)) \
                               & = (3 alpha_3 A^3)/4 cos(theta_0 n) + (alpha_3 A^3)/4 cos(3 theta_0 n)
$

Then spliting based on new terms of $theta$ we get equations giving us $beta_0$...$beta_3$

$
  alpha_0 + (alpha_2 A^2)/2 = beta_0
$ <eq:tbet0>

$
  alpha_1 (A cos(theta_0 n)) + (3 alpha_3 A^3)/4 cos(theta_0 n) & = beta_1 cos(theta_0 n) \
                                  alpha_1 A + (3 alpha_3 A^3)/4 & = beta_1
$ <eq:tbet1>

$
  (alpha_2 A^2)/2 cos(2 theta_0 n) & = beta_2 cos(2 theta_0 n) \
                   (alpha_2 A^2)/2 & = beta_2
$ <eq:tbet2>

$
  (alpha_3 A^3)/4 cos(3 theta_0 n) & = beta_3 cos(3 theta_0 n) \
                   (alpha_3 A^3)/4 & = beta_3
$ <eq:tbet3>

== Plot the output signals for test signals $f(A cos(theta_0 n) + A_0)$

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    image("taylorcos10.png", width: auto),
    caption: [Time domain],
  ),
  figure(
    image("taylorcos10dft.png", width: auto),
    caption: [DFT magnitude],
  ),

  caption: [Results for $A = 1$ and $A_0 = 0$],
)

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    image("taylorcos12.png", width: auto),
    caption: [Time domain],
  ),
  figure(
    image("taylorcos12dft.png", width: auto),
    caption: [DFT magnitude],
  ),

  caption: [Results for $A = 1$ and $A_0 = 2$],
)

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    image("taylorcos30.png", width: auto),
    caption: [Time domain],
  ),
  figure(
    image("taylorcos30dft.png", width: auto),
    caption: [DFT magnitude],
  ),

  caption: [Results for $A = 3$ and $A_0 = 0$],
)

#subpar.grid(
  columns: (1fr, 1fr),
  figure(
    image("taylorcos32.png", width: auto),
    caption: [Time domain],
  ),
  figure(
    image("taylorcos32dft.png", width: auto),
    caption: [DFT magnitude],
  ),

  caption: [Results for $A = 3$ and $A_0 = 2$],
)

From these figures, we can see, that when $A_0 = c$ the approximation works, when this is not the case, there is huge mismatch in DC offset.

Big amplitudes cause sigmoid to overshoot, this can be negated by staying within amplitude of 1.

= Propagation of Uncertainty

== Derive an expression for the conditional density $p_bold(hat(w)|z)$ of the measurements $bold(hat(w))$ when observing the true position $bold(z)$.

Since $bold(z)$ is observed, the term $bold(w) = f(bold(z))$ is deterministic, we can use the hint given and say the probability of given outcome is

$
  p_bold(w|z) = delta(bold(w) - f(bold(z)))
$

Than we setup sum $bold(hat(w)) = bold(w) + bold(nu)$. For sum of independent variables equation @eq:indsum holds.

$
  p_bold(hat(w)|z)(bold(hat(w))) = integral p_bold(nu)(bold(hat(w))-bold(u))p_bold(w|z)(bold(u))"d"bold(u)
$ <eq:indsum>

Applying sifting property we get following equation:

$
  p_bold(hat(w)|z)(bold(hat(w)))= p_bold(nu)(bold(hat(w))-f(bold(z)))
$

== Compute the conditional expectation $EE_bold(hat(w)|z)(bold(hat(w)))$ of the measurements for a given true position. Is this an unbiased estimate for the true polar coordinates $bold(w)$? <sec:estw>

First, let's use the linearity of expectation, giving us equation @eq:linexp.

$
  EE_bold(hat(w)|z) = EE(f(bold(z))|bold(z)) + EE(bold(nu)|bold(z))
$ <eq:linexp>

Since expectation of constant is contant, we can say that $EE(f(bold(z))|bold(z)) = f(bold(z))$ and since we know, that $bold(nu)$ is zero-mean noise, we get $EE(bold(nu)|bold(z)) = 0$. Meaning $EE_bold(hat(w)|z) = f(bold(z))$

Since $EE_bold(hat(w)|z)$ is exactly equal to true value of $bold(w)$ we can say, that this estimate is unbiased.

== Compute the conditional expectation $EE_bold(hat(w)|z) (bold(hat(z))) = EE_bold(hat(w)|z)(f^(-1)(bold(hat(w))))$ of the estimated position in Cartesian coordinates for a given true position. Is this in general an unbiased estimate for the true coordinates $bold(z) = f^(-1)(bold(w)$? <sec:estz>

First we substitute transformation into the given equation and apply independence, giving us equations @eq:exptrue and @eq:exptruesplit.

$
  EE_bold(hat(w)|z) (bold(hat(z))) = EE mat((r+nu_r)cos(phi + nu_phi); (r+nu_r)sin(phi + nu_phi))
$ <eq:exptrue>

$
  EE(hat(x)) & = EE(r+nu_r) dot EE(cos(phi + nu_phi)) \
  EE(hat(y)) & = EE(r+nu_r) dot EE(sin(phi + nu_phi))
$ <eq:exptruesplit>

Since noise is zero-mean, radial term is straight forward giving us following:

$
  EE(r+nu_r) = r + EE(nu_r) = r
$

For angular terms we use trigonometric addition resulting in following equation:

$
  EE(cos(phi + nu_phi)) & = cos(phi) EE(cos(nu_phi)) - sin(phi)EE(sin(nu_phi)) \
  EE(sin(phi + nu_phi)) & = sin(phi) EE(cos(nu_phi)) + cos(phi)EE(sin(nu_phi))
$

Combining these terms, resulting expectation is:
$
  EE_bold(hat(w)|z) (bold(hat(z))) = r mat(cos(phi) EE(cos(nu_phi)) - sin(phi)EE(sin(nu_phi)); sin(phi) EE(cos(nu_phi)) + cos(phi)EE(sin(nu_phi)))
$

For this estimate to be unbiased, we would need $EE(cos(nu_phi)) = 1$ and $EE(sin(nu_phi)) = 0$. The second predisposition can be true for symmetric noise, the first one would not generaly happen, meaning this is biased estimate.

== Which estimator would you choose and why? What assumptions about the noise model are crucial for your decision?

In @sec:estw we found out, that $EE(bold(hat(w))) = bold(w)$, menaing that for $N arrow inf$ equation $1/N sum_n bold(hat(w))_n = bold(w)$. This means that estimator $bold(hat(z)_A)$ gives result close to real value if big enough N is used.

In @sec:estz we found out that $EE(f^(-1)(bold(hat(w)))) = EE(bold(hat(z))) eq.not bold(z)$. This means, that even with big enough N we can't get good estimate of $bold(z)$ using estimator $bold(hat(z)_B)$.

Because of this arguing, using estimator $bold(hat(z)_A)$ is the better choice.

$$
\begin{align*}
u(l) &= {0.001 \over \sqrt{12}} = 0.000289m\\
u(D) &= {0.00002 \over \sqrt{12}} = 0.000006m\\
--&---\\
\bar{d} &= {1 \over 10}\sum_{i=1}^{10}d_i\\
\bar{d} &= 1.18mm = 0.001182m\\\\
u_A(d) &= \sqrt{{1 \over 90}\sum_{i=1}^{10}(d_i-\bar{d})^2}\\
u_A(d) &= 0.00000290593m\\\\
u_B(d) &= {0.00001 \over \sqrt{12}} = 0.000003m\\\\
u(d) &= \sqrt{u_A^2(d)+u_B^2(d)}\\
u(d) &= \sqrt{0.00000290593^2+0.000003^2}\\
u(d) &= 0.00000417665m\\
--&---\\
100T_k &= 551.5s\\
551.2s < 1&00T_k < 551.8s\\
5.512s < &T_k < 5.518s\\
T_k &= 5.515s\\
u(T_k) &= 0.003s
\end{align*}
$$

-----

$$
\begin{align*}
J &= 0.5mR^2\\
J &= 0.5\cdot 6.22kg\cdot 0.13025^2m\\
J &= 0.052761 kg\cdot m^2\\\\
u(J) &= \sqrt{({R^2 \over 2})^2u^2(m)+(mR)^2u^2(R)}\\
u(J) &= \sqrt{({0.13025^2m \over 2})^2\cdot 0+(6.22kg\cdot 0.13025)^2\cdot 0.000003^2}\\
u(J) &= 0.000002430465 kg\cdot m^2\\
--&---\\
G &= {32 \pi l J \over d^4 T_k^2}\\
G &= {32 \pi 0.88m \cdot  0.052761 kg\cdot m^2 \over 0.001182^4m \cdot  5.515^2s}\\
G &= 7.86203\cdot 10^{10} J\cdot s\\\\

u(G) &= \sqrt{({\partial G \over \partial l})^2u^2(l) + ({\partial G \over \partial J})^2u^2(J) + ({\partial G \over \partial d})^2u^2(d) + ({\partial G \over \partial T_k})^2u^2(T_k)}\\

u(G) &= \sqrt{({32 \pi J \over d^4 T_k^2})^2u^2(l) +
({32 \pi l \over d^4 T_k^2})^2u^2(J) +
({-128 \pi J l \over d^5 T_k^2})^2u^2(d) +
({-64 \pi J l \over d^4 T_k^3})^2u^2(T_k)}\\

u(G) &= \sqrt{
({32 \pi \cdot  0.052761 \over 0.001182^4 \cdot  5.515^2})^2\cdot 0.000289^2 +
({32 \pi \cdot  0.88 \over 0.001182^4 \cdot  5.515^2})^2\cdot 0.000002430465^2 +\\
({-128 \pi \cdot  0.052761 \cdot  0.88 \over 0.001182^5 \cdot  5.515^2})^2\cdot 0.00000417665^2 +
({-64 \pi \cdot  0.052761 \cdot  0.88 \over 0.001182^4 \cdot  5.515^3})^2\cdot 0.003^2
}\\
u(G) &= \sqrt{6.66653 \cdot  10^{14} + 1.31166 \cdot  10^{13} + 1.23484 \cdot  10^{18} + 7.31612 \cdot  10^{15}}\\
u(G) &= 1.11483 \cdot  10^9J\cdot s\\\\

\bold{G} &= \bold{(7.86 \pm 0.11)\cdot 10^{10} J\cdot s}
\end{align*}
$$

-----

$$
\begin{align*}
100T_k &= 93.2 s\\
T_k &= 0.932s\\
--&---\\
J_r &= {d^4 T_k^2 G \over 32 \pi l}\\
J_r &= {0.001182^4m \cdot 0.932^2s \cdot 7.86203\cdot10^{10} J\cdot s \over 32 \pi 0.88m}\\
J_r &= 0.001507kg\cdot m^2 = 1.507 g\cdot m^2\\\\

u(J_r) &= \sqrt{
({\partial J_k \over \partial d})^2u^2(d) +
({\partial J_k \over \partial T_k})^2u^2(T_k) +
({\partial J_k \over \partial G})^2u^2(G) +
({\partial J_k \over \partial l})^2u^2(l)
}\\

u(J_r) &= \sqrt{
({d^3 T_k^2 G\over 8 \pi l})^2u^2(d) +
({d^4 T_k G \over 16 \pi l})^2u^2(T_k) +
({d^4 T_k^2 \over 32 \pi l})^2u^2(G) +
({-d^4 T_k^2 G \over 32 \pi l^2})^2u^2(l)
}\\

u(J_r) &= \sqrt{
({0.001182^3 0.932^2 7.86203\cdot10^{10}\over 8 \pi 0.88})^2\cdot0.00000417665^2 +\\
({0.001182^4 0.932 7.86203\cdot10^{10} \over 16 \pi 0.88})^2\cdot0.003^2 +
({0.001182^4 0.932^2 \over 32 \pi 0.88})^2\cdot(1.11483 \cdot 10^9)^2 +\\
({-0.001182^4 0.932^2 7.86203\cdot10^{10} \over 32 \pi 0.88^2})^2\cdot0.000289^2
}\\

u(J_r) &= \sqrt{4.53575 \cdot 10^{-10} + 9.40976 \cdot 10^{-11} + 4.56516 \cdot 10^{-10} + 2.44871 \cdot 10^{-13}}\\
u(J_r) &= 0.0000316928 kg\cdot m^2 = 0.0316928 g\cdot m^2\\\\
\bold{J_r} &= \bold{(1.507 \pm 0.032) g\cdot m^2}
\end{align*}
$$

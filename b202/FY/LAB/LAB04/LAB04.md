$$
\begin{align*}
\bar{d} &= {1 \over N}\sum_{i=1}^Nd_i\\
\bar{d} &= {1 \over 12}\sum_{i=1}^{12}d_i\\
\bar{d} &= {1 \over 12}*23.94mm\\
\bar{d} &= 1.995mm\\
--&---\\
u_A(d) &= \sqrt{{1 \over N(N-1)}\sum_{i=1}^N(d_i-\bar{d})^2}\\
u_A(d) &= \sqrt{{1 \over 12(12-1)}\sum_{i=1}^{12}(d_i-1.995)^2}\\
u_A(d) &= \sqrt{{1 \over 132}*0.0003}\\
u_A(d) &= 0.001414mm\\
--&---\\
u_A(d) &= {0.01 \over \sqrt{12}}\\
u_B(d) &= 0.002887mm\\
--&---\\
u_C(d) &= \sqrt{u_A^2(d)+u_B^2(d)}\\
u_C(d) &= \sqrt{0.001414^2+0.002887^2}\\
u_C(d) &= 0.00321468mm\\
--&---\\
\bar{r} &= {\bar{d} \over 2}\\
\bar{r} &= {1.995mm \over 2}\\
\bar{r} &= 0.9975mm\\
--&---\\
u(r) &= \sqrt{{\partial r \over \partial d}^2u_C^2(d)}\\
u(r) &= \sqrt{{1 \over 2}^2*0.00321468^2}\\
u(r) &= 0.00160734mm\\
--&---\\
\bar{m} &= {1\over12}(m_{celkem} - m_{miska})\\
\bar{m} &= {1\over12}(22.4593g - 22.0744g)\\
\bar{m} &= 0.032075g\\
--&---\\
u(m) &= {0.0001 \over \sqrt{12}}\\
u(m) &= 0.0000288675g\\
--&---\\
\bar{\rho_k} &= {\bar{m} \over {4 \over 3} \pi \bar{r}^3}\\
\bar{\rho_k} &= {0.032075g \over {4 \over 3} \pi 0.9975mm^3}\\
\bar{\rho_k} &= 0.007715 g*mm^{-3} = 7715 kg*m^{-3}\\
u(\rho_k) &= \sqrt{({\partial \rho_k \over \partial r})^2u^2(r)+({\partial \rho_k \over \partial m})^2u^2(m)}\\
u(\rho_k) &= \sqrt{({-9\bar{m} \over 4 \pi \bar{r}^4})^2u^2(r)+({3 \over 4 \pi \bar{r}^3})^2u^2(m)}\\
u(\rho_k) &= \sqrt{({-9*0.032075g \over 4 \pi *0.9975mm^4})^2*0.00160734mm^2+({3 \over 4 \pi * 0.9975mm^3})^2*0.0000288675g^2}\\
u(\rho_k) &= 0.0000379363 g*mm^{-3} = 37.9363 kg*m^{-3}\\
--&---\\
u_B(\Delta L) &= {0.001 \over \sqrt{12}}\\
u_B(\Delta L) &= 0.000289m\\
--&---\\
u(\Delta L) &= \sqrt{0.002^2m+0.000289^2m}\\
u(\Delta L) &= 0.00202077m\\
--&---\\
u(\rho) &= {5 \over \sqrt{12}}\\
u(\rho) &= 1.443376 kg*m^{-3}\\
--&---\\
\bar{T} &= {1 \over N}\sum_{i=1}^N T_i\\
\bar{T} &= {1 \over 8}\sum_{i=1}^8 T_i\\
\bar{T} &= {1 \over 8}*287.9\\
\bar{T} &= 35.9875s\\
--&---\\
u_A{T} &= \sqrt{{1 \over N(N-1)}\sum_{i=1}^N(T_i-\bar{T})^2}\\
u_A{T} &= \sqrt{{1 \over 8(8-1)}\sum_{i=1}^8(T_i-35.9875)^2}\\
u_A{T} &= \sqrt{{1 \over 8(8-1)}0.016950}\\
u_A{T} &= 0.0173977s\\
--&---\\
u_B{T} &= {0.01 \over \sqrt{12}}\\
u_B{T} &= 0.002887s\\
--&---\\
u{T} &= \sqrt{u_A^2{T}+u_B^2{T}+T_{reakce}^2}\\
u{T} &= \sqrt{0.0173977^2+0.002887^2+0.169^2}\\
u{T} &= 0.169918s
\end{align*}
$$

-----

$$
\begin{align*}
\bar{\eta} &= {2 \over 9}*g*r^2*(\rho_k-\rho)*{\Delta T \over \Delta L}\\
\bar{\eta} &= {2 \over 9}*9.81*0.0009975^2*(7715-965)*{35.9875 \over 0.55}\\
\bar{\eta} &= 0.958021 N*s*m^{-2}\\
--&---\\
u(\eta) &= \sqrt{({\partial \eta \over \partial r})^2u^2(r)+({\partial \eta \over \partial \rho_k})^2u^2(\rho_k)+({\partial \eta \over \partial \rho})^2u^2(\rho)+({\partial \eta \over \partial \Delta T})^2u^2(\Delta T)+({\partial \eta \over \partial \Delta L})^2u^2(\Delta L)}\\
u(\eta) &= \sqrt{
({4gr \Delta T (\rho_k-\rho) \over 9 \Delta L})^2u^2(r)
+
({2gr^2 \Delta T \over 9 \Delta L})^2u^2(\rho_k)
+
({2gr^2 \Delta T \over 9 \Delta L})^2u^2(\rho)
+\\
({2gr^2 (\rho_k-\rho) \over 9 \Delta L})^2u^2(\Delta T)
+
({-2gr^2 \Delta T (\rho_k-\rho) \over 9 \Delta L ^2})^2u^2(\Delta L)}\\
u(\eta) &= \sqrt{
({4*9.81*0.0009975*35.9875 (7715-965) \over 9 *0.55})^2*0.0000016073^2
+\\
({2*9.81*0.0009975^2 *35.9875 \over 9 *0.55})^2*37.9363^2
+
({2*9.81*0.0009975^2 *35.9875 \over 9 *0.55})^2*1.443376^2\\
+
({2*9.81*0.0009975^2 (7715-965) \over 9 *0.55})^2*0.169918^2
+\\
({-2*9.81*0.0009975^2 *35.9875 (7715-965) \over 9 *0.55 ^2})^2*0.000289^2}\\
u(\eta) &= \sqrt{
0.000009531871942515+0.0000289902875797454+0.00000004196638309775+\\
0.000020460938337593788+0.00000025340806554346}\\
u(\eta) &= 0.0077N*s*m^{-2}\\
--&---\\
\bold{\eta} &= \bold{(0.9580 \pm 0.0077)N*s*m^{-2}}
\end{align*}
$$


# 1 Škálování

## a) hmotnost King Konga (dále jen KK)

- výška KK: **60m** (dle porovnání obrázku ze zadání a plánů[^fn1])
- výška gorily: 1,4 - 1,8 m[^fn2], použijme tedy průměr **1,6m**
- hmotnost gorily: 70 - 275kg[^fn2], uvažujme tedy mírně nadprůměrnou gorilu vážící **200kg**

$$
C={{v_{KK}}\over{v_{gorila}}}={60m\over1.6m}=37.5 \\
\begin{align*}
m_{KK}&=C^3*m_{gorila} \\
m_{KK}&=37.5^3*200kg \\
m_{KK}&=52734{3\over8}*200kg \\
m_{KK}&=10546875kg \\
m_{KK}&=10546.875t \doteq \bold{10547t}
\end{align*}
$$

## b) nutná plocha průřezu jeho stehenní kosti když stojí vzpřímeně

- maximální zátěž kosti při tlaku: **200MPa**[^fn3]
  $$
  P = 200MPa = 2*10^8 N/m^2 \\
  \begin{align*}
  S_{femur} &= {F_g \over P} \\
  S_{femur} &= {{m_{KK} \over 2}*a_g \over P} \\
  S_{femur} &= {{10546875kg \over 2}*9,823m/s^2 \over 2*10^8 N/m^2} \\
  S_{femur} &= {51800976.56N \over 2*10^8N/m^2} \\
  S_{femur} &= 0.259004883m^2 \\
  S_{femur} &\doteq \bold{0.259m^2}
  \end{align*}
  $$

  ## c) síla stisku ruky KK

  - síla gorily: **10x její hmotnost** [^fn4]
    $$
    \begin{align*}
    m_{G_{gorila}}=10*m_{gorila} \implies m_{G_{KK}} &= C^2*(10*m_{gorila}) \\
    m_{G_{KK}} &= 37.5^2*(10*200kg) \\
    m_{G_{KK}} &= 1406.25*2000kg \\
    m_{G_{KK}} &= 2812500kg \\
    m_{G_{KK}} &= \bold{2812.5t}
    \end{align*}
    $$

## d) proč může nebo nemůže být gorila o velikosti King Konga

Gorila stráví již v běžné velikosti zhruba polovinu dne jezením a sháněním potravy a tzřetinu dne spánkem. [^fn5]King Kong by s jeho velikostí a tudíž i značně větší spotřebou živin prostě nestíhal obstarávat potravu a spát, tusíž by dříve, nebo později zemřel hladem,vyčerpáním, nebo obojím.

[^fn1]: ![Dimensions of Empire State Building](F:\Projects\Biomechanics\1\es_dimensions.jpg)
[^fn2]: <https://safaripark.cz/cz/zvirata-a-expozice/lexikon-zvirat/gorila-nizinna>
[^fn3]: <https://is.muni.cz/el/1431/podzim2015/Bi6868/um/EKS_Biomechanika_2015.pdf> strana 16
[^fn4]: <https://storyteller.travel/how-strong-is-a-gorilla/>
[^fn5]: <https://www.berggorilla.org/en/gorillas/general/everyday-life/what-do-gorillas-do-all-day/#:~:text=Mountain%20gorillas%20spend%20about%20half,for%203.6%25%20of%20their%20time>
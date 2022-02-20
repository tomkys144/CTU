# EO1 otázky 2021
Autor: Josef Havlas

## 1. Napište jaké jsou možnosti určení časové odezvy lineárního systému na obecný vstupní signál a uveďte postup výpočtu. Jaké znáte „standardizovanéˇ odezvy a k čemu je lze použít.
Při znalosti impulzní odezvy lze pro vstupní signál $ u(t) $ určit výstupní signál:
$$
y(t) = \int_{-\infty}^\infty u(\tau)h(t-\tau)d\tau = u(t)*h(t)
$$
kde integrál je tzv. **konvolučním integrálem**

Pokud známe obraz vstupního signálu a přenos, lze snadno určit i obraz výstupního signálu $ Y(s) = U(s) \cdot H(s) $

### Odezva na jednotkový skok - přechodová charakteristika

Pro jednotkový skok $ U_1 = \bold{1}(t)$ je řešení rovnice
$$
w(t)=u_c(t)=1-e^{-t \over \tau}, t > 0
$$


které nazýváme přechodovou charakteristikou

![image-20220208192248044](/home/tomkys144/.config/Typora/typora-user-images/image-20220208192248044.png)

### Odezva na Diracův impuls

Pro $ u_1(t) = \delta(t) $ a při $ u_c(0_-)=0 $ bude řešení rovnice
$$
h(t)=u_c(t)={1\over\tau}e^{-t \over \tau}, t > 0
$$
![image-20220208192922452](/home/tomkys144/.config/Typora/typora-user-images/image-20220208192922452.png)

vztah mezi přechodovou a impulzní charakteristikou:
$$
h(t)={\partial w(t)\over \partial t}, w(t)=\int_{0_-}^t h(\tau)d\tau
$$

## 2. Definujte přenosovou funkci lineárního systému a napište jaké vlastnosti musí takový systém splňovat. Uveďte co lze pomocí přenosové funkce charakterizovat a k čemu ji lze využít.

Na základě tohoto popisu je definován tzv. přenos LT1 systému jako poměr Laplaceových obrazů výstupního a vstupního signálu při nulových počátečních podmínkách. 
$$
H(s)={Y(s) \over U(s)}
$$
Lineární, časově invariantní (LTI) systémy lze charakterizovat následujícími atríbuty: 
- Linearita: pokud se zvětší vstupní signál, tak se lineárně zvětší i signál výstupní
$$
y(t) = S\{u(t)\} \Rightarrow ay(t) = S \{au(t)\} = aS
$$
- Princip superpozice:  součet odezev na dílčí složky = celková odezva (vyplývá z línearity)
$$
y(t) = S\{au_1 (t) + bu_2(t)\} = y_1(t) + y_2(t) = aS\{u_1 (t)\} + bS\{u_2(t)\}
$$
- Časová invariance:  vlastnosti systému se nemění s časem
$$
y(t — t_o) = S\{u(t — t_o)\}
$$

Pokud známe obraz vstupního signálu a přenos, lze snadno určit i obraz výstupního signálu  $Y(s) = U(s) \cdot H (s)$. Časovou funkci pak dostaneme pomocí zpětné (inverzní) transformace. 

Lze z ní určit:

- stabilita systému
- koeficienty modulové charakteristiky
- přechodovou charakteristiku
- pokud je systém stabilní, tedy kmitočtovou charakteristiku $ s=j\omega $

## 

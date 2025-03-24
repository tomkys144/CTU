#import "@local/ctu-report:0.1.0": *
#import "@preview/subpar:0.2.1"
#import "@preview/unify:0.7.1": *

#show: it => ctu-report(
  doc-category: "BAM31BSG Laboratorní protokol",
  doc-title: "Lab 02: Měření rychlosti šíření nervových vzruchů",
  author: "Tomáš Kysela",
  language: "cs",
  show-outline: false,
  it,
)

#set par(justify: true)

= Úvod

Měření rychlosti vedení akčního potenciálu periferními nervy je důležitou diagnostickou metodou v neurofyziologii. V tomto měření se zaměříme na patelární reflex a jeho rychlost.

= Metodika

Měření probíhala pomocí přístroje Biopac. Na obě kolena byly připevněny elektrody (D+ a D-) pro měření EMG. Následně bylo využito tlačítka připevněného na tyč tak, že se vytvořilo improvizované neurologické kladívko s detekcí úderu. Měření probíhalo 1 minutu s údery přibližně po jedné sekundě.

= Analýza dat

V datech z tlačítka byly nalezeny pomocí prahování počátky všech 51 stimulů. Následně byla stanovena maximalní prodleva vědomé a samovolné reakce na podnět a to $qty("100", "milli second")$ pro samovolné reakce a $qty("500", "milli second")$ pro reakce vědomé.

Následně byly použity tři metody pro detekci vzruchů. Konkrétně metoda prahování s prahem 1, metoda detekce pomocí výkonové obálky a trojúhelníková metoda. Výsledky detekce pomocí těchto metod jsou zaznamenány v #ref(<table:res>, supplement: "Tabulce"). Z průměrné latence samovolné reakce a změřené vzdálenosti koleno - obratel L2, a to $qty("0.65", "meter")$, byla vypočtena průměrná rychlost vedení nervu.

#figure(
  table(
    columns: 6,
    [*Metoda*], [*A*], [*B*], [*C*], [*D*], [*E*],
    [Prahování],
    [$qty("90.196", "percent")$],
    [$qty("98.039", "percent")$],
    [$qty("34.11", "milli second")$],
    [$qty("85.24", "milli second")$],
    [$qty("38.11", "meter per second")$],

    [Výkonová obálka],
    [$qty("82.353", "percent")$],
    [$qty("96.078", "percent")$],
    [$qty("22.75", "milli second")$],
    [$qty("77.83", "milli second")$],
    [$qty("57.14", "meter per second")$],

    [Trojúhelníková],
    [$qty("100", "percent")$],
    [$qty("100", "percent")$],
    [$qty("11.92", "milli second")$],
    [$qty("53.33", "milli second")$],
    [$qty("109.05", "meter per second")$],
  ),
  caption: [Výsledky zpracování dat pomocí jednotlivých metod, A: Úspěšnost detekce samovolných reakcí, B: Úspěšnost detekce vědomých reakcí, C: Průměrná latence samovolných reakcí, D: Průměrná latence vědomých reakcí, E: Průměrná rychlost vedení nervu],
)<table:res>

= Závěr

Zdá se, že trojúhelníková metoda má nejvyšší procento úspěšnosti detekce odpovědí. Výsledky této metody jsou ale o dost nižší, respektive vyšší v případě rychlosti, než by se očekávalo. Latence by se mělo pohybovat okolo $qty("30", "milli second")$, kdy nejblíže tomuto očekávanému výsledku je metoda prahování, která i dosahuje druhé nejvyšší průměrné úspěšnosti detekce.

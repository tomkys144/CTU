reset

set term pngcairo
set output "resVal.png"

set datafile separator ','

set multiplot

set xlabel "Input"
set ylabel "Output"

set origin 0,0
set size 1,1
set xrange [-1.5:2]
set yrange [-4:7]

set key opaque

plot 'code/res/1_resVal.csv' using 1:2 with lines title "Chosen Model",\
    'code/res/1_resPoly.csv' using 1:2 with lines title "Best Train Model",\
    'code/res/1_resPoly.csv' using 1:3 with lines title "Best Test Model",\
    'code/data/csv/1_1_system_identification/training-set.csv'using 1:2 with points pt 4 title "Train data",\
    'code/res/1_dataVal.csv'using 1:2 with points pt 8 title "Validation data",\
    'code/res/1_dataTest.csv'using 1:2 with points pt 6 title "Test data"

set origin 0.53,0.38
set size 0.4, 0.35
set key off
set xrange [*:*]
set yrange [-1e11:1e11]
set ytics 1e11
set xtics 10
set xlabel ""
set ylabel ""
set object 1 rectangle from graph 0,0 to graph 1.1,1.1 back fc rgb "#ffffff"
replot

unset multiplot
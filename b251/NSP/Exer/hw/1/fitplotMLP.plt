reset

set term pngcairo
set output 'fitMLP.png'

set datafile separator ',' columnheaders

set key off

set style data linespoints

set xlabel 'Epoch'
set ylabel 'MSE'

plot  'code/res/1_fitMLP.csv' using 1:2 pt 7

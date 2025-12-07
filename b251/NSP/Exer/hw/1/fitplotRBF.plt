reset

set term pngcairo
set output 'fitRBF.png'

set datafile separator ',' columnheaders

set key autotitle columnheader

set style data linespoints

set xlabel 'Order'
set ylabel 'MSE'

plot for [i=2:3] 'code/res/1_fitRBF.csv' using 1:i pt 7

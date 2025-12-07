reset

set term pngcairo
set output 'fitRBFTest.png'

set datafile separator ',' columnheaders

set key autotitle columnheader

set style data linespoints

set key samplen 2 spacing 1 font ",10" above

set xlabel 'Order'
set ylabel 'MSE'

plot for [i=2:21] 'code/res/1_fitRBFTest.csv' using 1:i pt 7 title "lengthscale " . (i-1)

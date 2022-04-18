function[avr,sd,med,wavr]=kos_prumer(marks,credits)
   
avr = mean(marks);
sd = std(marks);
med = median(marks);

weight = marks .* credits;
wavr = sum(weight) / sum(credits);

end
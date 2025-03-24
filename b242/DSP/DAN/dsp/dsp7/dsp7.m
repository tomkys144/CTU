 x = [10 7 4 1 -2 -5 -8 -5 -2 1];
 %DCT-1 z definice DCT-1
 Xc1 = dctxc1(x);
 %vytvoření 2N -2 symetrické posloupnosti
 x1 = [x fliplr(x(2:(end -1)))];
 X1 = real(fft(x1));

 %DCT-2 z definice DCT-2
 Xc2 = dctxc2(x);

 %vytvoření 2N symetrické posloupnosti
 x2 = [x fliplr(x)];
 X2 = fft(x2);
 k = 0:1:length(x2) -1;
 X2 = real(exp(-i.*(k.*pi)./(length(x2))).*X2);

 figure(1)
 subplot(211)
 plot(Xc1)
 title("DCT1 z definice DCT1")
 xlim([1 18])
 subplot(212)
 plot(X1)
 title("DCT1 pomocí FFT")
 xlim([1 18])


 figure(2)
 subplot(211)
 stem(x)
 title("původní posloupnost")
 xlim([1 18])
 subplot(212)
 stem(x1)
 title("2N-2 posloupnost")
 xlim([1 18])

 figure(3)
 subplot(211)
 stem(x)
 title("původní posloupnost")
 xlim([1 20])
 subplot(212)
 stem(x2)
 title("2N posloupnost")
 xlim([1 20])

 figure(4)
 subplot(211)
 plot(Xc2)
 title("DCT2 z definice DCT2")
 xlim([1 20])
 subplot(212)
 plot(X2)
 title("DCT2 pomocí FFT")
 xlim([1 20])

 %dct v kepstru
 sig = loadbin("frame.bin");
 %reálné kepstrum
 c1 = rceps(sig);
 N = length(c1);
 %výběr poloviny spektra
 k = 1:N/2+1;
 c2 = log(abs(fft(sig)));
 c2 = c2(k);
 %kepstrum pomocí IDCT-1
 c2 = idctxc1(c2);
 
 figure(5)
 subplot(211)
 plot(c1)
 title("reálné kepstrum")
 xlim([0 N/2+1])
 subplot(212)
 plot(c2)
 title("kepstrum s DCT")
 xlim([0 N/2+1])
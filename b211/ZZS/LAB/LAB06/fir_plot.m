function fir_plot(b,fs,t)
figure();

subplot(221);
plot(t,b);
xlabel('time (s)');ylabel('b[k]');

subplot(223);
zplane(b,1);

[h, w] = freqz(b,1,1e4,fs);

subplot(222);
plot(w,20*log10(abs(h)))
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')

H = unwrap(angle(h));

subplot(224);
plot(w, 360/(2*pi)*H)
xlabel('Frequency (Hz)')
ylabel('Phase')
end


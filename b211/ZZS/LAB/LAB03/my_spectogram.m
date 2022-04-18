function[S,F,Ti]=my_spectogram(y,ww,nn,zz,fs)
idx=1:ww-nn:length(y)-ww+1;
win=hamming(ww); % váhovací okno délky segmentu
S=zeros((ww+zz), length(idx));

for i=1:length (idx)
    yseg=y(idx(i):idx(i)+ww-1);
    yseg=yseg.*win(:)';
    yseg=[yseg zeros(1, zz)];
    spec = (1/length(yseg))*abs((fft(yseg))^2);
    S(:,i)=spec';
end

F=linspace(0,fs-fs/(ww+zz),(ww+zz));
Ti=(idx+ww/2)/fs;% bez vektoru t
end
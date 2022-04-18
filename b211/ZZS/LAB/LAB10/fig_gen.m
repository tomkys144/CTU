function fig_gen(IMG,T,IMGT,tf_title, fig_title)
figure('Name', fig_title);

subplot(321)
imagesc(IMG); axis image; caxis([0 1])
colormap('gray');

subplot(322)
histogram(IMG(:),linspace(0,1,256));

subplot(323)
I=linspace(0,1,256);
T(T>1)=1;
T(T<0)=0;
plot(I,T);
xlabel('original intensity'); ylabel('new intensity'); title(tf_title);
xlim([0 1]); ylim([0 1]);

subplot(325)
imagesc(IMGT); axis image; caxis([0 1])
colormap('gray');

subplot(326)
histogram(IMGT(:),linspace(0,1,256));
end